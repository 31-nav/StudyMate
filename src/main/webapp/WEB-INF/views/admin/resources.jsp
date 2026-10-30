<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Manage Learning Materials"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp">
            <jsp:param name="activeMenu" value="resources"/>
        </jsp:include>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">Educational Resource Repository</h2>
                        <p class="text-secondary small mb-0">Publish lecture notes, upload past exam papers, and maintain the institutional digital library.</p>
                    </div>

                    <button type="button" class="btn btn-primary fw-semibold d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#uploadResourceModal">
                        <i class="bi bi-cloud-arrow-up"></i> Upload Learning Material
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

                <!-- Resources Table -->
                <div class="sm-card p-4 rounded-4">
                    <div class="table-responsive">
                        <table class="table sm-table align-middle">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Subject & Course</th>
                                    <th>Category</th>
                                    <th>Type</th>
                                    <th>Uploaded By</th>
                                    <th>Telemetry</th>
                                    <th>Date</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty resources}">
                                        <c:forEach var="res" items="${resources}">
                                            <tr>
                                                <td>
                                                    <div class="fw-semibold text-light text-truncate" style="max-width: 220px;" title="<c:out value='${res.title}'/>">
                                                        <c:out value="${res.title}"/>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge bg-secondary-subtle text-secondary me-1"><c:out value="${res.subject.subjectCode}"/></span>
                                                    <small class="text-secondary"><c:out value="${res.course.courseCode}"/></small>
                                                </td>
                                                <td><small class="text-secondary"><c:out value="${res.category.categoryName}"/></small></td>
                                                <td>
                                                    <span class="badge ${res.resourceType == 'PDF' ? 'bg-danger-subtle text-danger' : 'bg-primary-subtle text-primary'}">
                                                        ${res.resourceType}
                                                    </span>
                                                </td>
                                                <td><small class="text-secondary"><c:out value="${res.uploadedBy.fullName}"/></small></td>
                                                <td>
                                                    <small class="text-secondary">
                                                        <i class="bi bi-eye"></i> ${res.viewCount} &bull; <i class="bi bi-download"></i> ${res.downloadCount}
                                                    </small>
                                                </td>
                                                <td><small class="text-secondary"><fmt:formatDate value="${res.createdAt}" pattern="MMM dd, yyyy"/></small></td>
                                                <td class="text-end">
                                                    <div class="d-flex justify-content-end gap-1">
                                                        <a href="${pageContext.request.contextPath}/resources/view?id=${res.id}" class="btn btn-sm btn-sm-outline p-1" title="View">
                                                            <i class="bi bi-eye"></i>
                                                        </a>
                                                        <form action="${pageContext.request.contextPath}/admin/resources/delete" method="post" class="d-inline" onsubmit="return confirm('Permanently remove this material?')">
                                                            <input type="hidden" name="_csrf" value="${csrfToken}">
                                                            <input type="hidden" name="id" value="${res.id}">
                                                            <button type="submit" class="btn btn-sm btn-sm-outline text-danger p-1" title="Delete">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8" class="text-center py-4 text-secondary">No educational materials published yet.</td>
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

    <!-- Upload Resource Modal -->
    <div class="modal fade" id="uploadResourceModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content sm-glass-card border-secondary border-opacity-25">
                <div class="modal-header border-bottom border-secondary border-opacity-10">
                    <h5 class="modal-title text-light fw-bold">Upload Educational Material</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/resources/upload" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="_csrf" value="${csrfToken}">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label text-light small fw-medium">Material Title</label>
                            <input type="text" name="title" class="form-control sm-form-control" placeholder="e.g. Unit 3 - Tree Traversal and Balanced Binary Search Trees" required>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-sm-6">
                                <label class="form-label text-light small fw-medium">Degree Program</label>
                                <select name="courseId" class="form-select sm-form-control" required>
                                    <c:forEach var="c" items="${courses}">
                                        <option value="${c.id}"><c:out value="${c.courseCode}"/> - <c:out value="${c.courseName}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-sm-6">
                                <label class="form-label text-light small fw-medium">Semester</label>
                                <select name="semesterId" class="form-select sm-form-control" required>
                                    <option value="1">Semester 1</option>
                                    <option value="2">Semester 2</option>
                                    <option value="3">Semester 3</option>
                                    <option value="4">Semester 4</option>
                                    <option value="5">Semester 5</option>
                                    <option value="6">Semester 6</option>
                                    <option value="7">Semester 7</option>
                                    <option value="8">Semester 8</option>
                                </select>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-sm-6">
                                <label class="form-label text-light small fw-medium">Subject ID</label>
                                <select name="subjectId" class="form-select sm-form-control" required>
                                    <option value="1">1 - Data Structures & Algorithms</option>
                                    <option value="2">2 - Database Management Systems</option>
                                    <option value="3">3 - Computer Networks</option>
                                    <option value="4">4 - Operating Systems</option>
                                    <option value="5">5 - Software Engineering</option>
                                    <option value="6">6 - Artificial Intelligence</option>
                                    <option value="7">7 - Digital Circuit Design</option>
                                    <option value="8">8 - Microprocessors & Microcontrollers</option>
                                    <option value="9">9 - Engineering Thermodynamics</option>
                                </select>
                            </div>
                            <div class="col-sm-6">
                                <label class="form-label text-light small fw-medium">Resource Category</label>
                                <select name="categoryId" class="form-select sm-form-control" required>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.id}"><c:out value="${cat.categoryName}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-sm-6">
                                <label class="form-label text-light small fw-medium">Format / Resource Type</label>
                                <select name="resourceType" class="form-select sm-form-control" id="resourceTypeSelect" required>
                                    <option value="PDF">PDF Document</option>
                                    <option value="IMAGE">Image / Architectural Diagram</option>
                                    <option value="DOCUMENT">Office Document</option>
                                    <option value="EXTERNAL_URL">External Educational URL</option>
                                </select>
                            </div>
                            <div class="col-sm-6">
                                <label class="form-label text-light small fw-medium">Search Tags</label>
                                <input type="text" name="tags" class="form-control sm-form-control" placeholder="e.g. bst, avl, trees, lecture notes">
                            </div>
                        </div>

                        <div class="mb-3" id="fileUploadContainer">
                            <label class="form-label text-light small fw-medium">Upload File (PDF, PNG, JPG, DOCX &mdash; Max 50MB)</label>
                            <input type="file" name="file" class="form-control sm-form-control">
                        </div>

                        <div class="mb-3 d-none" id="externalUrlContainer">
                            <label class="form-label text-light small fw-medium">External Learning URL</label>
                            <input type="url" name="externalUrl" class="form-control sm-form-control" placeholder="https://ocw.mit.edu/...">
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-light small fw-medium">Description</label>
                            <textarea name="description" class="form-control sm-form-control" rows="2" placeholder="Summary of chapters or topics covered"></textarea>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="isDownloadable" name="isDownloadable" checked>
                            <label class="form-check-label text-secondary small" for="isDownloadable">
                                Permit students to download an offline copy
                            </label>
                        </div>
                    </div>
                    <div class="modal-footer border-top border-secondary border-opacity-10">
                        <button type="button" class="btn btn-sm-outline" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Publish Resource</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/navigation.js"></script>
    <script>
        const resType = document.getElementById('resourceTypeSelect');
        const fileCont = document.getElementById('fileUploadContainer');
        const urlCont = document.getElementById('externalUrlContainer');
        if (resType) {
            resType.addEventListener('change', () => {
                if (resType.value === 'EXTERNAL_URL') {
                    fileCont.classList.add('d-none');
                    urlCont.classList.remove('d-none');
                } else {
                    fileCont.classList.remove('d-none');
                    urlCont.classList.add('d-none');
                }
            });
        }
    </script>
</body>
</html>

