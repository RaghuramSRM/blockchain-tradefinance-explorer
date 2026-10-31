-- ==========================================================
-- Trade Finance Blockchain Explorer (ChainDocs)
-- MySQL Schema - Complete 11 Tables for Review 02
-- Compatible with MySQL 8.0, MariaDB & XAMPP
-- ==========================================================

CREATE DATABASE IF NOT EXISTS `chaindocs` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `chaindocs`;

-- 1. Organizations
CREATE TABLE IF NOT EXISTS `organizations` (
    `id` VARCHAR(36) PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `organization_type` ENUM('ADMIN', 'BANK', 'CORPORATE', 'AUDITOR') NOT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Users
CREATE TABLE IF NOT EXISTS `users` (
    `id` VARCHAR(36) PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `hashed_password` VARCHAR(255) NOT NULL,
    `role` ENUM('ADMIN', 'BANK', 'CORPORATE', 'AUDITOR') NOT NULL,
    `org_id` VARCHAR(36) NULL,
    `is_active` TINYINT(1) DEFAULT 1,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_users_org` FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 3. Organization Members
CREATE TABLE IF NOT EXISTS `organization_members` (
    `id` VARCHAR(36) PRIMARY KEY,
    `org_id` VARCHAR(36) NOT NULL,
    `user_id` VARCHAR(36) NOT NULL,
    `membership_role` VARCHAR(50) DEFAULT 'MEMBER',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_om_org` FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_om_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 4. Refresh Tokens
CREATE TABLE IF NOT EXISTS `refresh_tokens` (
    `id` VARCHAR(36) PRIMARY KEY,
    `user_id` VARCHAR(36) NOT NULL,
    `token_hash` VARCHAR(255) NOT NULL,
    `expires_at` DATETIME NOT NULL,
    `revoked_at` DATETIME NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_rt_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. Trade Transactions
CREATE TABLE IF NOT EXISTS `trade_transactions` (
    `id` VARCHAR(36) PRIMARY KEY,
    `reference_number` VARCHAR(100) NOT NULL UNIQUE,
    `buyer_id` VARCHAR(36) NOT NULL,
    `seller_id` VARCHAR(36) NOT NULL,
    `created_by` VARCHAR(36) NOT NULL,
    `org_id` VARCHAR(36) NOT NULL,
    `amount` DECIMAL(15, 2) NOT NULL,
    `currency` VARCHAR(10) NOT NULL DEFAULT 'USD',
    `status` ENUM('PENDING', 'IN_PROGRESS', 'COMPLETED', 'DISPUTED') NOT NULL DEFAULT 'PENDING',
    `description` TEXT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_tx_buyer` FOREIGN KEY (`buyer_id`) REFERENCES `users`(`id`),
    CONSTRAINT `fk_tx_seller` FOREIGN KEY (`seller_id`) REFERENCES `users`(`id`),
    CONSTRAINT `fk_tx_creator` FOREIGN KEY (`created_by`) REFERENCES `users`(`id`),
    CONSTRAINT `fk_tx_org` FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`)
) ENGINE=InnoDB;

-- 6. Transaction History (Workflow Audit)
CREATE TABLE IF NOT EXISTS `transaction_history` (
    `id` VARCHAR(36) PRIMARY KEY,
    `transaction_id` VARCHAR(36) NOT NULL,
    `actor_id` VARCHAR(36) NOT NULL,
    `previous_status` VARCHAR(50) NULL,
    `new_status` VARCHAR(50) NOT NULL,
    `action` VARCHAR(100) NOT NULL,
    `remarks` TEXT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_th_tx` FOREIGN KEY (`transaction_id`) REFERENCES `trade_transactions`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_th_actor` FOREIGN KEY (`actor_id`) REFERENCES `users`(`id`)
) ENGINE=InnoDB;

-- 7. Documents
CREATE TABLE IF NOT EXISTS `documents` (
    `id` VARCHAR(36) PRIMARY KEY,
    `owner_id` VARCHAR(36) NOT NULL,
    `org_id` VARCHAR(36) NOT NULL,
    `transaction_id` VARCHAR(36) NULL,
    `doc_type` ENUM('LOC', 'INVOICE', 'BILL_OF_LADING', 'PO', 'COO', 'INSURANCE_CERT') NOT NULL,
    `doc_number` VARCHAR(100) NOT NULL,
    `file_url` TEXT NOT NULL,
    `original_filename` VARCHAR(255) NOT NULL,
    `mime_type` VARCHAR(100) NOT NULL,
    `file_size` INT NOT NULL,
    `sha256_hash` VARCHAR(64) NOT NULL,
    `issued_at` DATETIME NOT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_doc_owner` FOREIGN KEY (`owner_id`) REFERENCES `users`(`id`),
    CONSTRAINT `fk_doc_org` FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`),
    CONSTRAINT `fk_doc_tx` FOREIGN KEY (`transaction_id`) REFERENCES `trade_transactions`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 8. Hash-Linked Ledger Entries (Blockchain Architecture)
CREATE TABLE IF NOT EXISTS `ledger_entries` (
    `id` VARCHAR(36) PRIMARY KEY,
    `document_id` VARCHAR(36) NULL,
    `transaction_id` VARCHAR(36) NULL,
    `actor_id` VARCHAR(36) NOT NULL,
    `action` ENUM('ISSUED', 'AMENDED', 'SHIPPED', 'RECEIVED', 'PAID', 'CANCELLED', 'VERIFIED') NOT NULL,
    `metadata` JSON NULL,
    `previous_hash` VARCHAR(64) NOT NULL,
    `entry_hash` VARCHAR(64) NOT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_ledger_doc` FOREIGN KEY (`document_id`) REFERENCES `documents`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_ledger_tx` FOREIGN KEY (`transaction_id`) REFERENCES `trade_transactions`(`id`) ON DELETE SET NULL,
    CONSTRAINT `fk_ledger_actor` FOREIGN KEY (`actor_id`) REFERENCES `users`(`id`)
) ENGINE=InnoDB;

-- 9. Alerts
CREATE TABLE IF NOT EXISTS `alerts` (
    `id` VARCHAR(36) PRIMARY KEY,
    `user_id` VARCHAR(36) NOT NULL,
    `org_id` VARCHAR(36) NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    `severity` ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') DEFAULT 'MEDIUM',
    `message` TEXT NOT NULL,
    `related_transaction_id` VARCHAR(36) NULL,
    `related_document_id` VARCHAR(36) NULL,
    `is_read` TINYINT(1) DEFAULT 0,
    `resolved` TINYINT(1) DEFAULT 0,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_alert_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_alert_org` FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 10. Risk Scores
CREATE TABLE IF NOT EXISTS `risk_scores` (
    `id` VARCHAR(36) PRIMARY KEY,
    `user_id` VARCHAR(36) NOT NULL,
    `org_id` VARCHAR(36) NOT NULL,
    `score` INT NOT NULL,
    `rationale` TEXT NOT NULL,
    `calculation_method` VARCHAR(100) DEFAULT 'STANDARD_COMPLIANCE_ALGORITHM',
    `last_updated` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_risk_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_risk_org` FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 11. Audit Logs
CREATE TABLE IF NOT EXISTS `audit_logs` (
    `id` VARCHAR(36) PRIMARY KEY,
    `admin_id` VARCHAR(36) NULL,
    `actor_id` VARCHAR(36) NOT NULL,
    `org_id` VARCHAR(36) NOT NULL,
    `action` VARCHAR(100) NOT NULL,
    `target_type` VARCHAR(50) NOT NULL,
    `target_id` VARCHAR(36) NOT NULL,
    `metadata` JSON NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_audit_actor` FOREIGN KEY (`actor_id`) REFERENCES `users`(`id`),
    CONSTRAINT `fk_audit_org` FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`)
) ENGINE=InnoDB;
