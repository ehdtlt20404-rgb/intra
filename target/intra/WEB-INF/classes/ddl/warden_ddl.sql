-- ============================================================
-- 기관장 실적·성과 관리시스템 Oracle DDL
-- DBeaver 에서 WARDEN 계정으로 실행하세요.
-- ※ 순서대로 실행해야 FK 오류 없이 생성됩니다.
-- ============================================================


-- ============================================================
-- 1. 리더십 범주 (LS_CATEGORY)
-- ============================================================
CREATE TABLE LS_CATEGORY (
    CAT_ID     VARCHAR2(36)   NOT NULL,
    TITLE      VARCHAR2(200)  NOT NULL,
    DEPT       VARCHAR2(100),
    SEQ        NUMBER         DEFAULT 0,
    CREATED_AT DATE           DEFAULT SYSDATE,
    CONSTRAINT PK_LS_CATEGORY PRIMARY KEY (CAT_ID)
);


-- ============================================================
-- 2. 중점과제 (LS_TASK)
-- ============================================================
CREATE TABLE LS_TASK (
    TASK_ID    VARCHAR2(36)   NOT NULL,
    CAT_ID     VARCHAR2(36)   NOT NULL,
    TITLE      VARCHAR2(200)  NOT NULL,
    SEQ        NUMBER         DEFAULT 0,
    CREATED_AT DATE           DEFAULT SYSDATE,
    CONSTRAINT PK_LS_TASK  PRIMARY KEY (TASK_ID),
    CONSTRAINT FK_TASK_CAT FOREIGN KEY (CAT_ID)
        REFERENCES LS_CATEGORY (CAT_ID) ON DELETE CASCADE
);


-- ============================================================
-- 3. 중점과제 상세 (LS_TASK_DETAIL)
-- ============================================================
CREATE TABLE LS_TASK_DETAIL (
    TASK_ID    VARCHAR2(36)  NOT NULL,
    KPI_NAME   VARCHAR2(300),
    SUB_ITEM   VARCHAR2(300),
    BG_ENV     CLOB,
    BG_LEADER  CLOB,
    DIRECTION  CLOB,
    ACT_TYPE   VARCHAR2(200),
    ACT_MAIN   CLOB,
    ACT_DETAIL CLOB,
    SCHEDULE   CLOB,
    EXPECTED   CLOB,
    UPDATED_AT DATE          DEFAULT SYSDATE,
    CONSTRAINT PK_LS_TASK_DETAIL  PRIMARY KEY (TASK_ID),
    CONSTRAINT FK_TASK_DET_TASK   FOREIGN KEY (TASK_ID)
        REFERENCES LS_TASK (TASK_ID) ON DELETE CASCADE
);


-- ============================================================
-- 4. 중점과제 월별 계획/실적 (LS_TASK_MONTH)
-- ============================================================
CREATE TABLE LS_TASK_MONTH (
    TASK_ID    VARCHAR2(36)  NOT NULL,
    MONTH_NUM  NUMBER(2)     NOT NULL,
    PLAN       VARCHAR2(2000),
    RESULT     VARCHAR2(2000),
    CONSTRAINT PK_LS_TASK_MONTH   PRIMARY KEY (TASK_ID, MONTH_NUM),
    CONSTRAINT FK_TASK_MON_TASK   FOREIGN KEY (TASK_ID)
        REFERENCES LS_TASK (TASK_ID) ON DELETE CASCADE,
    CONSTRAINT CHK_MONTH_NUM      CHECK (MONTH_NUM BETWEEN 1 AND 12)
);


-- ============================================================
-- 5. 경영계약 성과목표 (CT_GOAL)
-- ============================================================
CREATE TABLE CT_GOAL (
    GOAL_ID    VARCHAR2(36)  NOT NULL,
    TITLE      VARCHAR2(200) NOT NULL,
    SEQ        NUMBER        DEFAULT 0,
    CREATED_AT DATE          DEFAULT SYSDATE,
    CONSTRAINT PK_CT_GOAL PRIMARY KEY (GOAL_ID)
);


-- ============================================================
-- 6. 경영계약 성과지표 (CT_INDICATOR)
-- ============================================================
CREATE TABLE CT_INDICATOR (
    IND_ID     VARCHAR2(36)  NOT NULL,
    GOAL_ID    VARCHAR2(36)  NOT NULL,
    TITLE      VARCHAR2(200) NOT NULL,
    SEQ        NUMBER        DEFAULT 0,
    CREATED_AT DATE          DEFAULT SYSDATE,
    CONSTRAINT PK_CT_INDICATOR PRIMARY KEY (IND_ID),
    CONSTRAINT FK_IND_GOAL     FOREIGN KEY (GOAL_ID)
        REFERENCES CT_GOAL (GOAL_ID) ON DELETE CASCADE
);


-- ============================================================
-- 7. 경영계약 성과지표 상세 (CT_INDICATOR_DETAIL)
-- ============================================================
CREATE TABLE CT_INDICATOR_DETAIL (
    IND_ID     VARCHAR2(36)  NOT NULL,
    NAME       VARCHAR2(300),
    DEPT       VARCHAR2(100),
    QUANT      NUMBER(1)     DEFAULT 0,
    T1         VARCHAR2(100),
    T2         VARCHAR2(100),
    T3         VARCHAR2(100),
    FORECAST   VARCHAR2(100),
    PLAN       CLOB,
    UPDATED_AT DATE          DEFAULT SYSDATE,
    CONSTRAINT PK_CT_IND_DETAIL  PRIMARY KEY (IND_ID),
    CONSTRAINT FK_IND_DET_IND    FOREIGN KEY (IND_ID)
        REFERENCES CT_INDICATOR (IND_ID) ON DELETE CASCADE
);


-- ============================================================
-- 8. 경영계약 성과지표 월별 (CT_IND_MONTH)
-- ============================================================
CREATE TABLE CT_IND_MONTH (
    IND_ID     VARCHAR2(36)  NOT NULL,
    MONTH_NUM  NUMBER(2)     NOT NULL,
    PLAN       VARCHAR2(2000),
    RESULT     VARCHAR2(2000),
    CONSTRAINT PK_CT_IND_MONTH   PRIMARY KEY (IND_ID, MONTH_NUM),
    CONSTRAINT FK_IND_MON_IND    FOREIGN KEY (IND_ID)
        REFERENCES CT_INDICATOR (IND_ID) ON DELETE CASCADE,
    CONSTRAINT CHK_IND_MONTH_NUM CHECK (MONTH_NUM BETWEEN 1 AND 12)
);


-- ============================================================
-- 9. 세부과제 (CT_SUB_TASK)
-- ============================================================
CREATE TABLE CT_SUB_TASK (
    SUB_TASK_ID VARCHAR2(36)  NOT NULL,
    IND_ID      VARCHAR2(36)  NOT NULL,
    TITLE       VARCHAR2(300),
    CONSTRAINT PK_CT_SUB_TASK  PRIMARY KEY (SUB_TASK_ID),
    CONSTRAINT FK_SUB_TASK_IND FOREIGN KEY (IND_ID)
        REFERENCES CT_INDICATOR (IND_ID) ON DELETE CASCADE
);


-- ============================================================
-- 10. 활동내역 (ACT_MAIN)
-- ============================================================
CREATE TABLE ACT_MAIN (
    ACT_ID         VARCHAR2(36)   NOT NULL,
    CATEGORY       VARCHAR2(50),
    TITLE          VARCHAR2(500),
    RECOGNITION    CLOB,
    DIRECTION      CLOB,
    TYPE_PRIMARY   VARCHAR2(50),
    TYPE_SECONDARY VARCHAR2(500),
    CONTENT        CLOB,
    ACT_DATE       VARCHAR2(10),
    PROOF          VARCHAR2(1000),
    STATUS         VARCHAR2(20)   DEFAULT 'active',
    CREATED_AT     DATE           DEFAULT SYSDATE,
    UPDATED_AT     DATE           DEFAULT SYSDATE,
    CONSTRAINT PK_ACT_MAIN PRIMARY KEY (ACT_ID)
);


-- ============================================================
-- 11. 활동 연관지표 (ACT_INDICATOR)
-- ============================================================
CREATE TABLE ACT_INDICATOR (
    ACT_ID    VARCHAR2(36)  NOT NULL,
    IND_ID    VARCHAR2(36)  NOT NULL,
    IND_LABEL VARCHAR2(300),
    CONSTRAINT PK_ACT_INDICATOR PRIMARY KEY (ACT_ID, IND_ID),
    CONSTRAINT FK_ACT_IND_ACT   FOREIGN KEY (ACT_ID)
        REFERENCES ACT_MAIN (ACT_ID) ON DELETE CASCADE
);


-- ============================================================
-- 인덱스
-- ============================================================
CREATE INDEX IDX_LS_TASK_CAT    ON LS_TASK       (CAT_ID);
CREATE INDEX IDX_CT_IND_GOAL    ON CT_INDICATOR  (GOAL_ID);
CREATE INDEX IDX_ACT_CATEGORY   ON ACT_MAIN      (CATEGORY);
CREATE INDEX IDX_ACT_DATE       ON ACT_MAIN      (ACT_DATE);
CREATE INDEX IDX_ACT_IND_ACT    ON ACT_INDICATOR (ACT_ID);


-- ============================================================
-- 샘플 데이터 (선택사항 — 필요시 실행)
-- ============================================================
/*
INSERT INTO LS_CATEGORY (CAT_ID, TITLE, DEPT, SEQ) VALUES
    (LOWER(RAWTOHEX(SYS_GUID())), '경영혁신', '기획부', 1);

INSERT INTO CT_GOAL (GOAL_ID, TITLE, SEQ) VALUES
    (LOWER(RAWTOHEX(SYS_GUID())), '재무성과 향상', 1);

COMMIT;
*/
