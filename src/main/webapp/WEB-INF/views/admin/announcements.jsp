<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Manage Announcements"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp">
            <jsp:param name="activeMenu" value="announcements"/>
        </jsp:include>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">Campus Announcements</h2>
                        <p class="text-secondary small mb-0">Publish official notices, examination timetables, and academic updates.</p>
                    </div>

                    <button type="button" class="btn btn-primary fw-semibold d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#createAnnouncementModal">
                        <i class="bi bi-megaphone"></i> Post Announcement
                    </button>
                </div>

                <!-- Flash Alerts -->
                <c:if test="${not empty sessionScope.flashSuccess}">
                    <div class="alert alert-success alert-dismissible fade show small py-2 px-3 border-0 bg-success bg-opacity-20 text-success mb-4" role="alert">
                        <i class="bi bi-check-circle me-1"></i> <c:out value="${sessionScope.flashSuccess}"/>
                        <button type="button" class="btn-close btn-close-white small p-2" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="flashSuccess" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.flashError}">
                    <div class="alert alert-danger alert-dismissible fade show small py-2 px-3 border-0 bg-danger bg-opacity-20 text-danger mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle me-1"></i> <c:out value="${sessionScope.flashError}"/>
                        <button type="button" class="btn-close btn-close-white small p-2" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="flashError" scope="session"/>
                </c:if>

                <div class="sm-card p-4 rounded-4">
                    <div class="table-responsive">
                        <table class="table sm-table align-middle">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Priority</th>
                                    <th>Target Audience</th>
                                    <th>Author</th>
                                    <th>Publish Date</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty announcements}">
                                        <c:forEach var="ann" items="${announcements}">
                                            <tr>
                                                <td>
                                                    <div class="fw-semibold text-light text-truncate" style="max-width: 250px;"><c:out value="${ann.title}"/></div>
                                                    <small class="text-secondary text-truncate d-block" style="max-width: 320px;"><c:out value="${ann.content}"/></small>
                                                </td>
                                                <td>
                                                    <span class="badge ${ann.priority == 'URGENT' ? 'bg-danger text-light' : (ann.priority == 'HIGH' ? 'bg-warning text-dark' : 'bg-primary-subtle text-primary')}">
                                                        ${ann.priority}
                                                    </span>
                                                </td>
                                                <td><span class="badge bg-secondary-subtle text-secondary">${ann.targetAudience}</span></td>
                                                <td><small class="text-secondary"><c:out value="${ann.author.fullName}"/></small></td>
                                                <td><small class="text-secondary"><fmt:formatDate value="${ann.publishDate}" pattern="MMM dd, yyyy"/></small></td>
                                                <td class="text-end">
                                                    <form action="${pageContext.request.contextPath}/admin/announcements/delete" method="post" class="d-inline" onsubmit="return confirm('Delete this announcement?')">
                                                        <input type="hidden" name="_csrf" value="${csrfToken}">
                                                        <input type="hidden" name="id" value="${ann.id}">
                                                        <button type="submit" class="btn btn-sm btn-sm-outline text-danger p-1" title="Delete">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="text-center py-4 text-secondary">No announcements published yet.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Create Announcement Modal -->
    <div class="modal fade" id="createAnnouncementModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content sm-glass-card border-secondary border-opacity-25">
                <div class="modal-header border-bottom border-secondary border-opacity-10">
                    <h5 class="modal-title text-light fw-bold">Post New Announcement</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/announcements/create" method="post">
                    <input type="hidden" name="_csrf" value="${csrfToken}">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label text-light small fw-medium">Notice Title</label>
                            <input type="text" name="title" class="form-control sm-form-control" placeholder="e.g. Midterm Examination Timetable Released" required>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-sm-6">
                                <label class="form-label text-light small fw-medium">Priority Level</label>
                                <select name="priority" class="form-select sm-form-control" required>
                                    <option value="NORMAL">Normal</option>
                                    <option value="HIGH">High Priority</option>
                                    <option value="URGENT">Urgent Alert</option>
                                </select>
                            </div>
                            <div class="col-sm-6">
                                <label class="form-label text-light small fw-medium">Target Audience</label>
                                <select name="audience" class="form-select sm-form-control" required>
                                    <option value="ALL">All Students & Faculty</option>
                                    <option value="STUDENTS">Students Only</option>
                                    <option value="FACULTY">Faculty Only</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-light small fw-medium">Announcement Content</label>
                            <textarea name="content" class="form-control sm-form-control" rows="4" placeholder="Detailed message for students and faculty..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-top border-secondary border-opacity-10">
                        <button type="button" class="btn btn-sm-outline" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Publish Announcement</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/navigation.js"></script>
</body>
</html>

