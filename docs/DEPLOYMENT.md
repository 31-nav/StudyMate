# Production Deployment & Hardening Guide: StudyMate

This guide provides architectural specifications and configuration instructions for deploying StudyMate into a production Linux/Cloud environment.

---

## 1. Production Topology

```
Internet (HTTPS 443)
       │
       ▼
[ Nginx Reverse Proxy ]
  - SSL/TLS Termination (Let's Encrypt / Institutional Cert)
  - Rate Limiting (10 req/s per IP)
  - Gzip / Brotli Compression
  - Static Asset Caching
       │
       ▼ Reverse Proxy (HTTP 8080)
[ Apache Tomcat 10.1 (Jakarta EE 10) ]
  - JVM 21 LTS (G1GC, 4GB Heap)
  - StudyMate WAR (`/studymate` or `/` ROOT)
       │
       ├─── Physical Disk Volume (NFS / Block Storage)
       │    └── /var/studymate/uploads/
       │
       ▼ Connection Pool (HikariCP)
[ PostgreSQL 16 Cluster ]
  - Production DB: `studymate_prod`
  - Automated WAL Archiving & Daily Backups
```

---

## 2. Nginx Reverse Proxy Configuration

Create `/etc/nginx/sites-available/studymate.conf`:

```nginx
server {
    listen 80;
    server_name studymate.edu www.studymate.edu;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name studymate.edu www.studymate.edu;

    ssl_certificate /etc/letsencrypt/live/studymate.edu/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/studymate.edu/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # Maximum upload size (matches StudyMate 50MB limit)
    client_max_body_size 60M;

    # Reverse proxy to Tomcat 10
    location / {
        proxy_pass http://127.0.0.1:8080/studymate/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Buffering & timeouts
        proxy_connect_timeout 60s;
        proxy_read_timeout 120s;
        proxy_buffering off;
    }
}
```

---

## 3. Tomcat 10 Production Hardening

### 3.1 Connector Hardening (`conf/server.xml`)
Configure the HTTP/1.1 connector to trust proxy headers and disable server identification:
```xml
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443"
           server="StudyMate-Secure"
           xpoweredBy="false"
           maxThreads="250"
           minSpareThreads="25"
           acceptCount="100" />
```

### 3.2 JVM Tuning (`bin/setenv.sh`)
Create `bin/setenv.sh` with optimized memory and garbage collection parameters:
```bash
export JAVA_OPTS="-Xms2048m -Xmx4096m -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+ParallelRefProcEnabled -Djava.awt.headless=true -Dfile.encoding=UTF-8"
```

---

## 4. Automated Database Backup (`pg_dump`)

Configure a daily cron job to back up the PostgreSQL database:
```bash
#!/bin/bash
BACKUP_DIR="/var/backups/studymate"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
mkdir -p $BACKUP_DIR
pg_dump -U postgres -h localhost -d studymate -Fc -f "$BACKUP_DIR/studymate_$TIMESTAMP.dump"
# Keep only 14 days of backups
find $BACKUP_DIR -name "*.dump" -type f -mtime +14 -delete
```

