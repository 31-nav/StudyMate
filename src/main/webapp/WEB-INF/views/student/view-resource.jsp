<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="${resource.title}"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser}">
                <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
                    <jsp:param name="activeMenu" value="resources"/>
                </jsp:include>
            </c:when>
        </c:choose>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>
                </c:when>
                <c:otherwise>
                    <jsp:include page="/WEB-INF/views/components/navbar.jsp"/>
                </c:otherwise>
            </c:choose>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <!-- Breadcrumbs & Navigation -->
                <nav aria-label="breadcrumb" class="mb-3">
                    <ol class="breadcrumb sm-breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/courses">Courses</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/subjects?courseId=${resource.course.id}"><c:out value="${resource.course.courseCode}"/></a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/resources?subjectId=${resource.subject.id}"><c:out value="${resource.subject.subjectCode}"/></a></li>
                        <li class="breadcrumb-item active text-light text-truncate" style="max-width: 250px;" aria-current="page"><c:out value="${resource.title}"/></li>
                    </ol>
                </nav>

                <div class="row g-4">
                    <!-- Viewer Column -->
                    <div class="col-lg-8 col-xl-9">
                        <div class="sm-card p-3 rounded-4 shadow-lg mb-3 position-relative">
                            <!-- In-browser preview header -->
                            <div class="d-flex align-items-center justify-content-between p-2 mb-2 border-bottom border-secondary border-opacity-10">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge ${resource.resourceType == 'PDF' ? 'bg-danger-subtle text-danger' : (resource.resourceType == 'IMAGE' ? 'bg-info-subtle text-info' : 'bg-warning-subtle text-warning')}">
                                        ${resource.resourceType}
                                    </span>
                                    <span class="text-light fw-medium small text-truncate" style="max-width: 300px;"><c:out value="${resource.title}"/></span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <c:if test="${resource.resourceType != 'EXTERNAL_URL' && resource.downloadable}">
                                        <a href="${pageContext.request.contextPath}/resources/download?id=${resource.id}" class="btn btn-sm btn-sm-primary" title="Download Resource">
                                            <i class="bi bi-download me-1"></i> Download
                                        </a>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Media Render Area -->
                            <div class="sm-viewer-container rounded-3 overflow-hidden bg-dark position-relative" style="min-height: 580px;">
                                <c:choose>
                                    <c:when test="${resource.resourceType == 'PDF'}">
                                        <!-- Embedded PDF Viewer -->
                                        <iframe src="${pageContext.request.contextPath}/resources/raw?id=${resource.id}#toolbar=1" 
                                                class="w-100 h-100 border-0" 
                                                style="min-height: 640px;" 
                                                title="PDF Document Viewer">
                                        </iframe>
                                    </c:when>

                                    <c:when test="${resource.resourceType == 'IMAGE'}">
                                        <!-- Responsive Image Viewer -->
                                        <div class="d-flex align-items-center justify-content-center p-3 h-100">
                                            <img src="${pageContext.request.contextPath}/resources/raw?id=${resource.id}" 
                                                 alt="<c:out value='${resource.title}'/>" 
                                                 class="img-fluid rounded-3 shadow" 
                                                 style="max-height: 600px; object-fit: contain;">
                                        </div>
                                    </c:when>

                                    <c:when test="${resource.resourceType == 'EXTERNAL_URL'}">
                                        <!-- External Resource Preview Box -->
                                        <div class="d-flex flex-column align-items-center justify-content-center p-5 text-center h-100" style="min-height: 480px;">
                                            <div class="p-4 rounded-circle bg-primary bg-opacity-20 text-primary fs-1 mb-3">
                                                <i class="bi bi-box-arrow-up-right"></i>
                                            </div>
                                            <h4 class="fw-bold text-light mb-2">Curated External Web Resource</h4>
                                            <p class="text-secondary max-w-md mx-auto mb-4">
                                                This learning material is hosted externally by an educational partner or repository.
                                            </p>
                                            <a href="<c:out value='${resource.externalUrl}'/>" target="_blank" rel="noopener noreferrer" class="btn btn-primary btn-lg px-4 py-2 fw-semibold">
                                                Open External Resource <i class="bi bi-box-arrow-up-right ms-2"></i>
                                            </a>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <!-- Fallback Generic Document Display -->
                                        <div class="d-flex flex-column align-items-center justify-content-center p-5 text-center h-100" style="min-height: 480px;">
                                            <div class="p-4 rounded-circle bg-secondary bg-opacity-20 text-secondary fs-1 mb-3">
                                                <i class="bi bi-file-earmark-text"></i>
                                            </div>
                                            <h4 class="fw-bold text-light mb-2">Document Available for Download</h4>
                                            <p class="text-secondary max-w-md mx-auto mb-4">
                                                In-browser preview is not supported for this file format. You can download and inspect it locally.
                                            </p>
                                            <a href="${pageContext.request.contextPath}/resources/download?id=${resource.id}" class="btn btn-primary px-4 py-2 fw-semibold">
                                                <i class="bi bi-download me-2"></i> Download File
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Description & Detailed Overview -->
                        <div class="sm-card p-4 rounded-4">
                            <h5 class="fw-bold text-light mb-2">About this Material</h5>
                            <p class="text-secondary mb-0 leading-relaxed">
                                <c:out value="${resource.description != null ? resource.description : 'No comprehensive description provided for this item.'}"/>
                            </p>
                        </div>
                    </div>

                    <!-- Resource Metadata Sidebar -->
                    <div class="col-lg-4 col-xl-3">
                        <div class="sm-card p-4 rounded-4 mb-4">
                            <h5 class="fw-bold text-light mb-3">Material Details</h5>

                            <div class="d-flex flex-column gap-3 text-secondary small">
                                <div>
                                    <span class="d-block text-secondary text-uppercase fw-semibold" style="font-size: 0.7rem;">Course</span>
                                    <span class="text-light fw-medium"><c:out value="${resource.course.courseName}"/> (<c:out value="${resource.course.courseCode}"/>)</span>
                                </div>

                                <div>
                                    <span class="d-block text-secondary text-uppercase fw-semibold" style="font-size: 0.7rem;">Subject</span>
                                    <span class="text-light fw-medium"><c:out value="${resource.subject.subjectName}"/> (<c:out value="${resource.subject.subjectCode}"/>)</span>
                                </div>

                                <div>
                                    <span class="d-block text-secondary text-uppercase fw-semibold" style="font-size: 0.7rem;">Semester</span>
                                    <span class="badge bg-secondary-subtle text-secondary">Semester ${resource.semester.semesterNumber}</span>
                                </div>

                                <div>
                                    <span class="d-block text-secondary text-uppercase fw-semibold" style="font-size: 0.7rem;">Category</span>
                                    <span class="badge bg-primary-subtle text-primary"><c:out value="${resource.category.categoryName}"/></span>
                                </div>

                                <div>
                                    <span class="d-block text-secondary text-uppercase fw-semibold" style="font-size: 0.7rem;">Uploaded By</span>
                                    <span class="text-light fw-medium"><c:out value="${resource.uploadedBy.fullName}"/></span>
                                </div>

                                <div>
                                    <span class="d-block text-secondary text-uppercase fw-semibold" style="font-size: 0.7rem;">Upload Date</span>
                                    <span class="text-light"><fmt:formatDate value="${resource.createdAt}" pattern="MMMM dd, yyyy"/></span>
                                </div>

                                <div class="d-flex justify-content-between pt-2 border-top border-secondary border-opacity-10">
                                    <span><i class="bi bi-eye me-1"></i> ${resource.viewCount} Views</span>
                                    <c:if test="${resource.resourceType != 'EXTERNAL_URL'}">
                                        <span><i class="bi bi-download me-1"></i> ${resource.downloadCount} Downloads</span>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Bookmark Action -->
                            <c:if test="${not empty sessionScope.currentUser}">
                                <div class="mt-4 pt-3 border-top border-secondary border-opacity-10">
                                    <form action="${pageContext.request.contextPath}/student/bookmarks/toggle" method="post" id="bookmarkForm">
                                        <input type="hidden" name="_csrf" value="${csrfToken}">
                                        <input type="hidden" name="resourceId" value="${resource.id}">

                                        <div class="mb-3">
                                            <label class="form-label text-light small fw-medium">Study Notes / Tag</label>
                                            <textarea name="note" class="form-control sm-form-control form-control-sm" rows="2" placeholder="e.g. Key reference for unit 3"></textarea>
                                        </div>

                                        <button type="submit" class="btn btn-sm ${isBookmarked ? 'btn-warning' : 'btn-outline-warning'} w-100 py-2 fw-semibold d-flex align-items-center justify-content-center gap-2">
                                            <i class="bi ${isBookmarked ? 'bi-star-fill' : 'bi-star'}"></i>
                                            <span>${isBookmarked ? 'Saved in Bookmarks' : 'Bookmark Material'}</span>
                                        </button>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </main>

            <c:if test="${empty sessionScope.currentUser}">
                <jsp:include page="/WEB-INF/views/components/footer.jsp"/>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/navigation.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bookmarks.js"></script>
</body>
</html>

