-- ==========================================================
-- ChainDocs Seed Data
-- ==========================================================

-- Organizations
INSERT OR IGNORE INTO organizations (id, name, organization_type) VALUES
('org-adm-01', 'Global Trade Oversight Authority', 'ADMIN'),
('org-bnk-01', 'Standard Chartered Global Trade', 'BANK'),
('org-bnk-02', 'HSBC Trade Solutions', 'BANK'),
('org-crp-01', 'Apex Global Commodities Ltd', 'CORPORATE'),
('org-crp-02', 'Pacific Maritime Logistics Corp', 'CORPORATE'),
('org-aud-01', 'Deloitte Audit & Integrity Services', 'AUDITOR');

-- Users (All default passwords: "Password123!")
-- Password hash: $2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi (or standard bcrypt)
INSERT OR IGNORE INTO users (id, name, email, hashed_password, role, org_id) VALUES
('usr-adm-01', 'Arthur Vance', 'admin@chaindocs.io', '$2y$10$iZg7W.5Qj2Zk61q8g9yLCO7uU3M1o0c.G1kHwU1Xq11rX4OcvzG/m', 'ADMIN', 'org-adm-01'),
('usr-bnk-01', 'Sarah Jenkins', 'bank@scb.com', '$2y$10$iZg7W.5Qj2Zk61q8g9yLCO7uU3M1o0c.G1kHwU1Xq11rX4OcvzG/m', 'BANK', 'org-bnk-01'),
('usr-bnk-02', 'Marcus Sterling', 'banker@hsbc.com', '$2y$10$iZg7W.5Qj2Zk61q8g9yLCO7uU3M1o0c.G1kHwU1Xq11rX4OcvzG/m', 'BANK', 'org-bnk-02'),
('usr-crp-01', 'Elena Rostova', 'buyer@apexcommodities.com', '$2y$10$iZg7W.5Qj2Zk61q8g9yLCO7uU3M1o0c.G1kHwU1Xq11rX4OcvzG/m', 'CORPORATE', 'org-crp-01'),
('usr-crp-02', 'David Chen', 'seller@pacificmaritime.com', '$2y$10$iZg7W.5Qj2Zk61q8g9yLCO7uU3M1o0c.G1kHwU1Xq11rX4OcvzG/m', 'CORPORATE', 'org-crp-02'),
('usr-aud-01', 'Rachel Zane', 'auditor@deloitte.com', '$2y$10$iZg7W.5Qj2Zk61q8g9yLCO7uU3M1o0c.G1kHwU1Xq11rX4OcvzG/m', 'AUDITOR', 'org-aud-01');

-- Trade Transactions
INSERT OR IGNORE INTO trade_transactions (id, reference_number, buyer_id, seller_id, created_by, org_id, amount, currency, status, description) VALUES
('tx-1001', 'TX-2026-APEX-001', 'usr-crp-01', 'usr-crp-02', 'usr-crp-01', 'org-crp-01', 450000.00, 'USD', 'IN_PROGRESS', 'Shipment of 1,200 MT Grade A Industrial Copper Cathodes'),
('tx-1002', 'TX-2026-APEX-002', 'usr-crp-01', 'usr-crp-02', 'usr-crp-01', 'org-crp-01', 1250000.00, 'USD', 'PENDING', 'Irrevocable Commercial Letter of Credit for LNG Cargo Transfer'),
('tx-1003', 'TX-2026-PAC-003', 'usr-crp-02', 'usr-crp-01', 'usr-crp-02', 'org-crp-02', 88000.00, 'EUR', 'COMPLETED', 'Export of Precision Electronics Equipment to Hamburg Port'),
('tx-1004', 'TX-2026-DISP-004', 'usr-crp-01', 'usr-crp-02', 'usr-crp-01', 'org-crp-01', 310000.00, 'USD', 'DISPUTED', 'Bill of Lading weight discrepancy noted at Singapore Inspection');

-- Documents
INSERT OR IGNORE INTO documents (id, owner_id, org_id, transaction_id, doc_type, doc_number, file_url, original_filename, mime_type, file_size, sha256_hash, issued_at) VALUES
('doc-101', 'usr-crp-01', 'org-crp-01', 'tx-1001', 'LOC', 'LOC-2026-9921', '/uploads/sample_loc.pdf', 'Letter_of_Credit_SCB.pdf', 'application/pdf', 142500, 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', '2026-03-10 10:00:00'),
('doc-102', 'usr-crp-02', 'org-crp-01', 'tx-1001', 'BILL_OF_LADING', 'BL-MAR-4421', '/uploads/bill_of_lading.pdf', 'Pacific_Ocean_BL_4421.pdf', 'application/pdf', 98400, 'b2c7e0f80875953046da8a164d1f2e1e072b26027a44f54e13460e61d8031e4f', '2026-03-12 14:30:00'),
('doc-103', 'usr-crp-01', 'org-crp-01', 'tx-1001', 'INVOICE', 'INV-APEX-882', '/uploads/commercial_invoice.pdf', 'Commercial_Invoice_882.pdf', 'application/pdf', 62300, '4ca9e799e0e352786793e407ed7a3e3ca247382f132b2a8f0b71f3e9aec86422', '2026-03-13 09:15:00');

-- Hash-Linked Ledger Entries (Blockchain Architecture)
INSERT OR IGNORE INTO ledger_entries (id, document_id, transaction_id, actor_id, action, metadata, previous_hash, entry_hash) VALUES
('blk-0001', NULL, NULL, 'usr-adm-01', 'ISSUED', '{"event": "GENESIS_LEDGER_INIT", "network": "ChainDocs-MainNet"}', '0000000000000000000000000000000000000000000000000000000000000000', '8f434346648f6b96df89dda901c5176b10a6d83961dd3c1ac88b59b2dc327aa4'),
('blk-0002', 'doc-101', 'tx-1001', 'usr-bnk-01', 'ISSUED', '{"event": "LOC_ISSUANCE_APPROVED", "limit": 500000}', '8f434346648f6b96df89dda901c5176b10a6d83961dd3c1ac88b59b2dc327aa4', '7b4e6361a9bc97e1f49618c4e04f05b0a927db6f89025e1a76bbd5b1bf18b31c'),
('blk-0003', 'doc-102', 'tx-1001', 'usr-crp-02', 'SHIPPED', '{"carrier": "Maersk Line", "vessel": "Sea Giant", "voyage": "V901"}', '7b4e6361a9bc97e1f49618c4e04f05b0a927db6f89025e1a76bbd5b1bf18b31c', '1f5b61d4993a4019a86b95758a032d88bb5d3780d603a744211603d36b8c47b5'),
('blk-0004', 'doc-101', 'tx-1001', 'usr-aud-01', 'VERIFIED', '{"audit_method": "SHA-256 Hash Matching with LC Issuance Root"}', '1f5b61d4993a4019a86b95758a032d88bb5d3780d603a744211603d36b8c47b5', '9c882bbd1469e859f51a4a4073365851484b25e24bcf8449c2596541f5309446');

-- Alerts
INSERT OR IGNORE INTO alerts (id, user_id, org_id, type, severity, message, related_transaction_id, related_document_id, is_read, resolved) VALUES
('alt-01', 'usr-bnk-01', 'org-bnk-01', 'TRANSACTION_UPDATE', 'LOW', 'New Letter of Credit submitted for TX-2026-APEX-002 requiring bank review.', 'tx-1002', 'doc-101', 0, 0),
('alt-02', 'usr-crp-01', 'org-crp-01', 'DISPUTE_RAISED', 'HIGH', 'Counterparty raised a dispute on weight declaration for TX-2026-DISP-004.', 'tx-1004', NULL, 0, 0),
('alt-03', 'usr-adm-01', 'org-adm-01', 'INTEGRITY_CHECK', 'MEDIUM', 'System cryptographic verification cycle completed. 100% blocks valid.', NULL, NULL, 1, 1);

-- Risk Scores
INSERT OR IGNORE INTO risk_scores (id, user_id, org_id, score, rationale, calculation_method) VALUES
('rsk-01', 'usr-crp-01', 'org-crp-01', 88, 'Low default rate, 99.4% on-time settlement, verified KYC documentation', 'BASEL_III_STANDARDIZED'),
('rsk-02', 'usr-crp-02', 'org-crp-02', 74, 'Moderate shipping delay exposure, 1 active unresolved dispute', 'BASEL_III_STANDARDIZED'),
('rsk-03', 'usr-bnk-01', 'org-bnk-01', 96, 'Tier-1 Capital adequacy ratio exceeding 16.5%, investment grade A+', 'CAMELS_RATING_MODEL');
