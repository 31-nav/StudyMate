/**
 * StudyMate Internal Resource Viewer
 * Provides PDF.js rendering with zoom, page navigation, and full-screen controls
 */
class StudyMatePdfViewer {
    constructor(containerId, pdfUrl) {
        this.container = document.getElementById(containerId);
        this.pdfUrl = pdfUrl;
        this.pdfDoc = null;
        this.pageNum = 1;
        this.pageRendering = false;
        this.pageNumPending = null;
        this.scale = 1.25;
        this.canvas = null;
        this.ctx = null;

        if (this.container && this.pdfUrl) {
            this.init();
        }
    }

    init() {
        this.canvas = this.container.querySelector('canvas');
        if (!this.canvas) return;
        this.ctx = this.canvas.getContext('2d');

        // Setup PDF.js worker
        if (window.pdfjsLib) {
            window.pdfjsLib.GlobalWorkerOptions.workerSrc =
                'https://cdn.jsdelivr.net/npm/pdfjs-dist@3.11.174/build/pdf.worker.min.js';

            this.loadPdf();
            this.attachControls();
        } else {
            console.warn('PDF.js library not loaded');
        }
    }

    async loadPdf() {
        try {
            const loadingTask = window.pdfjsLib.getDocument(this.pdfUrl);
            this.pdfDoc = await loadingTask.promise;

            const pageCountEl = document.getElementById('pageCount');
            if (pageCountEl) pageCountEl.textContent = this.pdfDoc.numPages;

            this.renderPage(this.pageNum);
        } catch (err) {
            console.error('Error loading PDF document:', err);
            const errEl = document.getElementById('viewerError');
            if (errEl) {
                errEl.classList.remove('d-none');
                errEl.textContent = 'Could not preview PDF directly. Please use the download option if permitted.';
            }
        }
    }

    renderPage(num) {
        this.pageRendering = true;
        this.pdfDoc.getPage(num).then(page => {
            const viewport = page.getViewport({ scale: this.scale });
            this.canvas.height = viewport.height;
            this.canvas.width = viewport.width;

            const renderContext = {
                canvasContext: this.ctx,
                viewport: viewport
            };
            const renderTask = page.render(renderContext);

            renderTask.promise.then(() => {
                this.pageRendering = false;
                if (this.pageNumPending !== null) {
                    this.renderPage(this.pageNumPending);
                    this.pageNumPending = null;
                }
            });
        });

        const pageNumEl = document.getElementById('pageNum');
        if (pageNumEl) pageNumEl.textContent = num;
    }

    queueRenderPage(num) {
        if (this.pageRendering) {
            this.pageNumPending = num;
        } else {
            this.renderPage(num);
        }
    }

    attachControls() {
        const prevBtn = document.getElementById('prevPage');
        const nextBtn = document.getElementById('nextPage');
        const zoomInBtn = document.getElementById('zoomIn');
        const zoomOutBtn = document.getElementById('zoomOut');
        const fullscreenBtn = document.getElementById('fullscreenToggle');

        if (prevBtn) {
            prevBtn.addEventListener('click', () => {
                if (this.pageNum <= 1) return;
                this.pageNum--;
                this.queueRenderPage(this.pageNum);
            });
        }

        if (nextBtn) {
            nextBtn.addEventListener('click', () => {
                if (this.pageNum >= this.pdfDoc.numPages) return;
                this.pageNum++;
                this.queueRenderPage(this.pageNum);
            });
        }

        if (zoomInBtn) {
            zoomInBtn.addEventListener('click', () => {
                this.scale = Math.min(3.0, this.scale + 0.2);
                this.queueRenderPage(this.pageNum);
            });
        }

        if (zoomOutBtn) {
            zoomOutBtn.addEventListener('click', () => {
                this.scale = Math.max(0.5, this.scale - 0.2);
                this.queueRenderPage(this.pageNum);
            });
        }

        if (fullscreenBtn) {
            fullscreenBtn.addEventListener('click', () => {
                const viewerEl = document.getElementById('pdfViewerWrapper');
                if (!document.fullscreenElement) {
                    viewerEl?.requestFullscreen().catch(err => console.error(err));
                } else {
                    document.exitFullscreen().catch(err => console.error(err));
                }
            });
        }
    }
}

window.StudyMatePdfViewer = StudyMatePdfViewer;

