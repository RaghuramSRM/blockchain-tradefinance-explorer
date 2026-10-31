-- ==========================================================
-- Trade Finance Blockchain Explorer (ChainDocs)
-- SQLite Schema (Zero-Config Standalone & Offline Review)
-- ==========================================================

CREATE TABLE IF NOT EXISTS organizations (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    organization_type TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    hashed_password TEXT NOT NULL,
    role TEXT NOT NULL,
    org_id TEXT NULL,
    is_active INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (org_id) REFERENCES organizations(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS organization_members (
    id TEXT PRIMARY KEY,
    org_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    membership_role TEXT DEFAULT 'MEMBER',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (org_id) REFERENCES organizations(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS refresh_tokens (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    token_hash TEXT NOT NULL,
    expires_at DATETIME NOT NULL,
    revoked_at DATETIME NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS trade_transactions (
    id TEXT PRIMARY KEY,
    reference_number TEXT NOT NULL UNIQUE,
    buyer_id TEXT NOT NULL,
    seller_id TEXT NOT NULL,
    created_by TEXT NOT NULL,
    org_id TEXT NOT NULL,
    amount REAL NOT NULL,
    currency TEXT NOT NULL DEFAULT 'USD',
    status TEXT NOT NULL DEFAULT 'PENDING',
    description TEXT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (buyer_id) REFERENCES users(id),
    FOREIGN KEY (seller_id) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (org_id) REFERENCES organizations(id)
);

CREATE TABLE IF NOT EXISTS transaction_history (
    id TEXT PRIMARY KEY,
    transaction_id TEXT NOT NULL,
    actor_id TEXT NOT NULL,
    previous_status TEXT NULL,
    new_status TEXT NOT NULL,
    action TEXT NOT NULL,
    remarks TEXT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES trade_transactions(id) ON DELETE CASCADE,
    FOREIGN KEY (actor_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS documents (
    id TEXT PRIMARY KEY,
    owner_id TEXT NOT NULL,
    org_id TEXT NOT NULL,
    transaction_id TEXT NULL,
    doc_type TEXT NOT NULL,
    doc_number TEXT NOT NULL,
    file_url TEXT NOT NULL,
    original_filename TEXT NOT NULL,
    mime_type TEXT NOT NULL,
    file_size INTEGER NOT NULL,
    sha256_hash TEXT NOT NULL,
    issued_at DATETIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id),
    FOREIGN KEY (org_id) REFERENCES organizations(id),
    FOREIGN KEY (transaction_id) REFERENCES trade_transactions(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS ledger_entries (
    id TEXT PRIMARY KEY,
    document_id TEXT NULL,
    transaction_id TEXT NULL,
    actor_id TEXT NOT NULL,
    action TEXT NOT NULL,
    metadata TEXT NULL,
    previous_hash TEXT NOT NULL,
    entry_hash TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE,
    FOREIGN KEY (transaction_id) REFERENCES trade_transactions(id) ON DELETE SET NULL,
    FOREIGN KEY (actor_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS alerts (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    org_id TEXT NOT NULL,
    type TEXT NOT NULL,
    severity TEXT DEFAULT 'MEDIUM',
    message TEXT NOT NULL,
    related_transaction_id TEXT NULL,
    related_document_id TEXT NULL,
    is_read INTEGER DEFAULT 0,
    resolved INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (org_id) REFERENCES organizations(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS risk_scores (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    org_id TEXT NOT NULL,
    score INTEGER NOT NULL,
    rationale TEXT NOT NULL,
    calculation_method TEXT DEFAULT 'STANDARD_COMPLIANCE_ALGORITHM',
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (org_id) REFERENCES organizations(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS audit_logs (
    id TEXT PRIMARY KEY,
    admin_id TEXT NULL,
    actor_id TEXT NOT NULL,
    org_id TEXT NOT NULL,
    action TEXT NOT NULL,
    target_type TEXT NOT NULL,
    target_id TEXT NOT NULL,
    metadata TEXT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (actor_id) REFERENCES users(id),
    FOREIGN KEY (org_id) REFERENCES organizations(id)
);
