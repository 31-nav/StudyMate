/**
 * StudyMate Navigation Controller
 * Handles mobile sidebar toggle, active links, and UI transitions
 */
document.addEventListener('DOMContentLoaded', () => {
    'use strict';

    const sidebarToggle = document.getElementById('sidebarToggle');
    const sidebar = document.querySelector('.sm-sidebar');

    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener('click', (e) => {
            e.stopPropagation();
            sidebar.classList.toggle('show');
        });

        // Close sidebar when clicking outside on mobile
        document.addEventListener('click', (e) => {
            if (window.innerWidth <= 992 && sidebar.classList.contains('show')) {
                if (!sidebar.contains(e.target) && e.target !== sidebarToggle) {
                    sidebar.classList.remove('show');
                }
            }
        });
    }

    // Auto-dismiss alert banners after 5 seconds
    const flashAlerts = document.querySelectorAll('.alert-dismissible');
    flashAlerts.forEach(alert => {
        setTimeout(() => {
            try {
                const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
                bsAlert.close();
            } catch (ignored) {}
        }, 5000);
    });
});

