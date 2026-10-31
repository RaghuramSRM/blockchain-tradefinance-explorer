/**
 * ChainDocs Frontend API Client & Auth State Management
 */

const API_BASE = '/api';

const App = {
    getToken() {
        return localStorage.getItem('chaindocs_token');
    },

    getUser() {
        const user = localStorage.getItem('chaindocs_user');
        return user ? JSON.parse(user) : null;
    },

    setSession(token, user) {
        localStorage.setItem('chaindocs_token', token);
        localStorage.setItem('chaindocs_user', JSON.stringify(user));
    },

    logout() {
        localStorage.removeItem('chaindocs_token');
        localStorage.removeItem('chaindocs_user');
        window.location.href = '/login.html';
    },

    requireAuth() {
        if (!this.getToken()) {
            window.location.href = '/login.html';
        }
    },

    async request(endpoint, options = {}) {
        const token = this.getToken();
        const headers = {
            'Content-Type': 'application/json',
            ...(options.headers || {})
        };

        if (token) {
            headers['Authorization'] = `Bearer ${token}`;
        }

        try {
            const res = await fetch(`${API_BASE}${endpoint}`, {
                ...options,
                headers
            });

            if (res.status === 401 && !endpoint.includes('/auth/')) {
                this.logout();
                return null;
            }

            const data = await res.json();
            return { ok: res.ok, status: res.status, data };
        } catch (err) {
            console.error('API Network Error:', err);
            return { ok: false, error: err.message };
        }
    },

    initSidebar(activePage) {
        const user = this.getUser();
        const nav = document.getElementById('sidebar-nav');
        if (!nav) return;

        const role = user ? user.role : 'GUEST';
        const userName = user ? user.name : 'Anonymous';
        const orgName = user ? user.org_name : 'Participant';

        nav.innerHTML = `
            <div class="sidebar-brand">
                <i class="bi bi-shield-shaded text-info fs-4"></i>
                <div>
                    <div>ChainDocs</div>
                    <div style="font-size: 0.7rem; font-weight: 400; color: #94a3b8;">Blockchain Trade Explorer</div>
                </div>
            </div>
            <div class="p-3 border-bottom border-secondary border-opacity-25">
                <div class="fw-bold text-white small">${userName}</div>
                <div class="badge bg-primary bg-opacity-25 text-info mt-1">${role}</div>
                <div class="small text-muted mt-1 text-truncate">${orgName}</div>
            </div>
            <ul class="sidebar-menu">
                <li><a href="/dashboard.html" class="${activePage === 'dashboard' ? 'active' : ''}"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a></li>
                <li><a href="/transactions.html" class="${activePage === 'transactions' ? 'active' : ''}"><i class="bi bi-arrow-left-right"></i> Trade Transactions</a></li>
                <li><a href="/documents.html" class="${activePage === 'documents' ? 'active' : ''}"><i class="bi bi-file-earmark-lock2-fill"></i> Trade Documents</a></li>
                <li><a href="/ledger.html" class="${activePage === 'ledger' ? 'active' : ''}"><i class="bi bi-link-45deg"></i> Blockchain Ledger</a></li>
                <li><a href="/analytics.html" class="${activePage === 'analytics' ? 'active' : ''}"><i class="bi bi-graph-up-arrow"></i> Risk & Analytics</a></li>
            </ul>
            <div class="p-3 mt-auto border-top border-secondary border-opacity-25">
                <button class="btn btn-sm btn-outline-danger w-100" onclick="App.logout()">
                    <i class="bi bi-box-arrow-right"></i> Sign Out
                </button>
            </div>
        `;
    }
};

/**
 * Client-Side Validation Module (Fulfills Review 02 JavaScript rubric & Ex 3)
 */
const Validator = {
    validateEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(String(email).toLowerCase());
    },

    validatePhone(phone) {
        const re = /^\+?[0-9]{7,15}$/;
        return re.test(String(phone).trim());
    },

    validateRequired(val) {
        return val !== null && val !== undefined && String(val).trim().length > 0;
    },

    showError(inputId, message) {
        const el = document.getElementById(inputId);
        if (!el) return;
        el.classList.add('is-invalid');
        let feedback = el.parentNode.querySelector('.invalid-feedback');
        if (!feedback) {
            feedback = document.createElement('div');
            feedback.className = 'invalid-feedback';
            el.parentNode.appendChild(feedback);
        }
        feedback.innerText = message;
    },

    clearError(inputId) {
        const el = document.getElementById(inputId);
        if (!el) return;
        el.classList.remove('is-invalid');
        el.classList.add('is-valid');
    }
};
