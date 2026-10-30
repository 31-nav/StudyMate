# Student User Manual: StudyMate

Welcome to **StudyMate** (*"Your Learning. Your Space."*). This guide will help you navigate your student portal, discover academic materials, manage your subjects, and customize your study space.

---

## 1. Getting Started

### 1.1 Account Registration
1. Navigate to the StudyMate home page (`http://localhost:8080/studymate/`).
2. Click **"Get Started"** or **"Register"** in the top navigation bar.
3. Fill in the required fields:
   - **Full Name**: Your legal or student name.
   - **Email Address**: Your university or personal email.
   - **Roll / Student ID**: (Optional) Your institutional identifier.
   - **Academic Program (Course)**: Select your degree (e.g., Computer Science).
   - **Current Semester**: Select your current active term (e.g., Semester 3).
   - **Password**: Create a strong password (minimum 8 characters).
   - **Terms Agreement**: Check the box accepting the platform terms.
4. Click **"Create Student Account"**.

### 1.2 Email Verification
- After registering, you will see the verification notice.
- Open the verification link sent to your registered email (or follow the on-screen link in development mode).
- Once verified, you will be redirected to the login screen with a success confirmation.

### 1.3 Signing In
- Enter your registered email and password at `/auth/login`.
- Upon successful authentication, you will be brought directly to your **Student Dashboard**.

---

## 2. Navigating the Student Dashboard

Your dashboard is your personalized learning hub:
- **Header Overview**: Displays your current enrolled program, semester, and greeting.
- **Quick Metric Counters**: Instant count of your enrolled subjects, saved bookmarks, and available study materials.
- **Recently Viewed Rail**: A quick-access carousel of documents you recently opened.
- **Active Announcements**: Important departmental notices and syllabus updates.

---

## 3. Discovering & Browsing Learning Materials

### 3.1 Browsing by Academic Hierarchy
1. Click **"Courses"** in the sidebar or top bar to see all academic degree programs.
2. Select your course to view its curriculum divided into **Semesters**.
3. Choose a semester to see all associated **Subjects** (e.g., *Data Structures & Algorithms*, *Database Systems*).
4. Click on any subject to open its curated resource library.

### 3.2 Filtering & Searching Materials
On the **Resources** page (`/student/resources`):
- **Search Bar**: Type any keyword (e.g., "Linked List", "Midterm", "SQL").
- **Category Filter**: Filter specifically by *Lecture Notes*, *Lecture Slides*, *Past Question Papers*, *Lab Manuals*, or *Syllabus Guides*.
- **Subject Filter**: Switch between different subjects within your semester.

---

## 4. Viewing & Downloading Resources

### 4.1 Embedded Document & Image Viewer
- Click **"View Material"** on any resource card.
- StudyMate opens the high-resolution inline document viewer:
  - **PDF Documents**: Read lecture slides and notes directly inside the browser with full zoom, page navigation, and full-screen controls.
  - **Educational Diagrams & Infographics**: View architectural diagrams, flowcharts, and high-resolution study sheets.
  - **External Reference Links**: Access authorized academic documentation, official tutorials, or research papers.

### 4.2 Downloading Materials
- If a resource is flagged as downloadable, click the **"Download File"** button in the resource card or viewer topbar.
- The file will be streamed directly to your device with its original filename.

---

## 5. Personalizing Your Study Space

### 5.1 Bookmarking Resources
- Click the **Bookmark** icon (ribbon icon) on any resource card.
- The icon turns solid blue, confirming the resource is saved to your bookmarks.
- Access all your saved materials anytime by clicking **"Bookmarks"** in the sidebar navigation.
- Click the bookmark icon again to remove it from your saved list.

### 5.2 Dark Mode / Light Mode Toggle
- Click the **Sun/Moon** icon in the top right navigation bar to toggle between Dark Mode and Light Mode.
- Your theme preference is saved automatically and restored whenever you visit.

---

## 6. Profile & Security Management

### 6.1 Updating Your Profile
- Navigate to **"Profile"** from the user dropdown menu.
- Update your display name, contact email, and student roll number.

### 6.2 Changing Your Password
1. Under the **Security** tab in your Profile page, enter your **Current Password**.
2. Enter your **New Password** and confirm it.
3. Click **"Update Password"**.

