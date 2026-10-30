/**
 * StudyMate Bookmark Manager
 * Handles AJAX bookmark toggling and visual state updates
 */
document.addEventListener('DOMContentLoaded', () => {
    'use strict';

    document.querySelectorAll('.btn-bookmark-toggle').forEach(button => {
        button.addEventListener('click', async (e) => {
            e.preventDefault();
            const resourceId = button.getAttribute('data-resource-id');
            const icon = button.querySelector('i');
            const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

            try {
                const formData = new URLSearchParams();
                formData.append('resourceId', resourceId);

                const response = await fetch(window.APP_BASE_URL + '/student/bookmarks/toggle', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'Accept': 'application/json',
                        'X-CSRF-TOKEN': csrfToken || ''
                    },
                    body: formData.toString()
                });

                if (response.ok) {
                    const result = await response.json();
                    if (result.success && result.data) {
                        const isBookmarked = result.data.bookmarked;
                        if (isBookmarked) {
                            icon.className = 'bi bi-bookmark-fill text-primary';
                            showToast('Bookmark Added', 'Saved to your bookmarks collection.');
                        } else {
                            icon.className = 'bi bi-bookmark';
                            showToast('Bookmark Removed', 'Removed from your bookmarks collection.');
                        }
                    }
                } else if (response.status === 401) {
                    window.location.href = window.APP_BASE_URL + '/auth/login';
                }
            } catch (err) {
                console.error('Bookmark toggle error:', err);
            }
        });
    });

    function showToast(title, message) {
        let toastContainer = document.getElementById('smToastContainer');
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.id = 'smToastContainer';
            toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
            toastContainer.style.zIndex = '9999';
            document.body.appendChild(toastContainer);
        }

        const toastEl = document.createElement('div');
        toastEl.className = 'toast align-items-center text-bg-dark border-0 sm-glass shadow-lg';
        toastEl.setAttribute('role', 'alert');
        toastEl.setAttribute('aria-live', 'assertive');
        toastEl.setAttribute('aria-atomic', 'true');
        toastEl.innerHTML = `
            <div class="d-flex">
                <div class="toast-body">
                    <strong>${title}:</strong> ${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        `;
        toastContainer.appendChild(toastEl);
        const bsToast = new bootstrap.Toast(toastEl, { delay: 3000 });
        bsToast.show();
    }
});

