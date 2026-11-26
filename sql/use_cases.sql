-- ============================================================
-- PASSWORD MANAGEMENT SYSTEM
-- use_cases.sql
-- CRUD, USE CASES, AGGREGATES, JOINS, AND TESTING
-- ============================================================

USE password_management_system;

-- All demonstration changes in this file occur inside a
-- transaction. ROLLBACK at the end restores the original
-- sample database after the tests are completed.

START TRANSACTION;

-- ============================================================
-- USE CASE 1: ADD NEW ACCOUNT
-- ============================================================

INSERT INTO `Account`
(
    user_id,
    website_id,
    category_id,
    username,
    encrypted_password,
    date_created,
    last_updated
)
VALUES
(
    1,
    1,
    1,
    'new.demo.user',
    'ENC_FAKE_NEW_ACCOUNT',
    CURDATE(),
    CURDATE()
);

SET @new_account_id = LAST_INSERT_ID();

SELECT *
FROM `Account`
WHERE account_id = @new_account_id;

-- ============================================================
-- USE CASE 2: UPDATE PASSWORD
-- ============================================================
-- The trigger automatically stores the previous password
-- value in PasswordHistory.

UPDATE `Account`
SET encrypted_password = 'ENC_FAKE_UPDATED_PASSWORD'
WHERE account_id = 1;

SELECT *
FROM `Account`
WHERE account_id = 1;

SELECT *
FROM `PasswordHistory`
WHERE account_id = 1
ORDER BY changed_date DESC;

-- ============================================================
-- USE CASE 3: DELETE ACCOUNT
-- ============================================================

DELETE FROM `Account`
WHERE account_id = @new_account_id;

-- ============================================================
-- USE CASE 4: SEARCH ACCOUNTS BY CATEGORY
-- ============================================================

SELECT
    a.account_id,
    u.full_name,
    w.website_name,
    c.category_name,
    a.username,
    a.last_updated
FROM `Account` a
JOIN `User` u
    ON a.user_id = u.user_id
JOIN `Website` w
    ON a.website_id = w.website_id
JOIN `Category` c
    ON a.category_id = c.category_id
WHERE c.category_name = 'Banking';

-- ============================================================
-- USE CASE 5: VIEW PASSWORD HISTORY
-- ============================================================

SELECT
    ph.history_id,
    ph.account_id,
    w.website_name,
    a.username,
    ph.old_encrypted_password,
    ph.changed_date
FROM `PasswordHistory` ph
JOIN `Account` a
    ON ph.account_id = a.account_id
JOIN `Website` w
    ON a.website_id = w.website_id
WHERE ph.account_id = 1
ORDER BY ph.changed_date DESC;

-- ============================================================
-- USE CASE 6A: GENERATE ACCOUNTS-BY-CATEGORY REPORT
-- ============================================================

SELECT
    c.category_name,
    COUNT(a.account_id) AS account_count
FROM `Category` c
LEFT JOIN `Account` a
    ON c.category_id = a.category_id
GROUP BY
    c.category_id,
    c.category_name
ORDER BY
    account_count DESC,
    c.category_name;

-- ============================================================
-- USE CASE 6B: GENERATE ACCOUNTS-BY-WEBSITE REPORT
-- ============================================================

SELECT
    w.website_name,
    COUNT(a.account_id) AS account_count
FROM `Website` w
LEFT JOIN `Account` a
    ON w.website_id = a.website_id
GROUP BY
    w.website_id,
    w.website_name
ORDER BY
    account_count DESC,
    w.website_name;

-- ============================================================
-- REQUIRED INSERT TESTS
-- ONE INSERT FOR EVERY TABLE
-- ============================================================

INSERT INTO `User`
(full_name, email, phone)
VALUES
(
    'Temporary Test User',
    'temporary.user@example.com',
    '555-0191'
);

SET @temp_user_id = LAST_INSERT_ID();


INSERT INTO `Website`
(website_name, website_url)
VALUES
(
    'Temporary Test Website',
    'https://temporary.example.com'
);

SET @temp_website_id = LAST_INSERT_ID();


INSERT INTO `Category`
(category_name, description)
VALUES
(
    'Temporary Test Category',
    'Temporary category used for CRUD testing'
);

SET @temp_category_id = LAST_INSERT_ID();


INSERT INTO `Account`
(
    user_id,
    website_id,
    category_id,
    username,
    encrypted_password,
    date_created,
    last_updated
)
VALUES
(
    @temp_user_id,
    @temp_website_id,
    @temp_category_id,
    'temporary.username',
    'ENC_FAKE_TEMP_PASSWORD',
    CURDATE(),
    CURDATE()
);

SET @temp_account_id = LAST_INSERT_ID();


INSERT INTO `PasswordHistory`
(
    account_id,
    old_encrypted_password,
    changed_date
)
VALUES
(
    @temp_account_id,
    'ENC_FAKE_TEMP_OLD_PASSWORD',
    CURDATE()
);

SET @temp_history_id = LAST_INSERT_ID();


INSERT INTO `SecurityQuestion`
(
    account_id,
    question_text,
    encrypted_answer
)
VALUES
(
    @temp_account_id,
    'What is your temporary fictional answer?',
    'ENC_FAKE_TEMP_ANSWER'
);

SET @temp_question_id = LAST_INSERT_ID();

-- ============================================================
-- REQUIRED UPDATE TESTS
-- ONE UPDATE FOR EVERY TABLE
-- ============================================================

UPDATE `User`
SET phone = '555-0192'
WHERE user_id = @temp_user_id;


UPDATE `Website`
SET website_url = 'https://updated-temporary.example.com'
WHERE website_id = @temp_website_id;


UPDATE `Category`
SET description =
    'Updated temporary category used for CRUD testing'
WHERE category_id = @temp_category_id;


UPDATE `Account`
SET encrypted_password =
    'ENC_FAKE_TEMP_PASSWORD_UPDATED'
WHERE account_id = @temp_account_id;


UPDATE `PasswordHistory`
SET changed_date = CURDATE()
WHERE history_id = @temp_history_id;


UPDATE `SecurityQuestion`
SET encrypted_answer =
    'ENC_FAKE_TEMP_ANSWER_UPDATED'
WHERE question_id = @temp_question_id;

-- ============================================================
-- REQUIRED AGGREGATE QUERIES
-- ONE FOR EVERY TABLE
-- ============================================================

-- USER
SELECT COUNT(*) AS total_users
FROM `User`;

-- WEBSITE
SELECT COUNT(*) AS total_websites
FROM `Website`;

-- CATEGORY
SELECT COUNT(*) AS total_categories
FROM `Category`;

-- ACCOUNT
SELECT COUNT(*) AS total_accounts
FROM `Account`;

-- PASSWORD HISTORY
SELECT COUNT(*) AS total_password_history_records
FROM `PasswordHistory`;

-- SECURITY QUESTION
SELECT COUNT(*) AS total_security_questions
FROM `SecurityQuestion`;

-- ============================================================
-- ADDITIONAL REPORT AGGREGATES
-- ============================================================

SELECT
    c.category_name,
    COUNT(a.account_id) AS accounts_in_category
FROM `Category` c
LEFT JOIN `Account` a
    ON c.category_id = a.category_id
GROUP BY c.category_id, c.category_name;


SELECT
    w.website_name,
    COUNT(a.account_id) AS accounts_for_website
FROM `Website` w
LEFT JOIN `Account` a
    ON w.website_id = a.website_id
GROUP BY w.website_id, w.website_name;


SELECT
    a.account_id,
    COUNT(sq.question_id) AS security_questions_for_account
FROM `Account` a
LEFT JOIN `SecurityQuestion` sq
    ON a.account_id = sq.account_id
GROUP BY a.account_id;

-- ============================================================
-- REQUIRED JOIN 1
-- USER -> ACCOUNT
-- ============================================================

SELECT
    u.user_id,
    u.full_name,
    a.account_id,
    a.username
FROM `User` u
JOIN `Account` a
    ON u.user_id = a.user_id;

-- ============================================================
-- REQUIRED JOIN 2
-- WEBSITE -> ACCOUNT
-- ============================================================

SELECT
    w.website_id,
    w.website_name,
    a.account_id,
    a.username
FROM `Website` w
JOIN `Account` a
    ON w.website_id = a.website_id;

-- ============================================================
-- REQUIRED JOIN 3
-- CATEGORY -> ACCOUNT
-- ============================================================

SELECT
    c.category_id,
    c.category_name,
    a.account_id,
    a.username
FROM `Category` c
JOIN `Account` a
    ON c.category_id = a.category_id;

-- ============================================================
-- REQUIRED JOIN 4
-- ACCOUNT -> PASSWORD HISTORY
-- ============================================================

SELECT
    a.account_id,
    a.username,
    ph.history_id,
    ph.old_encrypted_password,
    ph.changed_date
FROM `Account` a
JOIN `PasswordHistory` ph
    ON a.account_id = ph.account_id;

-- ============================================================
-- REQUIRED JOIN 5
-- ACCOUNT -> SECURITY QUESTION
-- ============================================================

SELECT
    a.account_id,
    a.username,
    sq.question_id,
    sq.question_text
FROM `Account` a
JOIN `SecurityQuestion` sq
    ON a.account_id = sq.account_id;

-- ============================================================
-- DISPLAY ALL TABLE DATA
-- ============================================================

SELECT * FROM `User`;
SELECT * FROM `Website`;
SELECT * FROM `Category`;
SELECT * FROM `Account`;
SELECT * FROM `PasswordHistory`;
SELECT * FROM `SecurityQuestion`;

-- ============================================================
-- REQUIRED DELETE TESTS
-- ONE DELETE FOR EVERY TABLE
--
-- Child records are deleted first because of foreign keys.
-- ============================================================

DELETE FROM `SecurityQuestion`
WHERE question_id = @temp_question_id;


DELETE FROM `PasswordHistory`
WHERE account_id = @temp_account_id;


DELETE FROM `Account`
WHERE account_id = @temp_account_id;


DELETE FROM `Category`
WHERE category_id = @temp_category_id;


DELETE FROM `Website`
WHERE website_id = @temp_website_id;


DELETE FROM `User`
WHERE user_id = @temp_user_id;

-- ============================================================
-- RESTORE DATABASE TO ORIGINAL SAMPLE STATE
-- ============================================================

ROLLBACK;
