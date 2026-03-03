-- =============================================
-- V1: 초기 스키마 생성
-- =============================================

-- ===================
-- user
-- ===================

CREATE TABLE "user" (
    id BIGSERIAL PRIMARY KEY,
    login_id VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
    use_yn VARCHAR(1) NOT NULL DEFAULT 'Y',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    create_id BIGINT DEFAULT 0,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_id BIGINT DEFAULT 0
);

COMMENT ON TABLE "user" IS '사용자';
COMMENT ON COLUMN "user".id IS '사용자 PK';
COMMENT ON COLUMN "user".login_id IS '로그인 ID';
COMMENT ON COLUMN "user".password IS '비밀번호 (BCrypt 암호화)';
COMMENT ON COLUMN "user".name IS '사용자 이름';
COMMENT ON COLUMN "user".use_yn IS '사용 여부 (Y/N)';
COMMENT ON COLUMN "user".create_time IS '생성 일시';
COMMENT ON COLUMN "user".create_id IS '생성자 ID';
COMMENT ON COLUMN "user".update_time IS '수정 일시';
COMMENT ON COLUMN "user".update_id IS '수정자 ID';

-- ===================
-- file
-- ===================

CREATE TABLE "file" (
    id BIGSERIAL PRIMARY KEY,
    ref_path VARCHAR(100) DEFAULT NULL,
    ref_id BIGINT DEFAULT NULL,
    ori_name VARCHAR(100) DEFAULT NULL,
    new_name VARCHAR(200) DEFAULT NULL,
    save_path VARCHAR(200) DEFAULT NULL,
    ext VARCHAR(45) DEFAULT NULL,
    type VARCHAR(100) DEFAULT NULL,
    size BIGINT DEFAULT NULL,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    create_id BIGINT DEFAULT 0,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_id BIGINT DEFAULT 0
);

COMMENT ON TABLE "file" IS '파일';
COMMENT ON COLUMN "file".id IS '파일 PK';
COMMENT ON COLUMN "file".ref_path IS '참조 경로 (연관 모듈 식별)';
COMMENT ON COLUMN "file".ref_id IS '참조 ID (연관 레코드 PK)';
COMMENT ON COLUMN "file".ori_name IS '원본 파일명';
COMMENT ON COLUMN "file".new_name IS '저장 파일명 (UUID 등)';
COMMENT ON COLUMN "file".save_path IS '저장 경로';
COMMENT ON COLUMN "file".ext IS '파일 확장자';
COMMENT ON COLUMN "file".type IS '파일 MIME 타입';
COMMENT ON COLUMN "file".size IS '파일 크기 (bytes)';
COMMENT ON COLUMN "file".create_time IS '생성 일시';
COMMENT ON COLUMN "file".create_id IS '생성자 ID';
COMMENT ON COLUMN "file".update_time IS '수정 일시';
COMMENT ON COLUMN "file".update_id IS '수정자 ID';

-- ===================
-- code_group
-- ===================

CREATE TABLE code_group (
    id BIGSERIAL PRIMARY KEY,
    code_group VARCHAR(10) NOT NULL,
    name VARCHAR(100) NOT NULL,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    create_id BIGINT DEFAULT 0,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_id BIGINT DEFAULT 0
);

COMMENT ON TABLE code_group IS '코드 그룹';
COMMENT ON COLUMN code_group.id IS '코드 그룹 PK';
COMMENT ON COLUMN code_group.code_group IS '코드 그룹 식별자';
COMMENT ON COLUMN code_group.name IS '코드 그룹명';
COMMENT ON COLUMN code_group.create_time IS '생성 일시';
COMMENT ON COLUMN code_group.create_id IS '생성자 ID';
COMMENT ON COLUMN code_group.update_time IS '수정 일시';
COMMENT ON COLUMN code_group.update_id IS '수정자 ID';

-- ===================
-- code
-- ===================

CREATE TABLE code (
    id BIGSERIAL PRIMARY KEY,
    code_group_id BIGINT NOT NULL,
    code VARCHAR(10) NOT NULL,
    name VARCHAR(100) NOT NULL,
    info VARCHAR(1000) DEFAULT NULL,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    create_id BIGINT DEFAULT 0,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_id BIGINT DEFAULT 0,
    CONSTRAINT uk_code_group_code UNIQUE (code_group_id, code)
);

COMMENT ON TABLE code IS '코드';
COMMENT ON COLUMN code.id IS '코드 PK';
COMMENT ON COLUMN code.code_group_id IS '코드 그룹 FK (code_group.id)';
COMMENT ON COLUMN code.code IS '코드 값';
COMMENT ON COLUMN code.name IS '코드명';
COMMENT ON COLUMN code.info IS '코드 부가 정보';
COMMENT ON COLUMN code.create_time IS '생성 일시';
COMMENT ON COLUMN code.create_id IS '생성자 ID';
COMMENT ON COLUMN code.update_time IS '수정 일시';
COMMENT ON COLUMN code.update_id IS '수정자 ID';