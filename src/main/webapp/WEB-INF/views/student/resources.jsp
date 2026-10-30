<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Browse Library"/>
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
                <!-- Page Title -->
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">Centralized Resource Library</h2>
                        <p class="text-secondary small mb-0">Search, filter, preview and download study materials, PYQs, and lecture slides.</p>
                    </div>
                    <span class="badge bg-secondary-subtle text-secondary py-2 px-3 fs-6">
                        ${totalCount} Resources Available
                    </span>
                </div>

                <!-- Filter & Search Controls -->
                <div class="sm-glass-card p-4 rounded-4 mb-4 border border-secondary border-opacity-10">
                    <form action="${pageContext.request.contextPath}/resources" method="get" class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label text-light small fw-medium">Search Keyword</label>
                            <div class="input-group">
                                <span class="input-group-text bg-transparent border-secondary border-opacity-25 text-secondary">
                                    <i class="bi bi-search"></i>
                                </span>
                                <input type="text" name="q" class="form-control sm-form-control" placeholder="Search title, tags..." value="<c:out value='${keyword}'/>">
                            </div>
                        </div>

                        <div class="col-sm-6 col-md-2">
                            <label class="form-label text-light small fw-medium">Course</label>
                            <select name="courseId" class="form-select sm-form-control">
                                <option value="">All Programs</option>
                                <c:forEach var="c" items="${courses}">
                                    <option value="${c.id}" ${selectedCourseId == c.id ? 'selected' : ''}>
                                        <c:out value="${c.courseCode}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-sm-6 col-md-2">
                            <label class="form-label text-light small fw-medium">Category</label>
                            <select name="categoryId" class="form-select sm-form-control">
                                <option value="">All Categories</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}" ${selectedCategoryId == cat.id ? 'selected' : ''}>
                                        <c:out value="${cat.categoryName}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-sm-6 col-md-2">
                            <label class="form-label text-light small fw-medium">Resource Type</label>
                            <select name="type" class="form-select sm-form-control">
                                <option value="">All Types</option>
                                <option value="PDF" ${selectedType == 'PDF' ? 'selected' : ''}>PDF Documents</option>
                                <option value="IMAGE" ${selectedType == 'IMAGE' ? 'selected' : ''}>Diagrams / Images</option>
                                <option value="DOCUMENT" ${selectedType == 'DOCUMENT' ? 'selected' : ''}>Office Docs</option>
                                <option value="EXTERNAL_URL" ${selectedType == 'EXTERNAL_URL' ? 'selected' : ''}>Online Links</option>
                            </select>
                        </div>

                        <div class="col-sm-6 col-md-2 d-flex align-items-end gap-2">
                            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                                Filter
                            </button>
                            <a href="${pageContext.request.contextPath}/resources" class="btn btn-sm-outline py-2 px-3" title="Clear filters">
                                <i class="bi bi-arrow-counterclockwise"></i>
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Resources Grid -->
                <div class="row g-4">
                    <c:choose>
                        <c:when test="${not empty resources}">
                            <c:forEach var="res" items="${resources}">
                                <div class="col-md-6 col-lg-4 col-xl-3">
                                    <div class="sm-card h-100 p-3 rounded-4 d-flex flex-column">
                                        <!-- Resource Header -->
                                        <div class="d-flex align-items-center justify-content-between mb-2">
                                            <span class="badge ${res.resourceType == 'PDF' ? 'bg-danger-subtle text-danger' : (res.resourceType == 'IMAGE' ? 'bg-info-subtle text-info' : 'bg-warning-subtle text-warning')} small fw-semibold">
                                                <i class="bi ${res.resourceType == 'PDF' ? 'bi-file-earmark-pdf' : (res.resourceType == 'IMAGE' ? 'bi-file-earmark-image' : 'bi-link-45deg')} me-1"></i>
                                                ${res.resourceType}
                                            </span>
                                            <span class="badge bg-secondary-subtle text-secondary small">
                                                <c:out value="${res.category.categoryName}"/>
                                            </span>
                                        </div>

                                        <h5 class="fw-bold text-light mb-1 text-truncate" title="<c:out value='${res.title}'/>">
                                            <a href="${pageContext.request.contextPath}/resources/view?id=${res.id}" class="text-light text-decoration-none">
                                                <c:out value="${res.title}"/>
                                            </a>
                                        </h5>

                                        <p class="text-secondary small mb-3 flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                            <c:out value="${res.description != null ? res.description : 'No description provided.'}"/>
                                        </p>

                                        <!-- Subject and Metadata -->
                                        <div class="mb-3 pt-2 border-top border-secondary border-opacity-10 text-secondary small">
                                            <div class="d-flex align-items-center justify-content-between mb-1">
                                                <span class="text-truncate" style="max-width: 140px;" title="<c:out value='${res.subject.subjectName}'/>">
                                                    <i class="bi bi-book me-1"></i> <c:out value="${res.subject.subjectCode}"/>
                                                </span>
                                                <span><i class="bi bi-eye me-1"></i> ${res.viewCount}</span>
                                            </div>
                                            <div class="d-flex align-items-center justify-content-between">
                                                <span><i class="bi bi-person me-1"></i> <c:out value="${res.uploadedBy.fullName}"/></span>
                                                <c:if test="${res.resourceType != 'EXTERNAL_URL'}">
                                                    <span><i class="bi bi-download me-1"></i> ${res.downloadCount}</span>
                                                </c:if>
                                            </div>
                                        </div>

                                        <!-- Actions -->
                                        <div class="d-flex gap-2 mt-auto">
                                            <a href="${pageContext.request.contextPath}/resources/view?id=${res.id}" class="btn btn-sm btn-sm-outline flex-grow-1 d-flex align-items-center justify-content-center gap-1">
                                                <i class="bi bi-eye"></i> View
                                            </a>
                                            <c:if test="${res.resourceType != 'EXTERNAL_URL' && res.downloadable}">
                                                <a href="${pageContext.request.contextPath}/resources/download?id=${res.id}" class="btn btn-sm btn-sm-primary" title="Download file">
                                                    <i class="bi bi-download"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${not empty sessionScope.currentUser}">
                                                <button type="button" class="btn btn-sm btn-sm-outline btn-bookmark-toggle" data-resource-id="${res.id}" title="Toggle bookmark">
                                                    <i class="bi bi-bookmark"></i>
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12 text-center py-5">
                                <div class="sm-glass-card p-5 rounded-4 max-w-md mx-auto">
                                    <i class="bi bi-folder-x fs-1 text-secondary opacity-50 mb-3 d-block"></i>
                                    <h4 class="fw-bold text-light mb-1">No Matching Resources</h4>
                                    <p class="text-secondary small mb-3">We couldn't find study materials matching your selected filters.</p>
                                    <a href="${pageContext.request.contextPath}/resources" class="btn btn-sm btn-primary">Reset Filters</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav class="mt-5 d-flex justify-content-center">
                        <ul class="pagination pagination-sm gap-1">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link sm-page-link" href="?page=${currentPage - 1}&q=<c:out value='${keyword}'/>&courseId=${selectedCourseId}&categoryId=${selectedCategoryId}&type=${selectedType}">Previous</a>
                            </li>
                            <c:forEach var="p" begin="1" end="${totalPages}">
                                <li class="page-item ${currentPage == p ? 'active' : ''}">
                                    <a class="page-link sm-page-link" href="?page=${p}&q=<c:out value='${keyword}'/>&courseId=${selectedCourseId}&categoryId=${selectedCategoryId}&type=${selectedType}">${p}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link sm-page-link" href="?page=${currentPage + 1}&q=<c:out value='${keyword}'/>&courseId=${selectedCourseId}&categoryId=${selectedCategoryId}&type=${selectedType}">Next</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
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

