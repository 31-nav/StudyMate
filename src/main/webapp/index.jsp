<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Your Learning. Your Space."/>
</jsp:include>
<body class="sm-body">
    <!-- Navbar Component -->
    <jsp:include page="/WEB-INF/views/components/navbar.jsp"/>

    <!-- Hero Section -->
    <section class="sm-hero position-relative py-5 overflow-hidden">
        <div class="sm-hero-glow"></div>
        <div class="container py-lg-5 position-relative z-1">
            <div class="row align-items-center g-5">
                <div class="col-lg-7 text-center text-lg-start">
                    <div class="d-inline-flex align-items-center gap-2 px-3 py-1 rounded-pill sm-glass-pill mb-4 border border-primary border-opacity-25">
                        <span class="badge bg-primary rounded-pill">New</span>
                        <span class="text-light small fw-medium">Centralized Academic Resource Hub</span>
                        <i class="bi bi-arrow-right text-primary"></i>
                    </div>

                    <h1 class="display-3 fw-bolder text-light tracking-tight mb-3">
                        Your Learning.<br>
                        <span class="sm-gradient-text">Your Space.</span>
                    </h1>

                    <p class="lead text-secondary mb-4 pe-lg-4 fs-5">
                        StudyMate transforms academic resource management into a centralized, beautifully organized digital campus. Access syllabus materials, lecture notes, lab manuals, and previous year examination papers in seconds.
                    </p>

                    <div class="d-flex flex-column flex-sm-row gap-3 justify-content-center justify-content-lg-start mb-5">
                        <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-primary btn-lg px-4 py-3 shadow-lg fw-semibold d-flex align-items-center justify-content-center gap-2">
                            <span>Get Started Free</span>
                            <i class="bi bi-arrow-right"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/courses" class="btn btn-outline-light btn-lg px-4 py-3 fw-semibold d-flex align-items-center justify-content-center gap-2">
                            <i class="bi bi-mortarboard"></i>
                            <span>Explore Courses</span>
                        </a>
                    </div>

                    <!-- Platform Live Stats -->
                    <div class="row g-3 pt-3 border-top border-secondary border-opacity-10">
                        <div class="col-6 col-md-3">
                            <h3 class="fw-bold text-light mb-0">${stats['totalCourses'] != null ? stats['totalCourses'] : 3}+</h3>
                            <small class="text-secondary">Programs</small>
                        </div>
                        <div class="col-6 col-md-3">
                            <h3 class="fw-bold text-light mb-0">${stats['totalSubjects'] != null ? stats['totalSubjects'] : 9}+</h3>
                            <small class="text-secondary">Subjects</small>
                        </div>
                        <div class="col-6 col-md-3">
                            <h3 class="fw-bold text-light mb-0">${stats['totalResources'] != null ? stats['totalResources'] : 12}+</h3>
                            <small class="text-secondary">Resources</small>
                        </div>
                        <div class="col-6 col-md-3">
                            <h3 class="fw-bold text-light mb-0">${stats['totalDownloads'] != null ? stats['totalDownloads'] : 0}+</h3>
                            <small class="text-secondary">Downloads</small>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="sm-glass-card p-4 rounded-4 shadow-2xl border border-secondary border-opacity-20 position-relative">
                        <div class="d-flex align-items-center justify-content-between mb-3 pb-3 border-bottom border-secondary border-opacity-10">
                            <div class="d-flex align-items-center gap-2">
                                <span class="p-2 rounded-circle bg-danger bg-opacity-25" style="width: 10px; height: 10px;"></span>
                                <span class="p-2 rounded-circle bg-warning bg-opacity-25" style="width: 10px; height: 10px;"></span>
                                <span class="p-2 rounded-circle bg-success bg-opacity-25" style="width: 10px; height: 10px;"></span>
                            </div>
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                <i class="bi bi-lightning-charge me-1"></i> Live Preview
                            </span>
                        </div>

                        <div class="mb-4">
                            <h5 class="fw-bold text-light mb-1">Data Structures & Algorithms</h5>
                            <span class="text-secondary small">Course: Computer Science &bull; Semester III</span>
                        </div>

                        <!-- Sample Resource Cards -->
                        <div class="d-flex flex-column gap-2 mb-4">
                            <div class="p-3 rounded-3 sm-resource-preview-item d-flex align-items-center justify-content-between">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="p-2 rounded bg-danger-subtle text-danger fs-5">
                                        <i class="bi bi-file-earmark-pdf"></i>
                                    </div>
                                    <div>
                                        <div class="fw-medium text-light small">Lecture_04_Trees_And_Graphs.pdf</div>
                                        <span class="badge bg-secondary-subtle text-secondary" style="font-size: 0.65rem;">PDF &bull; 2.4 MB</span>
                                    </div>
                                </div>
                                <span class="badge bg-success-subtle text-success">Verified</span>
                            </div>

                            <div class="p-3 rounded-3 sm-resource-preview-item d-flex align-items-center justify-content-between">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="p-2 rounded bg-primary-subtle text-primary fs-5">
                                        <i class="bi bi-journal-text"></i>
                                    </div>
                                    <div>
                                        <div class="fw-medium text-light small">Midterm_2025_Solved_Question_Paper</div>
                                        <span class="badge bg-secondary-subtle text-secondary" style="font-size: 0.65rem;">Past Paper &bull; 1.8 MB</span>
                                    </div>
                                </div>
                                <span class="badge bg-info-subtle text-info">Popular</span>
                            </div>

                            <div class="p-3 rounded-3 sm-resource-preview-item d-flex align-items-center justify-content-between">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="p-2 rounded bg-warning-subtle text-warning fs-5">
                                        <i class="bi bi-link-45deg"></i>
                                    </div>
                                    <div>
                                        <div class="fw-medium text-light small">VisualAlgo - Graph Traversal Interactive</div>
                                        <span class="badge bg-secondary-subtle text-secondary" style="font-size: 0.65rem;">Web Resource</span>
                                    </div>
                                </div>
                                <span class="badge bg-warning-subtle text-warning">External</span>
                            </div>
                        </div>

                        <div class="p-3 rounded-3 bg-primary bg-opacity-10 border border-primary border-opacity-20 d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-shield-check text-primary fs-4"></i>
                                <div>
                                    <div class="fw-semibold text-light small">Institutional Quality Assured</div>
                                    <div class="text-secondary" style="font-size: 0.75rem;">Verified by departmental faculty</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="py-5 border-top border-secondary border-opacity-10">
        <div class="container py-5">
            <div class="text-center max-w-xl mx-auto mb-5">
                <span class="text-primary text-uppercase fw-bold letter-spacing-1 small">Engineered For Excellence</span>
                <h2 class="display-6 fw-bold text-light mt-1 mb-3">Designed for Students. Built for Institutions.</h2>
                <p class="text-secondary">StudyMate brings order to academic chaos. Everything you need to excel in your semester exams, organized in one seamless portal.</p>
            </div>

            <div class="row g-4">
                <div class="col-md-4">
                    <div class="sm-card h-100 p-4 rounded-4">
                        <div class="p-3 rounded-3 bg-primary bg-opacity-10 text-primary d-inline-block mb-3 fs-3">
                            <i class="bi bi-diagram-3"></i>
                        </div>
                        <h4 class="fw-bold text-light mb-2">Structured Hierarchy</h4>
                        <p class="text-secondary mb-0">Browse through Courses &rarr; Semesters &rarr; Subjects &rarr; Categories effortlessly. Zero clutter, instant retrieval.</p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="sm-card h-100 p-4 rounded-4">
                        <div class="p-3 rounded-3 bg-success bg-opacity-10 text-success d-inline-block mb-3 fs-3">
                            <i class="bi bi-file-earmark-pdf"></i>
                        </div>
                        <h4 class="fw-bold text-light mb-2">In-Browser PDF Viewer</h4>
                        <p class="text-secondary mb-0">Built-in PDF.js integration lets you preview study materials, lecture slides, and notes without saving clutter to your local drive.</p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="sm-card h-100 p-4 rounded-4">
                        <div class="p-3 rounded-3 bg-warning bg-opacity-10 text-warning d-inline-block mb-3 fs-3">
                            <i class="bi bi-bookmark-star"></i>
                        </div>
                        <h4 class="fw-bold text-light mb-2">Bookmarks & Recents</h4>
                        <p class="text-secondary mb-0">Star essential notes and exam papers for instant access before midterms. Your reading history tracks right where you left off.</p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="sm-card h-100 p-4 rounded-4">
                        <div class="p-3 rounded-3 bg-info bg-opacity-10 text-info d-inline-block mb-3 fs-3">
                            <i class="bi bi-shield-lock"></i>
                        </div>
                        <h4 class="fw-bold text-light mb-2">Enterprise Security</h4>
                        <p class="text-secondary mb-0">BCrypt 12-round hashing, single-use SHA-256 tokens, strict CSRF validation, and storage strictly outside web roots.</p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="sm-card h-100 p-4 rounded-4">
                        <div class="p-3 rounded-3 bg-purple bg-opacity-10 text-info d-inline-block mb-3 fs-3">
                            <i class="bi bi-search"></i>
                        </div>
                        <h4 class="fw-bold text-light mb-2">Deep Academic Search</h4>
                        <p class="text-secondary mb-0">Filter by category (Notes, PYQs, Lab Manuals, Reference Books) or search full-text metadata with millisecond response times.</p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="sm-card h-100 p-4 rounded-4">
                        <div class="p-3 rounded-3 bg-danger bg-opacity-10 text-danger d-inline-block mb-3 fs-3">
                            <i class="bi bi-megaphone"></i>
                        </div>
                        <h4 class="fw-bold text-light mb-2">Real-Time Alerts</h4>
                        <p class="text-secondary mb-0">Receive instant push announcements about syllabus updates, exam schedules, and new faculty uploads.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Courses Section -->
    <section class="py-5 bg-dark bg-opacity-25 border-top border-secondary border-opacity-10">
        <div class="container py-4">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end mb-4">
                <div>
                    <span class="text-primary text-uppercase fw-bold letter-spacing-1 small">Academic Offerings</span>
                    <h2 class="h3 fw-bold text-light mb-1">Featured Degree Programs</h2>
                </div>
                <a href="${pageContext.request.contextPath}/courses" class="btn btn-sm-outline text-decoration-none mt-2 mt-md-0">
                    View All Programs <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>

            <div class="row g-4">
                <c:forEach var="c" items="${featuredCourses}">
                    <div class="col-md-4">
                        <div class="sm-card h-100 p-4 rounded-4 d-flex flex-column">
                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <span class="badge bg-primary-subtle text-primary fw-semibold">${c.courseCode}</span>
                                <span class="text-secondary small"><i class="bi bi-calendar3 me-1"></i> ${c.totalSemesters} Semesters</span>
                            </div>
                            <h4 class="fw-bold text-light mb-2"><c:out value="${c.courseName}"/></h4>
                            <p class="text-secondary small mb-4 flex-grow-1"><c:out value="${c.description}"/></p>
                            <a href="${pageContext.request.contextPath}/subjects?courseId=${c.courseId}" class="btn btn-sm btn-sm-primary mt-auto d-flex align-items-center justify-content-center gap-2">
                                <span>Browse Subjects</span>
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    <section id="how-it-works" class="py-5 border-top border-secondary border-opacity-10">
        <div class="container py-5">
            <div class="text-center max-w-xl mx-auto mb-5">
                <span class="text-primary text-uppercase fw-bold letter-spacing-1 small">Simplified Workflow</span>
                <h2 class="display-6 fw-bold text-light mt-1 mb-3">How StudyMate Empowers You</h2>
                <p class="text-secondary">Three quick steps to transform how you prepare for exams and assignments.</p>
            </div>

            <div class="row g-4 text-center">
                <div class="col-md-4">
                    <div class="p-4">
                        <div class="sm-step-number mb-3 mx-auto">1</div>
                        <h5 class="fw-bold text-light mb-2">Create Student Account</h5>
                        <p class="text-secondary small">Register with your institutional or personal email, select your enrolled degree program, and verify your email.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-4">
                        <div class="sm-step-number mb-3 mx-auto">2</div>
                        <h5 class="fw-bold text-light mb-2">Pick Semester & Subject</h5>
                        <p class="text-secondary small">Navigate directly to your ongoing semester and find subjects with curated modules and syllabus outlines.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-4">
                        <div class="sm-step-number mb-3 mx-auto">3</div>
                        <h5 class="fw-bold text-light mb-2">Preview & Master Materials</h5>
                        <p class="text-secondary small">Inspect lecture PDFs and solved question papers in the browser, download offline copies, and bookmark key topics.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="py-5 border-top border-secondary border-opacity-10">
        <div class="container py-4">
            <div class="sm-glass-card p-5 rounded-4 text-center border border-primary border-opacity-20 position-relative overflow-hidden">
                <div class="sm-hero-glow"></div>
                <div class="position-relative z-1">
                    <h2 class="display-5 fw-bold text-light mb-3">Ready to Upgrade Your Academic Space?</h2>
                    <p class="lead text-secondary max-w-xl mx-auto mb-4">
                        Join your classmates on StudyMate today. Centralize your lectures, notes, and past papers in one intelligent workspace.
                    </p>
                    <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-primary btn-lg px-5 py-3 fw-semibold shadow-lg">
                        Get Started Now &mdash; It's Free
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer Component -->
    <jsp:include page="/WEB-INF/views/components/footer.jsp"/>
</body>
</html>

