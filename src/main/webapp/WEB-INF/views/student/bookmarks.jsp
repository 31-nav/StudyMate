<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Saved Bookmarks"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
            <jsp:param name="activeMenu" value="bookmarks"/>
        </jsp:include>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">Saved Study Bookmarks</h2>
                        <p class="text-secondary small mb-0">Materials you have starred for quick review, exam preparation, and offline reference.</p>
                    </div>
                </div>

                <div class="row g-4">
                    <c:choose>
                        <c:when test="${not empty bookmarks}">
                            <c:forEach var="bm" items="${bookmarks}">
                                <div class="col-md-6 col-xl-4">
                                    <div class="sm-card h-100 p-4 rounded-4 d-flex flex-column">
                                        <div class="d-flex align-items-center justify-content-between mb-2">
                                            <span class="badge bg-warning-subtle text-warning small fw-semibold">
                                                <i class="bi bi-star-fill me-1"></i> Starred
                                            </span>
                                            <span class="badge bg-secondary-subtle text-secondary small">
                                                <c:out value="${bm.resource.category.categoryName}"/>
                                            </span>
                                        </div>

                                        <h5 class="fw-bold text-light mb-1">
                                            <a href="${pageContext.request.contextPath}/resources/view?id=${bm.resource.id}" class="text-light text-decoration-none">
                                                <c:out value="${bm.resource.title}"/>
                                            </a>
                                        </h5>

                                        <p class="text-secondary small mb-3 flex-grow-1">
                                            <c:out value="${bm.resource.description != null ? bm.resource.description : 'No description'}"/>
                                        </p>

                                        <c:if test="${not empty bm.notes}">
                                            <div class="p-2 rounded bg-dark border border-secondary border-opacity-10 mb-3 small text-secondary">
                                                <i class="bi bi-pencil-square me-1 text-warning"></i> <strong>Note:</strong> <c:out value="${bm.notes}"/>
                                            </div>
                                        </c:if>

                                        <div class="mb-3 text-secondary small">
                                            <span><i class="bi bi-book me-1"></i> <c:out value="${bm.resource.subject.subjectCode}"/> &bull; Semester ${bm.resource.semester.semesterNumber}</span>
                                        </div>

                                        <div class="pt-3 border-top border-secondary border-opacity-10 d-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/resources/view?id=${bm.resource.id}" class="btn btn-sm btn-sm-primary flex-grow-1">
                                                <i class="bi bi-eye me-1"></i> Open Material
                                            </a>
                                            <form action="${pageContext.request.contextPath}/student/bookmarks/toggle" method="post" class="d-inline">
                                                <input type="hidden" name="_csrf" value="${csrfToken}">
                                                <input type="hidden" name="resourceId" value="${bm.resource.id}">
                                                <button type="submit" class="btn btn-sm btn-sm-outline text-danger" title="Remove bookmark">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12 text-center py-5">
                                <div class="sm-glass-card p-5 rounded-4 max-w-md mx-auto">
                                    <i class="bi bi-bookmark-dash fs-1 text-secondary opacity-50 mb-3 d-block"></i>
                                    <h4 class="fw-bold text-light mb-1">No Bookmarks Saved</h4>
                                    <p class="text-secondary small mb-3">When browsing notes or past examination papers, click "Bookmark" to collect them here.</p>
                                    <a href="${pageContext.request.contextPath}/resources" class="btn btn-sm btn-primary">Browse Library</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/navigation.js"></script>
</body>
</html>

