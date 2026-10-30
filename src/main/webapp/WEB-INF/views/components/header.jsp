<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="${csrfToken}">
    <title><c:out value="${pageTitle != null ? pageTitle : 'StudyMate'}"/> - Your Learning. Your Space.</title>

    <!-- Favicon -->
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/images/favicon.svg">

    <!-- Bootstrap 5 CSS & Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Google Fonts Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- StudyMate Custom Glassmorphism CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/studymate.css">

    <!-- Global App Context configuration for scripts -->
    <script>
        window.APP_BASE_URL = '${pageContext.request.contextPath}';
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
</head>

