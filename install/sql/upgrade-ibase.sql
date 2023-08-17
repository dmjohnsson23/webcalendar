/*UPGRADE_V0.9.14*/
UPDATE WEBCAL_ENTRY SET CAL_TIME = -1 WHERE CAL_TIME IS NULL;
CREATE TABLE WEBCAL_ENTRY_REPEATS
(
   CAL_ID INTEGER DEFAULT 0 NOT NULL,
   CAL_TYPE VARCHAR(20) CHARACTER SET WIN1252,
   CAL_END INTEGER,
   CAL_FREQUENCY INTEGER DEFAULT 1,
   CAL_DAYS CHAR(7) CHARACTER SET WIN1252
);
CREATE INDEX IWEBCAL_ENTRY_REPEATSNEWINDEX ON WEBCAL_ENTRY_REPEATS(CAL_ID);

/*UPGRADE_V0.9.22*/
CREATE TABLE WEBCAL_USER_LAYERS
(
   CAL_LAYERID INTEGER DEFAULT 0 NOT NULL,
   CAL_LOGIN VARCHAR(25) CHARACTER SET WIN1252 NOT NULL,
   CAL_LAYERUSER VARCHAR(25) CHARACTER SET WIN1252 NOT NULL,
   CAL_COLOR VARCHAR(25) CHARACTER SET WIN1252,
   CAL_DUPS CHAR(1) CHARACTER SET WIN1252 DEFAULT 'N'
);
CREATE INDEX IWEBCAL_USER_LAYERSNEWINDEX ON WEBCAL_USER_LAYERS(CAL_LOGIN, CAL_LAYERUSER);

/*UPGRADE_V0.9.27*/
CREATE TABLE WEBCAL_SITE_EXTRAS
(
   CAL_ID INTEGER DEFAULT 0 NOT NULL,
   CAL_NAME VARCHAR(25) CHARACTER SET WIN1252 NOT NULL,
   CAL_TYPE INTEGER NOT NULL,
   CAL_DATE INTEGER DEFAULT 0,
   CAL_REMIND INTEGER DEFAULT 0,
   CAL_DATA VARCHAR(500) CHARACTER SET WIN1252
);
CREATE INDEX IWEBCAL_SITE_EXTRASNEWINDEX ON WEBCAL_SITE_EXTRAS(CAL_ID, CAL_NAME, CAL_TYPE);
/*UPGRADE_V0.9.35*/
CREATE TABLE WEBCAL_GROUP
(
   CAL_GROUP_ID INTEGER DEFAULT 0 NOT NULL,
   CAL_OWNER VARCHAR(25) CHARACTER SET WIN1252,
   CAL_NAME VARCHAR(50) CHARACTER SET WIN1252 NOT NULL,
   CAL_LAST_UPDATE INTEGER DEFAULT 0 NOT NULL
);
CREATE INDEX IWEBCAL_GROUPNEWINDEX ON WEBCAL_GROUP(CAL_GROUP_ID);
CREATE TABLE WEBCAL_GROUP_USER
(
   CAL_GROUP_ID INTEGER DEFAULT 0 NOT NULL,
   CAL_LOGIN VARCHAR(25) CHARACTER SET WIN1252 NOT NULL
);
CREATE INDEX IWEBCAL_GROUPUSERNEWINDEX ON WEBCAL_GROUP_USER(CAL_GROUP_ID, CAL_LOGIN);
CREATE TABLE WEBCAL_VIEW
(
   CAL_VIEW_ID INTEGER DEFAULT 0 NOT NULL,
   CAL_OWNER VARCHAR(25) CHARACTER SET WIN1252 NOT NULL,
   CAL_NAME VARCHAR(50) CHARACTER SET WIN1252 NOT NULL,
   CAL_VIEW_TYPE VARCHAR(1) CHARACTER SET WIN1252 NOT NULL,
   CAL_IS_GLOBAL CHAR(1) CHARACTER SET WIN1252 DEFAULT 'N' NOT NULL
);
CREATE INDEX IWEBCAL_VIEWNEWINDEX ON WEBCAL_VIEW(CAL_VIEW_ID);
CREATE TABLE WEBCAL_VIEW_USER
(
   CAL_VIEW_ID INTEGER DEFAULT 0 NOT NULL,
   CAL_LOGIN VARCHAR(25) CHARACTER SET WIN1252 NOT NULL
);
CREATE INDEX IWEBCAL_VIEWUSERNEWINDEX ON WEBCAL_VIEW_USER(CAL_VIEW_ID, CAL_LOGIN);
CREATE TABLE WEBCAL_CONFIG
(
   CAL_SETTING VARCHAR(50) CHARACTER SET WIN1252 NOT NULL,
   CAL_VALUE VARCHAR(100) CHARACTER SET WIN1252
);
CREATE INDEX IWEBCAL_CONFIGNEWINDEX ON WEBCAL_CONFIG(CAL_SETTING);
CREATE TABLE WEBCAL_ENTRY_LOG
(
   CAL_LOG_ID INTEGER DEFAULT 0 NOT NULL,
   CAL_ENTRY_ID INTEGER DEFAULT 0 NOT NULL,
   CAL_LOGIN VARCHAR(25) CHARACTER SET WIN1252 NOT NULL,
   CAL_USER_CAL VARCHAR(25) CHARACTER SET WIN1252,
   CAL_TYPE VARCHAR(1) CHARACTER SET WIN1252 NOT NULL,
   CAL_DATE INTEGER,
   CAL_TIME INTEGER,
   CAL_TEXT VARCHAR(500) CHARACTER SET WIN1252
);
CREATE INDEX IWEBCAL_ENTRYLOGINDEX ON WEBCAL_ENTRY_LOG(CAL_LOG_ID);

/*UPGRADE_V0.9.37*/
CREATE TABLE WEBCAL_ENTRY_REPEATS_NOT
(
   CAL_ID INTEGER DEFAULT 0 NOT NULL,
   CAL_DATE INTEGER NOT NULL
);
CREATE INDEX IWEBCAL_ENTRY_REP_NOTNEWINDEX ON WEBCAL_ENTRY_REPEATS_NOT(CAL_ID, CAL_DATE);

/*UPGRADE_V0.9.38*/
ALTER TABLE WEBCAL_ENTRY_USER ADD CAL_CATEGORY INTEGER DEFAULT NULL;
CREATE TABLE WEBCAL_CATEGORIES
(
   CAT_ID INTEGER DEFAULT 0 NOT NULL,
   CAT_OWNER VARCHAR(25) CHARACTER SET WIN1252,
   CAT_NAME VARCHAR(80) CHARACTER SET WIN1252 NOT NULL
);
CREATE INDEX IWEBCAL_CATEGORIESINDEX ON WEBCAL_CATEGORIES(CAT_ID);

/*UPGRADE_V0.9.40*/
DELETE FROM WEBCAL_CONFIG WHERE CAL_SETTING LIKE 'DATE_FORMAT%';
DELETE FROM WEBCAL_USER_PREF WHERE CAL_SETTING LIKE 'DATE_FORMAT%';

CREATE TABLE WEBCAL_ASST
(
  CAL_BOSS VARCHAR(25) CHARACTER SET WIN1252 NOT NULL,
  CAL_ASSISTANT  VARCHAR(25) CHARACTER SET WIN1252 NOT NULL
);
CREATE INDEX IWEBCAL_BOSSINDEX ON WEBCAL_ASST(CAL_BOSS, CAL_ASSISTANT);
CREATE TABLE WEBCAL_ENTRY_EXT_USER
(
   CAL_ID INTEGER DEFAULT 0 NOT NULL,
   CAL_FULLNAME VARCHAR(50) CHARACTER SET WIN1252  NOT NULL,
   CAL_EMAIL VARCHAR(75) CHARACTER SET WIN1252
);
CREATE INDEX IWEBCAL_ENTRY_EXTUSERNEWINDEX ON WEBCAL_ENTRY_EXT_USER(CAL_ID, CAL_FULLNAME);
ALTER TABLE WEBCAL_ENTRY ADD CAL_EXT_FOR_ID INTEGER DEFAULT NULL;

/*UPGRADE_V0.9.41*/
CREATE TABLE WEBCAL_NONUSER_CALS
(
  CAL_LOGIN VARCHAR(25) CHARACTER SET WIN1252 NOT NULL,
  CAL_LASTNAME VARCHAR(25) CHARACTER SET WIN1252,
  CAL_FIRSTNAME VARCHAR(25) CHARACTER SET WIN1252,
  CAL_ADMIN VARCHAR(25) CHARACTER SET WIN1252 NOT NULL
);
CREATE INDEX IWEBCAL_NONUSERCALSINDEX ON WEBCAL_NONUSER_CALS(CAL_LOGIN);

/*UPGRADE_V0.9.42*/
CREATE TABLE WEBCAL_REPORT
(
  CAL_LOGIN VARCHAR(25) CHARACTER SET WIN1252 NOT NULL,
  CAL_REPORT_ID INTEGER DEFAULT 0 NOT NULL,
  CAL_IS_GLOBAL VARCHAR(1) CHARACTER SET WIN1252 DEFAULT 'N'  NOT NULL,
  CAL_REPORT_TYPE VARCHAR(20) CHARACTER SET WIN1252 NOT NULL,
  CAL_INCLUDE_HEADER VARCHAR(1) CHARACTER SET WIN1252 DEFAULT 'Y'  NOT NULL,
  CAL_REPORT_NAME VARCHAR(50) CHARACTER SET WIN1252 NOT NULL,
  CAL_TIME_RANGE INTEGER DEFAULT 0 NOT NULL,
  CAL_USER VARCHAR(25) CHARACTER SET WIN1252,
  CAL_ALLOW_NAV VARCHAR(1) CHARACTER SET WIN1252 DEFAULT 'Y' NOT NULL,
  CAL_CAT_ID INTEGER,
  CAL_INCLUDE_EMPTY VARCHAR(1) CHARACTER SET WIN1252 DEFAULT 'N' NOT NULL,
  CAL_SHOW_IN_TRAILER VARCHAR(1) CHARACTER SET WIN1252 DEFAULT 'N' NOT NULL,
  CAL_UPDATE_DATE INTEGER DEFAULT 0 NOT NULL
);
CREATE INDEX IWEBCAL_REPORTINDEX ON WEBCAL_REPORT(CAL_REPORT_ID);
CREATE TABLE WEBCAL_REPORT_TEMPLATE
(
  CAL_REPORT_ID INTEGER DEFAULT 0 NOT NULL,
  CAL_TEMPLATE_TYPE VARCHAR(1) CHARACTER SET WIN1252 NOT NULL,
  CAL_TEMPLATE_TEXT VARCHAR(1024) CHARACTER SET WIN1252 NOT NULL
);
CREATE INDEX IWEBCAL_REPORTTEMPLATEINDEX ON WEBCAL_REPORT_TEMPLATE(CAL_REPORT_ID, CAL_TEMPLATE_TYPE);

/*UPGRADE_V0.9.43*/
ALTER TABLE WEBCAL_USER ALTER CAL_PASSWD VARCHAR(32);
CREATE TABLE WEBCAL_IMPORT
(
  CAL_IMPORT_ID INTEGER DEFAULT 0 NOT NULL,
  CAL_NAME VARCHAR(50) CHARACTER SET WIN1252,
  CAL_DATE INTEGER DEFAULT 0 NOT NULL,
  CAL_TYPE VARCHAR(10) CHARACTER SET WIN1252 NOT NULL,
  CAL_LOGIN VARCHAR(25) CHARACTER SET WIN1252 NOT NULL
);
CREATE INDEX IWEBCAL_IMPORT2INDEX ON WEBCAL_IMPORT(CAL_IMPORT_ID);
CREATE TABLE WEBCAL_IMPORT_DATA
(
  CAL_IMPORT_ID INTEGER DEFAULT 0 NOT NULL,
  CAL_ID INTEGER DEFAULT 0 NOT NULL,
  CAL_LOGIN VARCHAR(25) CHARACTER SET WIN1252 NOT NULL,
  CAL_IMPORT_TYPE VARCHAR(15) CHARACTER SET WIN1252 NOT NULL,
  CAL_EXTERNAL_ID VARCHAR(200) CHARACTER SET WIN1252
);
CREATE INDEX IWEBCAL_IMPORTINDEX ON WEBCAL_IMPORT_DATA(CAL_LOGIN, CAL_ID);

/*UPGRADE_V1.0RC3*/
ALTER TABLE WEBCAL_VIEW ADD CAL_IS_GLOBAL CHAR(1) CHARACTER SET WIN1252 DEFAULT 'N' NOT NULL;
UPDATE WEBCAL_USER_PREF SET CAL_VALUE = 'DAY.PHP'
  WHERE CAL_VALUE = 'DAY' AND CAL_SETTING = 'STARTVIEW';
UPDATE WEBCAL_USER_PREF SET CAL_VALUE = 'WEEK.PHP'
  WHERE CAL_VALUE = 'WEEK' AND CAL_SETTING = 'STARTVIEW';
UPDATE WEBCAL_USER_PREF SET CAL_VALUE = 'MONTH.PHP'
  WHERE CAL_VALUE = 'MONTH' AND CAL_SETTING = 'STARTVIEW';
UPDATE WEBCAL_USER_PREF SET CAL_VALUE = 'YEAR.PHP'
  WHERE CAL_VALUE = 'YEAR' AND CAL_SETTING = 'STARTVIEW';
UPDATE WEBCAL_CONFIG SET CAL_VALUE = 'WEEK.PHP'
  WHERE CAL_SETTING = 'STARTVIEW';

/*upgrade_v1.1.0-CVS*/
CREATE TABLE WEBCAL_ACCESS_FUNCTION
(
  cal_login VARCHAR(25) CHARACTER SET WIN1252 NOT NULL,
  CAL_PERMISSIONS VARCHAR(64) CHARACTER SET WIN1252 NOT NULL
);
CREATE INDEX IWEBCAL_ACCESSFUNCTIONINDEX ON WEBCAL_ACCESS_FUNCTION(CAL_LOGIN);
CREATE TABLE WEBCAL_ACCESS_USER
 (
  cal_login VARCHAR(25) CHARACTER SET WIN1252 NOT NULL,
  cal_other_user VARCHAR(25) CHARACTER SET WIN1252 NOT NULL
);
ALTER TABLE WEBCAL_NONUSER_CALS ADD CAL_IS_PUBLIC CHAR(1) CHARACTER SET WIN1252 DEFAULT 'N' NOT NULL;

/*upgrade_v1.1.0a-CVS*/
CREATE TABLE WEBCAL_USER_TEMPLATE (
  CAL_LOGIN VARCHAR(25) CHARACTER SET WIN1252 NOT NULL,
  CAL_TYPE VARCHAR(1) CHARACTER SET WIN1252 NOT NULL,
  CAL_TEMPLATE_TEXT VARCHAR(1024) CHARACTER SET WIN1252 NOT NULL
);
CREATE INDEX IWEBCAL_USERTEMPLATE ON WEBCAL_USER_TEMPLATE(CAL_LOGIN,CAL_TYPE);

ALTER TABLE WEBCAL_ENTRY_REPEATS ADD CAL_ENDTIME INTEGER DEFAULT NULL;
ALTER TABLE WEBCAL_ENTRY_REPEATS ADD CAL_BYMONTH VARCHAR(50) CHARACTER SET WIN1252 DEFAULT NULL;
ALTER TABLE WEBCAL_ENTRY_REPEATS ADD CAL_BYMONTHDAY VARCHAR(100) CHARACTER SET WIN1252 DEFAULT NULL;
ALTER TABLE WEBCAL_ENTRY_REPEATS ADD CAL_BYDAY VARCHAR(100) CHARACTER SET WIN1252 DEFAULT NULL;
ALTER TABLE WEBCAL_ENTRY_REPEATS ADD CAL_BYSETPOS VARCHAR(50) CHARACTER SET WIN1252 DEFAULT NULL;
ALTER TABLE WEBCAL_ENTRY_REPEATS ADD CAL_BYWEEKNO VARCHAR(50) CHARACTER SET WIN1252 DEFAULT NULL;
ALTER TABLE WEBCAL_ENTRY_REPEATS ADD CAL_BYYEARDAY VARCHAR(50) CHARACTER SET WIN1252 DEFAULT NULL;
ALTER TABLE WEBCAL_ENTRY_REPEATS ADD CAL_WKST CHAR(2) CHARACTER SET WIN1252 DEFAULT 'MO';
ALTER TABLE WEBCAL_ENTRY_REPEATS ADD CAL_COUNT INTEGER DEFAULT NULL;
ALTER TABLE WEBCAL_ENTRY_REPEATS_NOT ADD CAL_EXDATE INTEGER DEFAULT '1' NOT NULL;
ALTER TABLE WEBCAL_ENTRY ADD CAL_DUE_DATE INTEGER DEFAULT NULL;
ALTER TABLE WEBCAL_ENTRY ADD CAL_DUE_TIME INTEGER DEFAULT NULL;
ALTER TABLE WEBCAL_ENTRY ADD CAL_LOCATION VARCHAR(100) CHARACTER SET WIN1252 DEFAULT NULL;
ALTER TABLE WEBCAL_ENTRY ADD CAL_URL VARCHAR(100) CHARACTER SET WIN1252 DEFAULT NULL;
ALTER TABLE WEBCAL_ENTRY ADD CAL_COMPLETED INTEGER DEFAULT NULL;
ALTER TABLE WEBCAL_ENTRY_USER ADD CAL_PERCENT INTEGER DEFAULT '0' NOT NULL;
DROP INDEX IWEBCAL_SITE_EXTRASNEWINDEX;

/*upgrade_v1.1.0b-CVS*/
CREATE TABLE WEBCAL_ENTRY_CATEGORIES (
  CAL_ID INTEGER DEFAULT '0' NOT NULL,
  CAT_ID INTEGER DEFAULT '0' NOT NULL,
  CAT_ORDER INTEGER DEFAULT '0' NOT NULL,
  CAT_OWNER VARCHAR(25) CHARACTER SET WIN1252 DEFAULT NULL
);

/*upgrade_v1.1.0c-CVS*/
CREATE TABLE WEBCAL_BLOB (
  CAL_BLOB_ID INTEGER NOT NULL,
  CAL_ID INTEGER DEFAULT NULL,
  CAL_LOGIN VARCHAR(25) CHARACTER SET WIN1252 DEFAULT NULL,
  CAL_NAME VARCHAR(30) CHARACTER SET WIN1252 DEFAULT NULL,
  CAL_DESCRIPTION VARCHAR(128) CHARACTER SET WIN1252 DEFAULT NULL,
  CAL_SIZE INTEGER DEFAULT NULL,
  CAL_MIME_TYPE VARCHAR(50) CHARACTER SET WIN1252 DEFAULT NULL,
  CAL_TYPE CHAR(1) CHARACTER SET WIN1252 NOT NULL,
  CAL_MOD_DATE INTEGER NOT NULL,
  CAL_MOD_TIME INTEGER NOT NULL,
  CAL_BLOB BLOB
);
CREATE INDEX IWEBCAL_BLOB ON WEBCAL_BLOB(CAL_BLOB_ID);

/*upgrade_v1.1.0d-CVS*/
DROP TABLE WEBCAL_ACCESS_USER;
CREATE TABLE WEBCAL_ACCESS_USER
 (
  cal_login VARCHAR(25) CHARACTER SET WIN1252 NOT NULL,
  cal_other_user VARCHAR(25) CHARACTER SET WIN1252 NOT NULL,
  CAL_CAN_VIEW INTEGER DEFAULT '0' NOT NULL,
  CAL_CAN_EDIT INTEGER DEFAULT '0' NOT NULL,
  CAL_CAN_APPROVE INTEGER DEFAULT '0' NOT NULL,
  CAL_CAN_INVITE CHAR(1) CHARACTER SET WIN1252 DEFAULT 'Y' NOT NULL,
  CAL_CAN_EMAIL CHAR(1) CHARACTER SET WIN1252 DEFAULT 'Y' NOT NULL,
  CAL_SEE_TIMES_ONLY CHAR(1) CHARACTER SET WIN1252 DEFAULT 'N' NOT NULL
);
CREATE INDEX IWEBCAL_ACCESSUSERINDEX ON WEBCAL_ACCESS_USER(CAL_LOGIN, CAL_OTHER_USER);

/*upgrade_v1.1.0e-CVS*/
CREATE TABLE WEBCAL_REMINDERS (
  CAL_ID INTEGER DEFAULT '0' NOT NULL,
  CAL_DATE INTEGER DEFAULT '0' NOT NULL,
  CAL_OFFSET INTEGER DEFAULT '0' NOT NULL,
  CAL_RELATED CHAR(1) CHARACTER SET WIN1252 DEFAULT 'S' NOT NULL,
  CAL_BEFORE CHAR(1) CHARACTER SET WIN1252 DEFAULT 'Y' NOT NULL,
  CAL_LAST_SENT INTEGER DEFAULT '0' NOT NULL,
  CAL_REPEATS INTEGER DEFAULT '0' NOT NULL,
  CAL_DURATION INTEGER DEFAULT '0' NOT NULL,
  CAL_TIMES_SENT INTEGER DEFAULT '0' NOT NULL,
  CAL_ACTION VARCHAR(12) CHARACTER SET WIN1252 DEFAULT 'EMAIL' NOT NULL
);
CREATE INDEX IWEBCAL_REMINDERSNEWINDEX ON WEBCAL_REMINDERS(CAL_ID);
/*upgrade_v1.1.1*/
ALTER TABLE webcal_nonuser_cals ADD cal_url VARCHAR(75) CHARACTER SET WIN1252 DEFAULT NULL;

/*upgrade_v1.1.2*/
ALTER TABLE webcal_categories ADD cat_color VARCHAR(8)  CHARACTER SET WIN1252 DEFAULT NULL;
ALTER TABLE webcal_user ADD cal_enabled CHAR(1)  CHARACTER SET WIN1252 DEFAULT 'Y';
ALTER TABLE webcal_user ADD cal_telephone VARCHAR(50)  CHARACTER SET WIN1252 DEFAULT NULL;
ALTER TABLE webcal_user ADD cal_address VARCHAR(75)  CHARACTER SET WIN1252 DEFAULT NULL;
ALTER TABLE webcal_user ADD cal_title VARCHAR(75)  CHARACTER SET WIN1252 DEFAULT NULL;
ALTER TABLE webcal_user ADD cal_birthday INT NULL;
ALTER TABLE webcal_user ADD cal_last_login INT NULL;

/*upgrade_v1.1.3*/
CREATE TABLE webcal_TIMEZONES (
  TZID VARCHAR(100) CHARACTER SET WIN1252 DEFAULT '' NOT NULL,
  DTSTART VARCHAR(25) CHARACTER SET WIN1252 DEFAULT NULL,
  DTEND VARCHAR(25) CHARACTER SET WIN1252 DEFAULT NULL,
  VTIMEZONE VARCHAR(500) CHARACTER SET WIN1252
);
CREATE INDEX IWEBCAL_TIMEZONESNEWINDEX ON WEBCAL_TIMEZONES(TZID);
/*upgrade_v1.3.0*/
CREATE INDEX IF NOT EXISTS
  webcal_entry_categories ON webcal_entry_categories(cat_id);
/*upgrade_v1.9.0*/
ALTER TABLE webcal_import ADD cal_check_date INT NULL;
ALTER TABLE webcal_import ADD cal_md5 VARCHAR(32) NULL DEFAULT NULL;
CREATE INDEX IF NOT EXISTS
  webcal_import_data_type ON webcal_import_data(cal_import_type);
CREATE INDEX IF NOT EXISTS
  webcal_import_data_ext_id ON webcal_import_data(cal_external_id);
ALTER TABLE webcal_user MODIFY cal_passwd VARCHAR(255);
/*upgrade_v1.9.5*/
