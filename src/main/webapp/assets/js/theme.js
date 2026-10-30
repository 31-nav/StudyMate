/**
 * StudyMate Theme Engine
 * Manages Dark and Light mode toggling with localStorage persistence
 */
(function() {
    'use strict';

    const THEME_KEY = 'studymate_theme';

    function getStoredTheme() {
        return localStorage.getItem(THEME_KEY) || 'dark';
    }

    function setTheme(theme) {
        document.documentElement.setAttribute('data-bs-theme', theme);
        localStorage.setItem(THEME_KEY, theme);

        const themeIcons = document.querySelectorAll('.theme-toggle-icon');
        themeIcons.forEach(icon => {
            if (theme === 'dark') {
                icon.className = 'bi bi-moon-stars theme-toggle-icon';
            } else {
                icon.className = 'bi bi-sun theme-toggle-icon';
            }
        });
    }

    // Apply stored theme on immediate load
    setTheme(getStoredTheme());

    document.addEventListener('DOMContentLoaded', () => {
        const toggleButtons = document.querySelectorAll('.btn-theme-toggle');
        toggleButtons.forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                const currentTheme = document.documentElement.getAttribute('data-bs-theme') || 'dark';
                const nextTheme = currentTheme === 'dark' ? 'light' : 'dark';
                setTheme(nextTheme);
            });
        });
    });
})();

