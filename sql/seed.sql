-- ============================================================
-- PASSWORD MANAGEMENT SYSTEM
-- seed.sql
-- FAKE SAMPLE DATA ONLY
-- ============================================================

USE password_management_system;

-- ============================================================
-- USERS
-- ============================================================

INSERT INTO `User`
(full_name, email, phone)
VALUES
('Demo User One', 'demo1@example.com', '555-0101'),
('Demo User Two', 'demo2@example.com', '555-0102'),
('Demo Admin', 'admin@example.com', '555-0103');

-- ============================================================
-- WEBSITES
-- ============================================================

INSERT INTO `Website`
(website_name, website_url)
VALUES
('Example Mail', 'https://mail.example.com'),
('Example Bank', 'https://bank.example.com'),
('Example Shop', 'https://shop.example.com'),
('Example School', 'https://school.example.com'),
('Example Stream', 'https://stream.example.com'),
('Example Work', 'https://work.example.com');

-- ============================================================
-- CATEGORIES
-- ============================================================

INSERT INTO `Category`
(category_name, description)
VALUES
('Email', 'Email and communication accounts'),
('Banking', 'Banking and financial accounts'),
('Shopping', 'Online shopping accounts'),
('School', 'School and education accounts'),
('Entertainment', 'Streaming and entertainment accounts'),
('Work', 'Work-related accounts');

-- ============================================================
-- ACCOUNTS
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
    1, 1, 1,
    'demo.mail.user',
    'ENC_FAKE_MAIL_A1',
    '2026-07-01',
    '2026-07-01'
),
(
    1, 2, 2,
    'demo.bank.user',
    'ENC_FAKE_BANK_B1',
    '2026-07-02',
    '2026-07-02'
),
(
    1, 3, 3,
    'demo.shop.user',
    'ENC_FAKE_SHOP_C1',
    '2026-07-03',
    '2026-07-03'
),
(
    2, 4, 4,
    'demo.student',
    'ENC_FAKE_SCHOOL_D1',
    '2026-07-04',
    '2026-07-04'
),
(
    2, 5, 5,
    'demo.viewer',
    'ENC_FAKE_STREAM_E1',
    '2026-07-05',
    '2026-07-05'
),
(
    3, 6, 6,
    'demo.employee',
    'ENC_FAKE_WORK_F1',
    '2026-07-06',
    '2026-07-06'
);

-- ============================================================
-- PASSWORD HISTORY
-- ============================================================

INSERT INTO `PasswordHistory`
(account_id, old_encrypted_password, changed_date)
VALUES
(1, 'ENC_FAKE_MAIL_OLD', '2026-06-01'),
(2, 'ENC_FAKE_BANK_OLD', '2026-06-05'),
(4, 'ENC_FAKE_SCHOOL_OLD', '2026-06-10');

-- ============================================================
-- SECURITY QUESTIONS
-- ============================================================

INSERT INTO `SecurityQuestion`
(account_id, question_text, encrypted_answer)
VALUES
(
    1,
    'What is your favorite fictional city?',
    'ENC_FAKE_ANSWER_1'
),
(
    2,
    'What was the name of your first fictional pet?',
    'ENC_FAKE_ANSWER_2'
),
(
    3,
    'What is your fictional childhood nickname?',
    'ENC_FAKE_ANSWER_3'
),
(
    4,
    'What is your favorite fictional book?',
    'ENC_FAKE_ANSWER_4'
),
(
    5,
    'What is your favorite fictional movie?',
    'ENC_FAKE_ANSWER_5'
),
(
    6,
    'What is your fictional hometown?',
    'ENC_FAKE_ANSWER_6'
);

-- ============================================================
-- VERIFY SAMPLE DATA
-- ============================================================

SELECT * FROM `User`;
SELECT * FROM `Website`;
SELECT * FROM `Category`;
SELECT * FROM `Account`;
SELECT * FROM `PasswordHistory`;
SELECT * FROM `SecurityQuestion`;
