-- ============================================================
-- PASSWORD MANAGEMENT SYSTEM
-- schema.sql
-- Database Systems Project - Fall 2026
-- ============================================================

-- This resets ONLY the project database so the complete project
-- can be rebuilt cleanly when this script is executed again.

DROP DATABASE IF EXISTS password_management_system;

CREATE DATABASE password_management_system;

USE password_management_system;

-- ============================================================
-- TABLE 1: USER
-- ============================================================

CREATE TABLE `User` (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(30)
);

-- ============================================================
-- TABLE 2: WEBSITE
-- ============================================================

CREATE TABLE `Website` (
    website_id INT AUTO_INCREMENT PRIMARY KEY,
    website_name VARCHAR(100) NOT NULL,
    website_url VARCHAR(255)
);

-- ============================================================
-- TABLE 3: CATEGORY
-- ============================================================

CREATE TABLE `Category` (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

-- ============================================================
-- TABLE 4: ACCOUNT
-- ============================================================

CREATE TABLE `Account` (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    website_id INT NOT NULL,
    category_id INT NOT NULL,
    username VARCHAR(100) NOT NULL,
    encrypted_password VARCHAR(255) NOT NULL,
    date_created DATE NOT NULL,
    last_updated DATE,

    CONSTRAINT fk_account_user
        FOREIGN KEY (user_id)
        REFERENCES `User`(user_id),

    CONSTRAINT fk_account_website
        FOREIGN KEY (website_id)
        REFERENCES `Website`(website_id),

    CONSTRAINT fk_account_category
        FOREIGN KEY (category_id)
        REFERENCES `Category`(category_id)
);

-- ============================================================
-- TABLE 5: PASSWORD HISTORY
-- ============================================================

CREATE TABLE `PasswordHistory` (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    old_encrypted_password VARCHAR(255) NOT NULL,
    changed_date DATE NOT NULL,

    CONSTRAINT fk_passwordhistory_account
        FOREIGN KEY (account_id)
        REFERENCES `Account`(account_id)
);

-- ============================================================
-- TABLE 6: SECURITY QUESTION
-- ============================================================

CREATE TABLE `SecurityQuestion` (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    question_text VARCHAR(255) NOT NULL,
    encrypted_answer VARCHAR(255) NOT NULL,

    CONSTRAINT fk_securityquestion_account
        FOREIGN KEY (account_id)
        REFERENCES `Account`(account_id)
);

-- ============================================================
-- PASSWORD HISTORY TRIGGER
-- ============================================================
-- When an Account password changes, the old encrypted value
-- is automatically stored in PasswordHistory.

DELIMITER $$

CREATE TRIGGER before_account_password_update
BEFORE UPDATE ON `Account`
FOR EACH ROW
BEGIN

    IF NOT (OLD.encrypted_password <=> NEW.encrypted_password) THEN

        INSERT INTO `PasswordHistory`
        (
            account_id,
            old_encrypted_password,
            changed_date
        )
        VALUES
        (
            OLD.account_id,
            OLD.encrypted_password,
            CURDATE()
        );

        SET NEW.last_updated = CURDATE();

    END IF;

END$$

DELIMITER ;
