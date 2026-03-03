-- =============================================
-- V2: 기본 데이터 삽입
-- =============================================

-- 관리자 계정 (password: admin)
INSERT INTO "user" (login_id, password, name, use_yn, create_id)
VALUES ('admin', '$2a$10$JHRc1ScPG1dQncw9Jh8oJOyCtIzgi2uCYbQnu4OYz1QVcDs8kWpD2', '관리자', 'Y', 1);
