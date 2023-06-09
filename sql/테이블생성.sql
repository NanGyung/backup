--테이블 삭제
drop table C_BBSC CASCADE CONSTRAINTS;
drop table BBSC CASCADE CONSTRAINTS;
drop table C_BBSH CASCADE CONSTRAINTS;
drop table BBSH CASCADE CONSTRAINTS;
drop table PET_NOTE CASCADE CONSTRAINTS;
drop table PET_INFO CASCADE CONSTRAINTS;
drop table HOSPITAL_INFO CASCADE CONSTRAINTS;
drop table HOSPITAL_DATA CASCADE CONSTRAINTS;
drop table HMEMBER CASCADE CONSTRAINTS;
drop table MEMBER CASCADE CONSTRAINTS;
drop table CODE CASCADE CONSTRAINTS;
drop table UPLOADFILE CASCADE CONSTRAINTS;

--시퀀스삭제
drop sequence C_BBSC_CC_ID_SEQ;
drop sequence BBSC_BBSC_ID_seq;
drop sequence C_BBSH_HC_ID_SEQ;
drop sequence BBSH_BBSH_ID_seq;
drop sequence  PET_NOTE_NOTE_NUM_seq;
drop sequence PET_INFO_PET_NUM_seq;
drop sequence HOSPITAL_INFO_H_NUM_seq;
drop sequence UPLOADFILE_UPLOADFILE_ID_SEQ; 



-------
--코드
-------
create table code(
    code_id     varchar2(10),       --코드
    decode      varchar2(30),       --코드명
    discript    clob,               --코드설명
    pcode_id    varchar2(10),       --상위코드
    useyn       char(1) default 'Y',            --사용여부 (사용:'Y',미사용:'N')
    cdate       timestamp default systimestamp,         --생성일시
    udate       timestamp default systimestamp          --수정일시
);
--기본키
alter table code add Constraint code_code_id_pk primary key (code_id);

--제약조건
alter table code modify decode constraint code_decode_nn not null;
alter table code modify useyn constraint code_useyn_nn not null;
alter table code add constraint code_useyn_ck check(useyn in ('Y','N'));

--샘플데이터 of code
insert into code (code_id,decode,pcode_id,useyn) values ('M01','회원구분',null,'Y');
insert into code (code_id,decode,pcode_id,useyn) values ('M0101','일반','M01','Y');
insert into code (code_id,decode,pcode_id,useyn) values ('H0101','병원','M01','Y');
insert into code (code_id,decode,pcode_id,useyn) values ('M01A1','관리자','M01','Y');
insert into code (code_id,decode,pcode_id,useyn) values ('P01','기초접종',null,'Y');
insert into code (code_id,decode,pcode_id,useyn) values ('P0101','미접종','P01','Y');
insert into code (code_id,decode,pcode_id,useyn) values ('P0102','접종 전','P01','Y');
insert into code (code_id,decode,pcode_id,useyn) values ('P0103','접종 중','P01','Y');
insert into code (code_id,decode,pcode_id,useyn) values ('P0104','접종 완료','P01','Y');
insert into code (code_id,decode,pcode_id,useyn) values ('B01','게시판',null,'Y');
insert into code (code_id,decode,pcode_id,useyn) values ('B0101','병원후기','B01','Y');
insert into code (code_id,decode,pcode_id,useyn) values ('B0102','커뮤니티','B01','Y');
insert into code (code_id,decode,pcode_id,useyn) values ('F01','첨부파일',null,'Y');
insert into code (code_id,decode,pcode_id,useyn) values ('F0101','커뮤니티','F01','Y');
insert into code (code_id,decode,pcode_id,useyn) values ('F0102','병원후기','F01','Y');
insert into code (code_id,decode,pcode_id,useyn) values ('F0103','회원프로필','F01','Y');

commit;

------------
--업로드 파일
------------
CREATE TABLE UPLOADFILE(
  UPLOADFILE_ID             NUMBER,          --파일 아이디(내부관리용)
  CODE                      varchar2(11),    --분류 코드(커뮤니티: F0101, 병원후기: F0102, 회원프로필: F0103)
  RID                       varchar2(10),    --참조번호 --해당 첨부파일이 첨부된 게시글의 순번
  STORE_FILENAME            varchar2(50),    --보관파일명
  UPLOAD_FILENAME           varchar2(50),    --업로드파일명
  FSIZE                     varchar2(45),    --파일크기 
  FTYPE                     varchar2(50),    --파일유형
  CDATE                     timestamp default systimestamp, --작성일
  UDATE                     timestamp default systimestamp  --수정일
);
--기본키생성
alter table UPLOADFILE add Constraint UPLOADFILE_UPLOADFILE_ID_pk primary key (UPLOADFILE_ID);
--외래키
alter table UPLOADFILE add constraint  UPLOADFILE_CODE_fk
    foreign key(CODE) references CODE(CODE_ID);

--제약조건
alter table UPLOADFILE modify CODE constraint UPLOADFILE_CODE_nn not null;
alter table UPLOADFILE modify RID constraint UPLOADFILE_RID_nn not null;
alter table UPLOADFILE modify STORE_FILENAME constraint UPLOADFILE_STORE_FILENAME_nn not null;
alter table UPLOADFILE modify UPLOAD_FILENAME constraint UPLOADFILE_UPLOAD_FILENAME_nn not null;
-- not null 제약조건은 add 대신 modify 명령문 사용

--시퀀스 생성
create sequence UPLOADFILE_UPLOADFILE_ID_SEQ;

--샘플데이터 of UPLOADFILE
insert into UPLOADFILE (UPLOADFILE_ID, CODE , RID, STORE_FILENAME, UPLOAD_FILENAME, FSIZE,FTYPE)
 values(UPLOADFILE_UPLOADFILE_ID_SEQ.NEXTVAL, 'F0101', '001', 'F0101.png', '커뮤니티이미지첨부1.png','100','image/png');

COMMIT;

--테이블 구조 확인
DESC UPLOADFILE;

-------
--회원
-------
create table member (
    USER_ID                varchar2(20),   --로긴 아이디
    USER_PW                varchar2(20),   --로긴 비밀번호
    USER_NICK              varchar2(30),   --별칭
    USER_EMAIL             varchar2(40),  --이메일
    GUBUN                  varchar2(10) default 'M0101',    --회원구분(병원,일반) 일반회원 관리코드 M0101, 병원회원 관리코드 H0101
    USER_PHOTO             BLOB,           --사진
    USER_CREATE_DATE       timestamp default systimestamp,         --생성일시
    USER_UPDATE            timestamp default systimestamp          --수정일시
);
--기본키생성
alter table member add Constraint member_user_id_pk primary key (user_id);
--외래키
alter table member add constraint member_gubun_fk
    foreign key(gubun) references code(code_id);

--제약조건
alter table member add constraint member_user_email_uk unique (user_email);
alter table member modify user_pw constraint member_user_pw_nn not null;
alter table member modify user_nick constraint member_user_nick_nn not null;
alter table member modify user_email constraint member_user_email_nn not null;
-- not null 제약조건은 add 대신 modify 명령문 사용

desc member;

--샘플데이터 of MEMBER
insert into member (USER_ID , USER_PW, USER_NICK, USER_EMAIL, GUBUN)
    values('test1', 'test1234', '별칭1', 'test1@gamil.com', 'M0101');

commit;

-------
--병원회원
-------
create table hmember (
    H_ID                   varchar2(20),   --로긴 아이디
    H_PW                   varchar2(20),   --로긴 비밀번호
    H_NAME                 varchar2(52),   --병원 상호명
    H_EMAIL                varchar2(40),   --이메일
    H_TEL                  varchar2(30),   --병원 연락처
    H_TIME                 clob,           --진료시간
    H_INFO                 varchar2(60),   --편의시설정보
    H_ADDINFO              varchar2(60),   --병원기타정보
    H_PLIST                varchar2(40),   --진료동물
    GUBUN                  varchar2(10) default 'H0101',    --회원구분(병원,일반) 일반회원 관리코드 M0101, 병원회원 관리코드 H0101
    H_CREATE_DATE       timestamp default systimestamp,         --생성일시
    H_UPDATE            timestamp default systimestamp          --수정일시
);
--기본키생성
alter table hmember add Constraint hmember_h_id_pk primary key (h_id);
--외래키
alter table hmember add constraint hmember_gubun_fk
    foreign key(gubun) references code(code_id);

--제약조건
alter table hmember add Constraint hmember_h_email unique (h_email);
alter table hmember modify h_pw constraint hmember_h_pw_nn not null;
alter table hmember modify h_email constraint hmember_h_email_nn not null;
alter table hmember modify h_name constraint hmember_h_name_nn not null;

--샘플 데이터 OF HMEMBER
insert into HMEMBER (H_ID , H_PW, H_NAME, H_EMAIL, H_TEL, H_TIME, H_INFO, H_ADDINFO, H_PLIST, GUBUN)
    values(
    'htest1',
    'htest1234',
    '메이 동물병원',
    'htest1@gamil.com',
    '211-3375',
    '월요일	오전 9:30~오후 7:00
    화요일	오전 9:30~오후 7:00
    수요일
    (식목일)
    오전 9:30~오후 7:00
    시간이 달라질 수 있음
    목요일	오전 9:30~오후 7:00
    금요일	오전 9:30~오후 7:00
    토요일	오전 9:30~오후 4:00
    일요일	휴무일',
    '주차, 무선 인터넷, 반려동물 동반',
    '강아지, 고양이 전문 병원입니다!',
    '강아지, 고양이',
    'H0101');

--테이블 구조 확인
desc hmember;
commit;

-------------------
-- 동물병원 공공데이터
-------------------
CREATE TABLE hospital_data(
   hd_id              NUMBER(4)                         --동물병원 데이터번호
  ,hd_code            NUMBER(7)                         --개방자치단체코드
  ,hd_manage          VARCHAR2(13)                      --관리번호
  ,hd_perdate         DATE                              --인허가일자
  ,hd_statuscode      NUMBER(1)                         --영업상태구분코드
  ,hd_satusname       VARCHAR2(23)                      --영업상태명
  ,hd_detailcode      NUMBER(4)                         --상세영업상태코드
  ,hd_detailname      VARCHAR2(13)                       --상세영업상태명
  ,hd_tel             VARCHAR2(30)                      --소재지전화
  ,hd_address_general VARCHAR2(200)                      --지번주소
  ,hd_address_road    VARCHAR2(200)                     --도로명주소
  ,hd_address_roadnum NUMBER(7)                         --도로명우편번호
  ,hd_name            VARCHAR2(52)                      --사업장명
  ,hd_adit_date       VARCHAR2(22)                      --최종수정시점
  ,hd_adit_gubun      CHAR(1) DEFAULT 'I'               --데이터갱신구분(갱신됨: U, 갱신안됨: I)
  ,hd_adit_resdate    VARCHAR2(22)                      --데이터갱신일자
  ,hd_lng             NUMBER                            --좌표(x)
  ,hd_lat             NUMBER                            --좌표(y)
);
--기본키생성
alter table hospital_data add Constraint hospital_data_hd_id_pk primary key (hd_id);
--제약조건
alter table hospital_data modify hd_code constraint hospital_data_hd_code_nn not null;
alter table hospital_data modify hd_manage constraint hospital_data_hd_manage_nn not null;
alter table hospital_data modify hd_perdate constraint hospital_data_hd_perdate_nn not null;
alter table hospital_data modify hd_statuscode constraint hospital_data_hd_statuscode_nn not null;
alter table hospital_data modify hd_satusname constraint hospital_data_hd_satusname_nn not null;
alter table hospital_data modify hd_detailcode constraint hospital_data_hd_detailcode_nn not null;
alter table hospital_data modify hd_detailname constraint hospital_data_hd_detailname_nn not null;
alter table hospital_data modify hd_name constraint hospital_data_hd_name_nn not null;
alter table hospital_data modify hd_adit_date constraint hospital_data_hd_adit_date_nn not null;
alter table hospital_data modify hd_adit_gubun constraint hospital_data_hd_adit_gubun_nn not null;
alter table hospital_data modify hd_adit_resdate constraint hospital_data_hd_adit_resdate_nn not null;
alter table hospital_data modify hd_lng constraint hospital_data_hd_lng_nn not null;
alter table hospital_data modify hd_lat constraint hospital_data_hd_lat_nn not null;

alter table hospital_data add constraint hospital_data_hd_adit_gubun_ck check(hd_adit_gubun in ('U','I'));

--샘플데이터 of HOSPITAL_DATA : 동물병원데이터(울산, 부산).sql 파일을 열어서 insert 해야함
-- 병원공공데이터 샘플 
--행 1
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (4558,3370000,'3.37E+17',to_date('2018-12-31', 'YYYY-MM-DD'),2,'휴업',1,'휴업','051-862-1188','부산광역시 연제구 거제동 574-21번지','부산광역시 연제구 거제시장로 18-6 (거제동)',47544,'솔로몬동물병원','2020-03-04 16:58','U','2020-03-06 2:40',388659.1921,188856.4934);
--행 2
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (4879,3730000,'3.73E+17',to_date('2018-11-05', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','울산광역시 울주군 삼동면 하잠리 818번지','울산광역시 울주군 삼동면 삼동로 751, 2층',44956,'삼동종합가축병원약품','2020-04-21 16:15','U','2020-04-23 2:40',395577.8315,226753.4671);
--행 3
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (5400,3690000,'3.69E+17',to_date('2019-03-05', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','211-3375','울산광역시 중구 남외동 214-1번지','울산광역시 중구 번영로 581 (남외동)',44493,'메이 동물병원','2019-03-05 19:37','I','2019-03-07 2:21',412557.1053,232481.4145);
--행 4
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (5407,3330000,'3.33E+17',to_date('2019-04-16', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-715-2228','부산광역시 해운대구 우동 1124-26번지 해운대센텀메디칼센터','부산광역시 해운대구 해운대로 369, 해운대센텀메디칼센터 (우동)',48062,'벡스코 동물병원','2019-04-16 7:36','I','2019-04-18 2:20',394690.1278,187760.6973);
--행 5
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (5415,3300000,'3.30E+17',to_date('2019-04-08', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-529-2991','부산광역시 동래구 안락동 299-3번지','부산광역시 동래구 충렬대로 435 (안락동)',47791,'대일종합동물병원','2019-05-07 14:04','U','2019-05-09 2:40',391745.0539,190618.1055);
--행 6
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (5434,3310000,'3.31E+17',to_date('2019-05-20', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-626-5050','부산광역시 남구 용호동 164번지','부산광역시 남구 용호로 68, 2층 (용호동)',48523,'W동물의료센터','2019-07-10 10:09','U','2019-07-12 2:40',392358.2446,182741.2944);
--행 7
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (5462,3380000,'3.38E+17',to_date('2019-04-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-756-0075','부산광역시 수영구 광안동 174-5번지','부산광역시 수영구 광남로 125, 1층 (광안동)',48299,'바다동물병원','2019-04-02 14:26','I','2019-04-04 2:20',392768.419,185787.102);
--행 8
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6040,3320000,'3.32E+17',to_date('2019-05-15', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','513619975','부산광역시 북구 화명동 2275-2번지 대성빌딩','부산광역시 북구 화명대로 20, 대성빌딩 101호 (화명동)',46527,'토브동물병원','2019-05-15 9:13','I','2019-05-17 2:20',382914.8557,194677.2367);
--행 9
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6046,3330000,'3.33E+17',to_date('2019-06-07', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-702-5575','부산광역시 해운대구 좌동 1295-4번지 메이드프롬','부산광역시 해운대구 대천로 114, 1층 (좌동)',48079,'아이앤지동물병원','2019-06-07 11:11','I','2019-06-09 2:21',398045.8303,188344.0893);
--행 10
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6066,3370000,'3.37E+17',to_date('2019-08-22', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-862-8275','부산광역시 연제구 연산동 1123-22번지','부산광역시 연제구 중앙대로 1133, 1층 (연산동)',47523,'엘동물의료센터','2019-09-06 14:10','U','2019-09-08 2:40',389442.3042,189713.7665);
--행 11
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6076,3290000,'3.29E+17',to_date('2019-09-18', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-851-6612,3','부산광역시 부산진구 양정동 401-11번지','부산광역시 부산진구 거제대로 20 (양정동)',47214,'롯데동물메디컬센터','2020-05-20 9:51','U','2020-05-22 2:40',388296.7178,187645.5045);
--행 12
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6082,3380000,'3.38E+17',to_date('2019-09-11', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-752-6667','부산광역시 수영구 광안동 118-7번지 호암','부산광역시 수영구 수영로 610, 호암 2층 (광안동)',48293,'메이동물의료센터','2019-09-19 10:40','U','2019-09-21 2:40',392541.7262,186591.8417);
--행 13
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6109,3300000,'3.30E+17',to_date('2022-04-14', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-552-5553','부산광역시 동래구 온천동 1434-10','부산광역시 동래구 충렬대로125번길 6(온천동)',47733,'리브동물의료센터','2023-03-30 16:18','U','2023-04-01 2:40',388853.6162,191635.4637);
--행 14
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6122,3290000,'3.29E+17',to_date('2012-04-27', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-896-7582','부산광역시 부산진구 가야동 699 가야센트레빌아파트','부산광역시 부산진구 가야공원로 6, B112호 (가야동, 가야센트레빌아파트)',47325,'펫케어 동물병원','2020-10-20 14:43','U','2020-10-22 2:40',384824.6942,185631.7716);
--행 15
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6123,3290000,'3.29E+17',to_date('2013-02-08', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-894-5433','부산광역시 부산진구 부전동 505-6 한솔폴라리스','부산광역시 부산진구 가야대로 754 (부전동, 한솔폴라리스)',47284,'미소동물병원','2020-10-14 17:59','U','2020-10-16 2:40',387076.9832,186148.6292);
--행 16
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6124,3290000,'3.29E+17',to_date('2014-04-25', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 부산진구 부전동 515-1번지','부산광역시 부산진구 부전로66번길 12, 2층 (부전동)',47287,'정훈동물병원','2014-07-04 8:57','I','2018-08-31 23:59',387215.3723,186001.5458);
--행 17
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6125,3290000,'3.29E+17',to_date('2014-12-11', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-819-7588','부산광역시 부산진구 전포동 362-3','부산광역시 부산진구 전포대로 170, B1층 104호 (전포동)',47306,'스타동물병원','2021-04-01 18:09','U','2021-04-03 2:40',388183.0795,185582.6974);
--행 18
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6126,3290000,'3.29E+17',to_date('2001-07-11', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','518174749','부산광역시 부산진구 전포동 181-1번지 서면대우디오빌2 104호','부산광역시 부산진구 전포대로 274 (전포동, 서면대우디오빌2)',47237,'그린동물병원','2019-03-06 14:02','U','2019-03-08 2:40',388153.839,186593.5047);
--행 19
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6127,3290000,'3.29E+17',to_date('2002-03-28', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','818-0251','부산광역시 부산진구 범천동 1298-114번지','부산광역시 부산진구 망양로 973 (범천동)',47369,'도담동물병원','2019-03-06 13:58','U','2019-03-08 2:40',387270.4939,184486.5043);
--행 20
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6128,3290000,'3.29E+17',to_date('2003-09-03', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','894-7559','부산광역시 부산진구 개금동 186-22번지','부산광역시 부산진구 가야대로 491 (개금동)',47269,'가야종합동물병원','2016-12-06 10:28','I','2018-08-31 23:59',384527.589,185689.6138);
--행 21
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6129,3290000,'3.29E+17',to_date('2016-09-09', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 부산진구 가야동 378-17','부산광역시 부산진구 대학로 1, 1,2층 (가야동)',47331,'양·한방 전문 힘찬동물병원','2023-02-06 14:12','U','2023-02-08 2:40',385657.4298,185846.0441);
--행 22
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6130,3290000,'3.29E+17',to_date('2016-11-29', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-891-8575','부산광역시 부산진구 개금동 198-1 개금블루스카이','부산광역시 부산진구 개금온정로 6 (개금동, 개금블루스카이)',47269,'닥터펫 동물의료센터','2023-03-16 16:46','U','2023-03-18 2:40',384503.5585,185719.3757);
--행 23
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6131,3290000,'3.29E+17',to_date('2018-03-05', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','518637570','부산광역시 부산진구 양정동 402-15번지','부산광역시 부산진구 거제대로 14, 2층 (양정동)',47214,'이브동물병원','2019-05-27 9:47','U','2019-05-29 2:40',388307.837,187571.0743);
--행 24
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6132,3290000,'3.29E+17',to_date('1991-03-20', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','817-4627','부산광역시 부산진구 양정동 519-16','부산광역시 부산진구 중앙대로 867 (양정동)',47215,'부산종합동물병원','2022-03-11 18:33','U','2022-03-13 2:40',388229.658,187441.3568);
--행 25
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6133,3290000,'3.29E+17',to_date('1991-09-30', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','897-7271','부산광역시 부산진구 당감동 430-2번지','부산광역시 부산진구 당감로 31-1 (당감동)',NULL,'당감동물병원','2006-05-04 15:53','I','2018-08-31 23:59',385723.1951,186942.4211);
--행 26
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6134,3290000,'3.29E+17',to_date('1992-08-07', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','865-1782','부산광역시 부산진구 부암동 343-86번지','부산광역시 부산진구 동평로 115-1, 1층 (부암동)',47138,'우진동물병원','2019-03-06 16:41','U','2019-03-08 2:40',385983.0378,187138.7365);
--행 27
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6135,3290000,'3.29E+17',to_date('1994-10-05', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','809-8008','부산광역시 부산진구 연지동 198-1번지 연지로얄아파트','부산광역시 부산진구 국악로 5 (연지동, 연지로얄아파트)',47134,'부일동물병원','2019-03-06 14:15','U','2019-03-08 2:40',386989.5608,187695.293);
--행 28
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6136,3290000,'3.29E+17',to_date('1997-08-27', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','896-0075','부산광역시 부산진구 부암동 346-15번지','부산광역시 부산진구 동평로 107 (부암동)',47144,'화승종합동물병원','2013-12-27 18:59','I','2018-08-31 23:59',385895.1157,187115.0068);
--행 29
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6137,3290000,'3.29E+17',to_date('1998-03-26', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-802-6637','부산광역시 부산진구 전포동 584번지 43통6반 신개금엘지아파트 212동 1702호','부산광역시 부산진구 전포대로298번길 1 (전포동)',47236,'새부산종합동물병원','2015-08-03 9:43','I','2018-08-31 23:59',388131.519,186868.0294);
--행 30
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6138,3290000,'3.29E+17',to_date('2000-02-12', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','808-0251','부산광역시 부산진구 연지동 375-15번지','부산광역시 부산진구 새싹로 155 (연지동)',47109,'애경동물병원','2019-03-06 16:35','U','2019-03-08 2:40',386687.952,187580.1977);
--행 31
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6139,3290000,'3.29E+17',to_date('2007-03-29', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-809-8092','부산광역시 부산진구 부전동 466-19번지','부산광역시 부산진구 부전로 87 (부전동)',NULL,'서면동물병원','2014-05-27 9:42','I','2018-08-31 23:59',387137.7888,186246.3335);
--행 32
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6140,3290000,'3.29E+17',to_date('2008-01-04', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-891-7597','부산광역시 부산진구 당감동 351번지','부산광역시 부산진구 동평로 54 (당감동)',47177,'위드동물병원','2017-06-14 10:44','I','2018-08-31 23:59',385375.7191,186974.105);
--행 33
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6141,3290000,'3.29E+17',to_date('2008-03-28', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 부산진구 당감동 738-3번지 아시아드빌딩상가','부산광역시 부산진구 당감서로 84, 아시아드빌딩상가 (당감동)',47142,'리치동물병원','2019-03-06 13:54','U','2019-03-08 2:40',385544.1799,187289.0732);
--행 34
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6142,3290000,'3.29E+17',to_date('2008-06-13', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-805-0975','부산광역시 부산진구 초읍동 273-7번지','부산광역시 부산진구 새싹로 243-4 (초읍동)',47104,'초읍동물병원','2019-03-07 10:22','U','2019-03-09 2:40',386485.2482,188439.7318);
--행 35
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6143,3290000,'3.29E+17',to_date('2011-04-07', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 부산진구 개금동 540-91번지','부산광역시 부산진구 복지로 47 (개금동)',NULL,'신개금동물병원','2011-04-07 9:36','I','2018-08-31 23:59',384075.6551,185190.6407);
--행 36
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6144,3290000,'3.29E+17',to_date('2011-08-24', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','518037511','부산광역시 부산진구 부암동 93번지 이마트트레이더스서면점','부산광역시 부산진구 시민공원로 31, 이마트트레이더스서면점 (부암동)',47192,'웰니스크리닉','2019-03-06 16:49','U','2019-03-08 2:40',386948.9542,186897.0537);
--행 37
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6407,3700000,'3.70E+17',to_date('2019-11-26', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','529251125','울산광역시 남구 무거동 584-17번지','울산광역시 남구 대학로 27 (무거동)',44616,'이루아동물병원','2019-11-26 15:54','I','2019-11-28 0:23',404499.6276,228871.0183);
--행 38
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6419,3380000,'3.38E+17',to_date('2019-12-03', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-746-7582','부산광역시 수영구 수영동 450-11','부산광역시 수영구 연수로 407-1, 2-3층 (수영동)',48232,'센텀동물메디컬센터 수영점','2023-01-09 19:26','U','2023-01-11 2:40',392529.9299,187518.1056);
--행 39
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6443,3330000,'3.33E+17',to_date('2022-03-29', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-744-7500','부산광역시 해운대구 우동 1459 퍼스트인센텀','부산광역시 해운대구 센텀중앙로 60, 106호 (우동)',48059,'신비한 동물병원 인센텀','2022-04-04 9:14','U','2022-04-06 2:40',393868.6946,188144.7219);
--행 40
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6449,3290000,'3.29E+17',to_date('2022-02-14', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-714-0011','부산광역시 부산진구 양정동 511-2','부산광역시 부산진구 동평로 356, 1층 (양정동)',47207,'올케어 동물의료센터','2022-02-15 13:22','I','2022-02-17 0:22',387967.6819,188102.7142);
--행 41
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6477,3340000,'3.34E+17',to_date('1995-06-14', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','292-3690','부산광역시 사하구 괴정동 472-51번지','부산광역시 사하구 사하로142번길 10 (괴정동)',49360,'염동물병원','2017-05-16 9:58','I','2018-08-31 23:59',381739.9946,179100.1466);
--행 42
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6478,3360000,'3.36E+17',to_date('2004-03-04', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-901-7434','부산광역시 강서구 범방동 1833','부산광역시 강서구 가락대로 929 (범방동)',46745,'KRA 부산동물병원','2023-02-28 12:39','U','2023-03-04 2:40',371094.2857,185672.9879);
--행 43
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6479,3360000,'3.36E+17',to_date('2012-08-13', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051)271-8889','부산광역시 강서구 명지동 3239번지 명지오션타워 204','부산광역시 강서구 명지오션시티11로 74 (명지동,명지오션타워 204)',NULL,'명지종합동물병원','2012-08-13 11:51','I','2018-08-31 23:59',373576.0288,177767.8604);
--행 44
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6480,3360000,'3.36E+17',to_date('2013-06-04', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-271-7582','부산광역시 강서구 명지동 3238','부산광역시 강서구 명지오션시티11로 66 (명지동)',46765,'명지오션시티동물병원','2020-09-14 14:10','U','2020-09-16 2:40',373495.7945,177766.2244);
--행 45
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6481,3360000,'3.36E+17',to_date('2013-10-30', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','519017384','부산광역시 강서구 범방동 1833','부산광역시 강서구 가락대로 929 (범방동)',46745,'스마일동물병원','2023-01-05 17:41','U','2023-01-07 2:40',371094.2857,185672.9879);
--행 46
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6482,3360000,'3.36E+17',to_date('2016-02-01', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-271-8119','부산광역시 강서구 명지동 3239-5','부산광역시 강서구 명지오션시티4로 69 (명지동)',46764,'해옴동물병원','2020-09-14 14:21','U','2020-09-16 2:40',373568.7516,177628.0327);
--행 47
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6483,3360000,'3.36E+17',to_date('2016-04-15', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','512914545','부산광역시 강서구 명지동 3442-4','부산광역시 강서구 명지국제6로 234 (명지동)',46726,'네오메디컬동물병원','2020-09-14 14:24','U','2020-09-16 2:40',375286.3802,179175.9659);
--행 48
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6484,3360000,'3.36E+17',to_date('2016-12-16', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-204-7588','부산광역시 강서구 명지동 3357-6','부산광역시 강서구 명지국제8로 243 (명지동)',46726,'국제동물병원','2020-09-14 14:26','U','2020-09-16 2:40',374957.7283,179392.3781);
--행 49
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6485,3360000,'3.36E+17',to_date('2017-09-25', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','519167575','부산광역시 강서구 명지동 3331-7번지','부산광역시 강서구 명지국제11로 35, 103동 105호 (명지동)',46726,'이로운동물병원','2019-03-06 13:47','U','2019-03-08 2:40',375206.5906,180094.1179);
--행 50
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6486,3360000,'3.36E+17',to_date('2018-03-14', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-901-7482','부산광역시 강서구 범방동 1833번지 부산경남경마공원','부산광역시 강서구 가락대로 929, 부산경남경마공원 (범방동)',46745,'마리동물병원','2020-05-26 14:17','U','2020-05-28 2:40',371094.2857,185672.9879);
--행 51
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6487,3340000,'3.34E+17',to_date('2004-09-23', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','291-4456','부산광역시 사하구 하단동 608-1번지','부산광역시 사하구 하신중앙로 296 (하단동)',49414,'하단동물병원','2017-05-16 10:00','I','2018-08-31 23:59',378926.782,180039.9103);
--행 52
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6488,3340000,'3.34E+17',to_date('2005-03-08', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','264-8275','부산광역시 사하구 하단동 617-10번지','부산광역시 사하구 하신중앙로 340, 1층 (하단동)',49407,'하단오거리 동물의료센터','2020-02-28 17:39','U','2020-03-01 2:40',379316.7171,180252.5913);
--행 53
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6489,3340000,'3.34E+17',to_date('2006-06-20', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','201-0475','부산광역시 사하구 괴정동 262-1번지','부산광역시 사하구 낙동대로 184 (괴정동)',49338,'한솔동물병원','2013-12-20 13:23','I','2018-08-31 23:59',381944.4684,179879.7156);
--행 54
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6490,3340000,'3.34E+17',to_date('2006-07-21', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','261-1891','부산광역시 사하구 다대동 1551-39번지','부산광역시 사하구 다대로 624 (다대동)',49503,'스마트동물병원','2018-05-28 17:20','I','2018-08-31 23:59',379691.4175,174201.2482);
--행 55
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6491,3340000,'3.34E+17',to_date('2007-02-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','266-7582','부산광역시 사하구 다대동 909번지','부산광역시 사하구 다대로 549 (다대동)',49524,'다대동물병원','2017-05-16 10:03','I','2018-08-31 23:59',379768.0509,174910.8576);
--행 56
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6492,3340000,'3.34E+17',to_date('2008-04-07', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','207-3344','부산광역시 사하구 괴정동 896-17','부산광역시 사하구 낙동대로 246-1, 1층 (괴정동)',49341,'괴정동물병원','2022-08-08 10:57','U','2022-08-10 2:40',381387.2669,179633.5942);
--행 57
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6493,3400000,'3.40E+17',to_date('2014-10-31', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-728-0557','부산광역시 기장군 정관면 용수리 1312-5번지','부산광역시 기장군 정관면 용수로 21',46014,'지 동물병원','2014-10-31 8:47','I','2018-08-31 23:59',398018.5917,205092.901);
--행 58
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6494,3400000,'3.40E+17',to_date('2015-09-01', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','727-7522','부산광역시 기장군 정관읍 매학리 717-3번지','부산광역시 기장군 정관읍 정관로 583',46015,'아산동물의료센터','2019-01-30 20:18','U','2019-02-01 2:40',397967.1708,204592.4916);
--행 59
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6495,3400000,'3.40E+17',to_date('2016-05-30', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-923-0119','부산광역시 기장군 정관읍 매학리 713-6번지 202호','부산광역시 기장군 정관읍 정관로 575-3, 2층 202호 (정관제일타워Ⅱ)',46015,'정관착한동물병원','2016-05-30 10:53','I','2018-08-31 23:59',397873.6817,204631.5309);
--행 60
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6496,3400000,'3.40E+17',to_date('2016-08-22', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-624-8275','부산광역시 기장군 기장읍 동부리 124번지','부산광역시 기장군 기장읍 차성로 314',46061,'디알씨동물병원','2016-08-22 16:06','I','2018-08-31 23:59',401451.7659,196278.1034);
--행 61
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6497,3340000,'3.34E+17',to_date('2008-10-16', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','209-2091','부산광역시 사하구 하단동 1207-1','부산광역시 사하구 낙동남로 1240 (하단동)',49435,'부산야생동물치료센터','2022-04-25 17:34','U','2022-04-27 2:40',377006.9204,180185.0867);
--행 62
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6498,3250000,'3.25E+17',to_date('1996-06-20', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','246-0473','부산광역시 중구 남포동5가 51-7번지','부산광역시 중구 자갈치로47번길 5 (남포동5가)',48983,'고동물병원','2019-12-03 11:33','U','2019-12-05 2:40',384955.1257,179511.633);
--행 63
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6499,3250000,'3.25E+17',to_date('1998-01-09', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','241-0103','부산광역시 중구 남포동5가 60-0001번지 2층','부산광역시 중구 구덕로 51, 2층 (남포동5가)',48983,'희망종합동물병원','2019-03-04 15:11','U','2019-03-06 2:40',385046.215,179539.724);
--행 64
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6500,3250000,'3.25E+17',to_date('1999-11-01', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','246-7551','부산광역시 중구 남포동2가 36-0007번지 외 1필지(남포동4가 1-2번지)','부산광역시 중구 구덕로 30-1 (남포동2가)',48954,'피닉스동물병원','2019-03-04 16:13','U','2019-03-06 2:40',385264.539,179559.2188);
--행 65
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6501,3260000,'3.26E+17',to_date('2001-11-16', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-254-2304','부산광역시 서구 서대신동3가 490-1번지','부산광역시 서구 망양로 19-1 (서대신동3가)',49210,'대신동물병원','2019-03-06 18:47','U','2019-03-08 2:40',383451.6379,181120.9181);
--행 66
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6502,3260000,'3.26E+17',to_date('2005-12-08', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','244-5504','부산광역시 서구 동대신동2가 368-1번지','부산광역시 서구 구덕로 308 (동대신동2가)',49217,'길경진동물병원','2019-04-12 11:08','U','2019-04-14 2:40',383853.3386,181003.4035);
--행 67
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6503,3260000,'3.26E+17',to_date('2015-01-12', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','512547744','부산광역시 서구 토성동1가 8-25','부산광역시 서구 까치고개로 257, 1층 (토성동1가)',49224,'만박동물병원','2021-07-02 9:41','U','2021-07-04 2:40',384481.3637,179718.936);
--행 68
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6504,3260000,'3.26E+17',to_date('2018-02-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 서구 서대신동1가 141-1','부산광역시 서구 대영로 36 (서대신동1가)',49228,'가온동물병원','2022-09-22 10:13','U','2022-09-24 2:40',383666.9072,180751.3685);
--행 69
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6505,3260000,'3.26E+17',to_date('1958-06-01', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 서구 토성동1가 8-43번지 3통4반','부산광역시 서구 까치고개로 253-2 (토성동1가)',49224,'중앙동물병원','2012-02-07 9:13','I','2018-08-31 23:59',384448.8228,179719.3551);
--행 70
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6506,3260000,'3.26E+17',to_date('1989-06-30', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-256-1188','부산광역시 서구 토성동5가 34-3 해오름상가1층','부산광역시 서구 구덕로 130 (토성동5가, 해오름상가1층)',49246,'대호동물병원','2022-03-21 17:41','U','2022-03-23 2:40',384325.619,179413.6862);
--행 71
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6507,3340000,'3.34E+17',to_date('2012-08-21', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-205-1017','부산광역시 사하구 감천동 682번지 감천백산상가2-1호','부산광역시 사하구 감천로 32 (감천동)',49446,'삼성종합동물병원','2012-08-21 10:45','I','2018-08-31 23:59',381947.348,178690.0983);
--행 72
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6508,3340000,'3.34E+17',to_date('2013-07-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','291-7900','부산광역시 사하구 하단동 505-8번지','부산광역시 사하구 낙동대로 511 (하단동)',49309,'라온동물병원','2017-05-16 10:06','I','2018-08-31 23:59',379149.295,180733.465);
--행 73
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6509,3340000,'3.34E+17',to_date('2014-12-17', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-265-7582','부산광역시 사하구 다대동 37','부산광역시 사하구 다송로 36 (다대동)',49518,'김현태김동민 동물병원','2022-08-18 9:21','U','2022-08-20 2:40',380622.3602,175774.3576);
--행 74
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6510,3340000,'3.34E+17',to_date('2015-04-27', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-204-7576','부산광역시 사하구 신평동 589-1번지','부산광역시 사하구 하신번영로 201 (신평동)',49431,'코끼리동물병원','2019-04-26 17:02','U','2019-04-28 2:40',378500.6006,179507.0594);
--행 75
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6511,3340000,'3.34E+17',to_date('2017-08-09', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-264-7584','부산광역시 사하구 장림동 190-3번지','부산광역시 사하구 다대로 254 (장림동)',49466,'나은 동물병원','2019-04-26 17:00','U','2019-04-28 2:40',380247.0991,177431.5658);
--행 76
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6512,3400000,'3.40E+17',to_date('1996-06-20', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','721-8075','부산광역시 기장군 기장읍 대라리 35-12','부산광역시 기장군 기장읍 차성로288번길 61',NULL,'기장동물병원','2021-06-01 9:22','U','2021-06-03 2:40',401742.193,196019.2395);
--행 77
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6513,3400000,'3.40E+17',to_date('1987-01-14', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','727-0170','부산광역시 기장군 장안읍 좌천리 252-13','부산광역시 기장군 장안읍 해맞이로 17-1',46033,'좌천동물병원','2022-03-28 14:29','U','2022-03-30 2:40',404115.2555,203878.7833);
--행 78
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6540,3720000,'3.72E+17',to_date('2001-02-12', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-295-8875','울산광역시 북구 매곡동 898-2','울산광역시 북구 당수골2길 3(매곡동)',44225,'이솝동물병원','2022-12-28 10:08','U','2022-12-30 2:40',413714.1594,239986.2095);
--행 79
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6541,3720000,'3.72E+17',to_date('2003-04-11', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-287-0348','울산광역시 북구 진장동 727-4번지','울산광역시 북구 진장17길 11 (진장동)',44250,'정철 동물병원','2015-11-11 13:55','I','2018-08-31 23:59',413478.9035,231692.1172);
--행 80
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6542,3720000,'3.72E+17',to_date('2010-03-31', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-281-0906','울산광역시 북구 상안동 357-2번지','울산광역시 북구 신답로 40 (상안동)',NULL,'배박사 동물병원','2019-05-30 14:20','U','2019-06-01 2:40',412240.795,239129.7878);
--행 81
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6543,3720000,'3.72E+17',to_date('2011-05-30', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','울산광역시 북구 상안동 432-249번지','울산광역시 북구 신답로 26 (상안동, 홈플러스)',44209,'쿨펫동물병원 홈플러스 북구점','2019-12-30 9:50','U','2020-01-01 2:40',412349.3005,239222.4501);
--행 82
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6544,3720000,'3.72E+17',to_date('2015-12-14', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-265-8275','울산광역시 북구 신천동 431-12','울산광역시 북구 호계로 365-1 (신천동)',44221,'호계동물병원','2022-05-17 21:30','U','2022-05-19 2:40',412610.6753,239802.4672);
--행 83
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6545,3720000,'3.72E+17',to_date('2016-04-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-297-7582','울산광역시 북구 상안동 357번지','울산광역시 북구 신답로 48 (상안동, 프리지아)',44209,'서울한빛동물병원','2018-05-30 13:50','I','2018-08-31 23:59',412186.1266,239113.3627);
--행 84
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6546,3720000,'3.72E+17',to_date('2017-03-31', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-291-1190','울산광역시 북구 매곡동 230 102호','울산광역시 북구 매곡산업로 177, 102호 (매곡동)',44225,'울산착한동물병원','2021-03-26 20:47','U','2021-03-28 2:40',413866.5754,240278.8712);
--행 85
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6547,3720000,'3.72E+17',to_date('2017-11-03', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-288-9191','울산광역시 북구 화봉동 1463번지 화봉 쌍용예가 124동 113호','울산광역시 북구 화동로 11, 124동 1층 113호 (화봉동, 화봉 쌍용예가)',44240,'화봉GL동물병원','2019-03-07 15:41','U','2019-03-09 2:40',414529.3837,235091.8679);
--행 86
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6548,3690000,'3.69E+17',to_date('1990-03-12', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','297-0979','울산광역시 중구 학성동 192-1','울산광역시 중구 학성공원13길 45 (학성동)',44527,'울산동물병원','2022-07-04 14:42','U','2022-07-06 2:40',411839.8643,230949.0797);
--행 87
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6549,3690000,'3.69E+17',to_date('2016-07-28', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','286-5050','울산광역시 중구 반구동 26-6번지','울산광역시 중구 번영로 524 (반구동)',44508,'라온 동물 메디컬센터','2016-07-28 15:00','I','2018-08-31 23:59',412098.1465,232133.9937);
--행 88
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6550,3690000,'3.69E+17',to_date('1996-11-06', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','292-4112','울산광역시 중구 반구동 106-6번지','울산광역시 중구 구교로 163 (반구동)',44513,'전영호동물병원','2020-05-12 9:18','U','2020-05-14 2:40',412104.371,231353.7915);
--행 89
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6551,3690000,'3.69E+17',to_date('2001-10-20', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','211-0023','울산광역시 중구 성남동 182-8번지','울산광역시 중구 중앙길 75 (성남동)',44529,'이박사동물병원','2019-03-05 20:48','U','2019-03-07 2:40',410078.1411,230855.5064);
--행 90
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6552,3690000,'3.69E+17',to_date('2005-05-13', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','281-2294','울산광역시 중구 유곡동 475-10번지','울산광역시 중구 종가3길 24, 1층 (유곡동)',44539,'우정 동물병원','2018-08-02 15:10','I','2018-08-31 23:59',408192.9166,231382.5846);
--행 91
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6553,3690000,'3.69E+17',to_date('2010-04-01', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','246-3123','울산광역시 중구 태화동 37-7번지','울산광역시 중구 화진길 13-2 (태화동)',44452,'닥터강동물병원','2012-10-04 16:56','I','2018-08-31 23:59',409263.7899,230795.413);
--행 92
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6554,3690000,'3.69E+17',to_date('2013-01-22', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','244-4296','울산광역시 중구 다운동 552-2번지 대왕빌딩 1층','울산광역시 중구 다운로 1 (다운동)',44407,'산타클라라동물병원','2013-09-10 17:47','I','2018-08-31 23:59',406245.027,230833.0814);
--행 93
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6555,3690000,'3.69E+17',to_date('2014-03-13', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','281-3567','울산광역시 중구 학산동 47-15번지','울산광역시 중구 학산로 5 (학산동)',44520,'쿨펫동물병원','2019-03-05 20:52','U','2019-03-07 2:40',411155.6383,230934.9092);
--행 94
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6556,3690000,'3.69E+17',to_date('2014-07-21', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','211-2399','울산광역시 중구 태화동 428-2번지','울산광역시 중구 태화로 160 (태화동)',44457,'태화동물병원','2020-04-21 9:27','U','2020-04-23 2:40',407880.8398,230529.6116);
--행 95
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6557,3690000,'3.69E+17',to_date('2015-02-09', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','212-2475','울산광역시 중구 우정동 279-2','울산광역시 중구 명륜로 64-1 (우정동)',44467,'제갈견 동물병원','2022-07-04 14:40','U','2022-07-06 2:40',409475.2121,231081.5635);
--행 96
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6558,3700000,'3.70E+17',to_date('2001-08-16', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','268-8884','울산광역시 남구 신정동 576-18','울산광역시 남구 봉월로 104 (신정동)',44670,'리틀쥬동물의료원','2022-07-13 16:43','U','2022-07-15 2:40',409088.1383,229335.1443);
--행 97
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6559,3700000,'3.70E+17',to_date('2002-01-16', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','258-2516','울산광역시 남구 달동 1400-5','울산광역시 남구 삼산로 94 (달동)',44722,'이승진동물병원','2021-08-24 15:42','U','2021-08-26 2:40',410157.2089,228556.745);
--행 98
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6560,3700000,'3.70E+17',to_date('2002-10-25', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-223-5575','울산광역시 남구 무거동 461 웰츠타워','울산광역시 남구 대학로 164, 102호 (무거동, 웰츠타워)',44611,'문수동물병원','2021-02-03 16:03','U','2021-02-05 2:40',405168.7369,230008.7398);
--행 99
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6561,3700000,'3.70E+17',to_date('2002-11-01', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','257-7582','울산광역시 남구 달동 589-1번지','울산광역시 남구 번영로 147-1 (달동)',NULL,'메디펫우리동물병원','2018-10-11 20:37','U','2018-10-11 23:59',410982.9662,229008.7639);
--행 100
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6562,3700000,'3.70E+17',to_date('2003-01-03', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','247-6656','울산광역시 남구 무거동 855-7번지 2층','울산광역시 남구 대학로 127, 2층 (무거동)',44607,'도그 앤 피플 동물병원','2013-07-30 13:38','I','2018-08-31 23:59',404972.6305,229738.4191);
--행 101
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6563,3700000,'3.70E+17',to_date('2003-10-21', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','224-8275','울산광역시 남구 무거동 1434-3번지','울산광역시 남구 북부순환도로 40 (무거동)',NULL,'남산동물병원','2019-03-07 10:42','U','2019-03-09 2:40',405588.4576,230386.8445);
--행 102
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6564,3700000,'3.70E+17',to_date('2005-01-11', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','267-0025','울산광역시 남구 달동 1328-3번지','울산광역시 남구 돋질로 234 (달동)',44703,'강남동물병원','2017-09-27 13:57','I','2018-08-31 23:59',411287.2817,229487.1199);
--행 103
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6565,3700000,'3.70E+17',to_date('2006-03-10', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','266-0075','울산광역시 남구 옥동 249-3','울산광역시 남구 문수로 358 (옥동)',44662,'옥동종합 동물병원','2023-02-17 9:20','U','2023-02-19 2:40',407853.3739,228500.5043);
--행 104
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6566,3700000,'3.70E+17',to_date('2008-08-20', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','울산광역시 남구 옥동 146-1','울산광역시 남구 대공원로 94 (옥동, 울산대공원내 동물농장)',44660,'울산광역시 야생동물구조관리센터','2022-12-08 11:45','U','2022-12-10 2:40',407967.949,228067.9601);
--행 105
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6567,3700000,'3.70E+17',to_date('2009-02-06', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','247-7975','울산광역시 남구 무거동 228-1','울산광역시 남구 북부순환도로 23, 1층 (무거동)',44629,'원헬스 동물의료센터','2022-09-23 15:20','U','2022-09-25 2:40',405433.6134,230398.6922);
--행 106
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6568,3700000,'3.70E+17',to_date('2009-12-31', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','울산광역시 남구 삼산동 1551-7','울산광역시 남구 화합로 200(삼산동)',44713,'강일웅 동물메디컬 센터','2022-12-21 9:19','U','2022-12-23 2:40',412126.241,229492.6933);
--행 107
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6569,3700000,'3.70E+17',to_date('2010-03-22', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','277-0075','울산광역시 남구 무거동 617-3번지','울산광역시 남구 대학로 112 (무거동)',NULL,'스마일동물병원','2018-06-13 13:21','I','2018-08-31 23:59',404963.1337,229569.098);
--행 108
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6570,3700000,'3.70E+17',to_date('2014-08-05', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','227-8275','울산광역시 남구 야음동 789-91번지','울산광역시 남구 수암로 148, 3층 (야음동, 홈플러스)',44750,'쿨펫동물병원','2014-08-05 13:51','I','2018-08-31 23:59',410624.9593,227668.0416);
--행 109
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6571,3710000,'3.71E+17',to_date('1995-05-25', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052)252-5878','울산광역시 동구 일산동 574-33번지 1통3반','울산광역시 동구 방어진순환도로 645 (일산동)',44067,'일산동물의료센터','2013-09-09 20:42','I','2018-08-31 23:59',420250.4306,224904.3804);
--행 110
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6572,3710000,'3.71E+17',to_date('2006-03-29', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052)235-7585','울산광역시 동구 방어동 73-1번지','울산광역시 동구 방어진순환도로 548 (방어동)',44059,'방어진 행복한 동물병원','2014-04-25 19:55','I','2018-08-31 23:59',420112.4351,223926.9659);
--행 111
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6573,3710000,'3.71E+17',to_date('2014-07-03', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-234-7576','울산광역시 동구 일산동 948-3','울산광역시 동구 일산진6길 22, 1층 (일산동)',44056,'손대하 동물병원','2021-05-20 15:28','U','2021-05-22 2:40',420448.6761,224749.8753);
--행 112
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6574,3710000,'3.71E+17',to_date('2017-01-01', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-232-3567','울산광역시 동구 일산동 577-1번지','울산광역시 동구 방어진순환도로 637 (일산동, 홈플러스)',44068,'쿨펫동물병원 동구점','2019-03-06 13:31','U','2019-03-08 2:40',420194.5062,224850.3237);
--행 113
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6575,3700000,'3.70E+17',to_date('2011-01-21', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','273-0975','울산광역시 남구 삼산동 1646 이마트울산점 3층','울산광역시 남구 남중로 48 (삼산동,이마트울산점 3층)',NULL,'펫하우스 동물병원','2022-05-06 17:06','U','2022-05-08 2:40',412914.803,229015.4301);
--행 114
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6576,3700000,'3.70E+17',to_date('2012-08-20', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-977-2405','울산광역시 남구 삼산동 1472-2','울산광역시 남구 돋질로 273 (삼산동)',44700,'숲동물병원','2021-07-29 9:46','U','2021-07-31 2:40',411652.8987,229681.5898);
--행 115
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6577,3700000,'3.70E+17',to_date('2013-11-04', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','268-3567','울산광역시 남구 달동 830-1번지','울산광역시 남구 삼산로 74, 2층 (달동, 롯데마트울산점)',44722,'위즈펫동물병원(롯데마트 울산점)','2017-11-07 8:32','I','2018-08-31 23:59',409970.3908,228450.8647);
--행 116
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6578,3700000,'3.70E+17',to_date('2014-10-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','707-2475','울산광역시 남구 달동 116-2','울산광역시 남구 삼산로 160 (달동)',44726,'울산에스동물메디컬센터','2022-09-26 16:17','U','2022-09-28 2:40',410788.7871,228788.4905);
--행 117
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6579,3700000,'3.70E+17',to_date('2015-07-31', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','529038275','울산광역시 남구 삼산동 180-33번지','울산광역시 남구 돋질로 385-1 (삼산동)',44710,'주동물병원','2019-03-19 15:10','U','2019-03-21 2:40',412785.7908,229635.9396);
--행 118
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6580,3700000,'3.70E+17',to_date('2016-08-09', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','울산광역시 남구 달동 634-13번지','울산광역시 남구 신정로 85-2 (달동)',44692,'울산동물영상센터','2016-08-09 22:18','I','2018-08-31 23:59',410363.8465,229090.8909);
--행 119
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6581,3700000,'3.70E+17',to_date('2017-04-27', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','울산광역시 남구 신정동 479-7번지','울산광역시 남구 중앙로 282 (신정동)',44679,'권오성동물병원','2017-05-22 20:17','I','2018-08-31 23:59',409428.3321,229802.1849);
--행 120
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6582,3700000,'3.70E+17',to_date('2002-03-22', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','273-0075','울산광역시 남구 신정동 657-1번지','울산광역시 남구 중앙로 165-1 (신정동)',NULL,'사랑동물병원','2018-07-09 14:55','I','2018-08-31 23:59',409752.1229,228695.3504);
--행 121
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6583,3700000,'3.70E+17',to_date('1997-08-12', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','257-3669','울산광역시 남구 야음동 694-19번지','울산광역시 남구 수암로149번길 2 (야음동)',NULL,'현대동물병원','2018-10-03 18:07','U','2018-10-05 2:35',410680.3187,227762.7849);
--행 122
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6584,3700000,'3.70E+17',to_date('2000-12-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','258-2520','울산광역시 남구 신정동 1873 대공원코오롱파크폴리스 207호','울산광역시 남구 대공원로 241, 207호 (신정동, 대공원코오롱파크폴리스)',44667,'대공원 동물병원','2020-12-06 10:49','U','2020-12-08 2:40',409204.4716,228147.844);
--행 123
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6585,3700000,'3.70E+17',to_date('2001-08-01', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','273-5911','울산광역시 남구 신정동 186-9번지','울산광역시 남구 중앙로 218-1 (신정동)',NULL,'미래펫 동물병원','2018-10-16 21:13','U','2018-10-18 2:35',409633.2012,229202.7551);
--행 124
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6776,3300000,'3.30E+17',to_date('2019-12-26', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-506-8492,8493','부산광역시 동래구 사직동 100-2번지','부산광역시 동래구 아시아드대로 131-1, 2층 (사직동)',47875,'유기화동물의료센터','2019-12-26 11:30','I','2019-12-28 0:23',388055.2241,190505.5547);
--행 125
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6788,3330000,'3.33E+17',to_date('2020-05-01', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-710-1766','부산광역시 해운대구 송정동 311-22','부산광역시 해운대구 송정광어골로 22, 1층 (송정동)',48073,'해밀동물병원','2021-06-03 11:01','U','2021-06-05 2:40',400139.14,188900.8272);
--행 126
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6801,3350000,'3.35E+17',to_date('2020-03-10', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-583-7575','부산광역시 금정구 부곡동 889-7','부산광역시 금정구 부곡로 3, 1~2층 (부곡동)',46311,'에이치동물메디컬센터','2020-08-19 16:39','U','2020-08-21 2:40',389902.9114,192926.6937);
--행 127
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6824,3290000,'3.29E+17',to_date('2020-03-11', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-894-1202','부산광역시 부산진구 가야동 143-48번지','부산광역시 부산진구 가야대로 517, 윤정빌딩 (가야동)',47270,'보듬 동물병원','2020-03-13 11:07','U','2020-03-15 2:40',384774.7988,185717.1296);
--행 128
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6855,3370000,'3.37E+17',to_date('2021-12-28', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-711-8253','부산광역시 연제구 연산동 702-10 진도사옥','부산광역시 연제구 중앙대로 1084, 진도사옥 1~3층 (연산동)',47596,'24시 센텀동물메디컬센터 연산점','2023-01-09 11:54','U','2023-01-11 2:40',389473.2815,189228.0611);
--행 129
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6859,3400000,'3.40E+17',to_date('2022-01-26', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 기장군 기장읍 대라리 162-18','부산광역시 기장군 기장읍 대청로 8, 1층',46074,'힐링페츠동물병원','2022-01-26 9:57','I','2022-01-28 0:22',401207.2277,195404.0672);
--행 130
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6870,3700000,'3.70E+17',to_date('2021-12-23', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-281-3567','울산광역시 남구 삼산동 1550-12','울산광역시 남구 화합로 197, 1층 (삼산동)',44705,'아너스 동물병원','2021-12-23 11:26','I','2021-12-25 0:22',412066.5328,229485.2464);
--행 131
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6932,3350000,'3.35E+17',to_date('1991-10-09', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','515-7450','부산광역시 금정구 부곡동 255-4 행복한빌딩','부산광역시 금정구 부곡로 184, 행복한빌딩 1,2층 (부곡동)',46269,'지동범 동물 안과 치과병원','2022-06-08 17:56','U','2022-06-10 2:40',390375.2841,194559.5706);
--행 132
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6933,3350000,'3.35E+17',to_date('1994-07-05', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 금정구 부곡동 324-13','부산광역시 금정구 부곡로 86 (부곡동)',46305,'부곡동물병원','2022-09-15 10:33','U','2022-09-17 2:40',390329.9188,193585.2349);
--행 133
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6934,3350000,'3.35E+17',to_date('2011-10-11', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','515-5179','부산광역시 금정구 장전동 615-6','부산광역시 금정구 식물원로 38, 주현빌딩 2층 (장전동)',46297,'금빛동물의료센터','2022-07-25 17:34','U','2022-07-27 2:40',389697.6318,193741.7614);
--행 134
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6935,3350000,'3.35E+17',to_date('1997-09-23', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','531-2852','부산광역시 금정구 서동 208-26번지','부산광역시 금정구 서동로 200 (서동)',46328,'한독동물병원','2019-03-06 15:12','U','2019-03-08 2:40',391881.9503,192564.799);
--행 135
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6936,3350000,'3.35E+17',to_date('1999-01-29', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','582-9335','부산광역시 금정구 장전동 219-6번지','부산광역시 금정구 금강로 340 (장전동)',46283,'수종합동물병원','2019-11-04 10:05','U','2019-11-06 2:40',389869.602,195239.2125);
--행 136
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6937,3350000,'3.35E+17',to_date('2000-06-14', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','517-8275','부산광역시 금정구 남산동 321-12번지 B동 202호','부산광역시 금정구 금강로 703-3 (남산동)',46221,'남산동물병원','2019-11-04 10:14','U','2019-11-06 2:40',390000.7229,198773.9895);
--행 137
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6938,3350000,'3.35E+17',to_date('2001-06-09', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','582-8701','부산광역시 금정구 구서동 839-1번지 101동 303호','부산광역시 금정구 금강로 578 (구서동)',46229,'에이스종합동물병원','2013-04-16 16:11','I','2018-08-31 23:59',389935.9516,197530.2749);
--행 138
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6939,3350000,'3.35E+17',to_date('2005-08-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','512-1661','부산광역시 금정구 구서동 258-22번지','부산광역시 금정구 금강로 454 (구서동)',46243,'구서동물병원','2019-11-04 10:16','U','2019-11-06 2:40',390042.8788,196306.4151);
--행 139
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6940,3350000,'3.35E+17',to_date('2013-01-04', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','516-7585','부산광역시 금정구 장전동 629-11','부산광역시 금정구 금강로 206-3 (장전동)',46297,'순동물병원','2021-11-09 9:18','U','2021-11-11 2:40',389575.4796,193936.9299);
--행 140
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6941,3350000,'3.35E+17',to_date('2014-08-25', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','714-0209','부산광역시 금정구 부곡동 224-1','부산광역시 금정구 수림로 25 (부곡동)',46276,'동물병원 산책','2023-03-23 9:33','U','2023-03-25 2:40',390130.9936,195312.2119);
--행 141
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6942,3350000,'3.35E+17',to_date('2015-03-06', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 금정구 구서동 742-48번지','부산광역시 금정구 금강로 539 (구서동)',46231,'드림동물병원','2019-03-27 14:32','U','2019-03-29 2:40',389916.8462,197132.4076);
--행 142
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6943,3350000,'3.35E+17',to_date('2015-04-17', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','525-7810','부산광역시 금정구 서동 204-12','부산광역시 금정구 서동로175번길 11, 2층 (서동)',46321,'서동 동물메디컬센터','2021-08-02 10:21','U','2021-08-04 2:40',391719.8534,192660.6626);
--행 143
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6944,3350000,'3.35E+17',to_date('2015-04-27', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','516-1175','부산광역시 금정구 부곡동 24-6','부산광역시 금정구 중앙대로 1754 (부곡동)',46253,'제일2차동물메디컬센터','2023-01-11 9:31','U','2023-01-13 2:40',390473.3881,195515.8363);
--행 144
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6945,3350000,'3.35E+17',to_date('2015-04-27', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','516-1175','부산광역시 금정구 부곡동 24-6','부산광역시 금정구 중앙대로 1754 (부곡동)',46253,'제일동물진단영상센터','2023-01-11 9:26','U','2023-01-13 2:40',390473.3881,195515.8363);
--행 145
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6946,3350000,'3.35E+17',to_date('2015-08-28', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','518-1360','부산광역시 금정구 구서동 319-6번지','부산광역시 금정구 중앙대로1841번길 24 (구서동, E마트금정점)',46233,'쿨펫동물병원 이마트금정점','2019-05-03 10:10','U','2019-05-05 2:40',390161.6934,196690.2227);
--행 146
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6947,3340000,'3.34E+17',to_date('2003-03-26', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','292-0141','부산광역시 사하구 괴정동 550-1번지','부산광역시 사하구 낙동대로 295-1 (괴정동)',604-812,'참조은 동물병원','2017-05-16 9:59','I','2018-08-31 23:59',380902.6085,179597.7326);
--행 147
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6948,3340000,'3.34E+17',to_date('2004-09-15', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','262-7582','부산광역시 사하구 다대동 935-11번지','부산광역시 사하구 윤공단로56번길 55 (다대동)',49493,'장 동물병원','2019-04-26 17:16','U','2019-04-28 2:40',379663.3476,175088.2304);
--행 148
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6949,3340000,'3.34E+17',to_date('1992-04-30', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-206-1891','부산광역시 사하구 당리동 373-4','부산광역시 사하구 낙동대로 356 (당리동)',49345,'사하동물의료원','2022-07-04 11:44','U','2022-07-06 2:40',380363.7722,179842.5875);
--행 149
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6950,3340000,'3.34E+17',to_date('1992-08-28', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','202-7002','부산광역시 사하구 당리동 325-1번지','부산광역시 사하구 낙동대로 407 (당리동)',49411,'박 동물병원','2020-04-09 19:10','U','2020-04-11 2:40',379877.2213,180029.7204);
--행 150
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6951,3320000,'3.32E+17',to_date('1991-01-17', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','332-8060','부산광역시 북구 덕천동 375-5','부산광역시 북구 만덕대로 119 (덕천동)',46554,'덕천동물의료센터','2022-07-28 10:36','U','2022-07-30 2:40',383674.2857,192327.6662);
--행 151
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6952,3390000,'3.39E+17',to_date('1989-11-23', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','322-3026','부산광역시 사상구 괘법동 555-26번지','부산광역시 사상구 사상로 153 (괘법동)',46974,'사상동물병원','2011-10-30 14:32','I','2018-08-31 23:59',380983.7697,186277.2017);
--행 152
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6953,3390000,'3.39E+17',to_date('1991-10-16', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','313-2559','부산광역시 사상구 주례동 1162-3번지','부산광역시 사상구 가야대로 258 (주례동)',47012,'주례동물병원','2011-10-30 14:33','I','2018-08-31 23:59',382265.7392,185261.7392);
--행 153
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6954,3390000,'3.39E+17',to_date('1996-03-20', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','304-6455','부산광역시 사상구 덕포동 429-13번지','부산광역시 사상구 사상로 261 (덕포동)',46955,'신병헌동물병원','2014-01-28 17:44','I','2018-08-31 23:59',380490.0777,187240.8032);
--행 154
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6955,3390000,'3.39E+17',to_date('1996-03-11', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','325-1638','부산광역시 사상구 모라동 1338-8번지','부산광역시 사상구 백양대로 957 (모라동)',46926,'모라동물병원','2014-01-07 17:33','I','2018-08-31 23:59',381359.1447,189866.9462);
--행 155
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6956,3390000,'3.39E+17',to_date('1998-12-21', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','317-7558','부산광역시 사상구 주례동 519-62번지','부산광역시 사상구 주례로10번길 125 (주례동)',NULL,'대성동물병원','2005-12-19 16:53','I','2018-08-31 23:59',382603.9317,185187.337);
--행 156
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6957,3390000,'3.39E+17',to_date('2003-01-22', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','324-9954','부산광역시 사상구 주례동 23-2번지','부산광역시 사상구 가야대로 367 (주례동)',47005,'개금동물병원','2014-01-07 17:35','I','2018-08-31 23:59',383345.2004,185460.5855);
--행 157
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6958,3390000,'3.39E+17',to_date('2003-08-25', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-316-7597','부산광역시 사상구 엄궁동 25-25','부산광역시 사상구 대동로 18(엄궁동)',47035,'엄궁종합동물병원','2022-08-09 10:26','U','2022-08-11 2:40',379809.7725,183277.9206);
--행 158
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6959,3390000,'3.39E+17',to_date('2004-09-22', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','311-7578','부산광역시 사상구 모라동 459-2번지','부산광역시 사상구 모라로 107 (모라동)',46928,'고은동물병원','2014-01-07 17:37','I','2018-08-31 23:59',381307.1941,189290.726);
--행 159
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6960,3390000,'3.39E+17',to_date('2006-05-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-314-7582','부산광역시 사상구 엄궁동 690번지 롯데마트엄궁점','부산광역시 사상구 낙동대로 733, 롯데마트엄궁점 2층 (엄궁동)',47032,'쿨펫동물병원','2019-03-05 10:13','U','2019-03-07 2:40',379352.8056,182712.0791);
--행 160
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6961,3390000,'3.39E+17',to_date('2014-10-24', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-312-7555','부산광역시 사상구 학장동 574-9번지','부산광역시 사상구 대동로 129 (학장동)',47050,'학장동물병원','2014-10-24 9:56','I','2018-08-31 23:59',380507.1169,184123.0521);
--행 161
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6962,3390000,'3.39E+17',to_date('2018-05-11', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 사상구 엄궁동 565-1번지','부산광역시 사상구 낙동대로 786, 애진빌딩 201호 (엄궁동)',47039,'서부산동물메디컬센터','2019-03-28 8:49','U','2019-03-30 2:40',379687.7552,183065.344);
--행 162
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6963,3270000,'3.27E+17',to_date('1972-11-18', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 동구 초량동 287-15번지 7통1반','부산광역시 동구 초량상로 83 (초량동)',48813,'제일동물병원','2013-12-27 11:36','I','2018-08-31 23:59',385749.4901,181903.5903);
--행 163
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6964,3270000,'3.27E+17',to_date('1992-07-04', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 동구 수정동 427-48번지','부산광역시 동구 망양로 835-1 (수정동)',NULL,'동구종합동물병원','2012-03-28 10:21','I','2018-08-31 23:59',386376.9507,183797.3733);
--행 164
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6965,3270000,'3.27E+17',to_date('2005-06-24', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','464-5975','부산광역시 동구 초량동 287-9번지','부산광역시 동구 초량상로 84-1 (초량동)',48814,'시민동물병원','2019-01-17 10:54','U','2019-01-19 2:40',385778.9416,181909.9164);
--행 165
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6966,3270000,'3.27E+17',to_date('2009-05-11', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 동구 수정동 811-42번지','부산광역시 동구 수정동로 11, 1층 (수정동)',48780,'하나동물병원','2019-01-17 10:52','U','2019-01-19 2:40',386326.2362,183082.7421);
--행 166
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6967,3320000,'3.32E+17',to_date('1992-06-15', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','332-7588','부산광역시 북구 만덕동 839-1번지','부산광역시 북구 덕천로 280 (만덕동)',46611,'백양동물병원','2019-03-27 14:48','U','2019-03-29 2:40',385250.1351,191889.103);
--행 167
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6968,3320000,'3.32E+17',to_date('1999-07-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','343-7588','부산광역시 북구 화명동 2337번지 화명2차동원로얄듀크비스타','부산광역시 북구 금곡대로 175 (화명동, 화명2차동원로얄듀크비스타)',46541,'노아동물병원','2019-03-27 14:46','U','2019-03-29 2:40',382841.0071,193563.9531);
--행 168
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6969,3320000,'3.32E+17',to_date('2002-12-21', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','365-0075','부산광역시 북구 덕천동 383-3번지','부산광역시 북구 만덕대로 34 (덕천동)',46577,'21세기종합동물병원','2019-03-27 14:40','U','2019-03-29 2:40',382847.4897,192011.4705);
--행 169
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6970,3320000,'3.32E+17',to_date('2003-03-21', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','342-3739','부산광역시 북구 구포동 669-2번지 장원동물병원','부산광역시 북구 시랑로 1, 장원동물병원 (구포동)',46599,'장원동물병원','2019-03-27 14:51','U','2019-03-29 2:40',382479.7046,191404.0266);
--행 170
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6971,3320000,'3.32E+17',to_date('2003-09-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 북구 화명동 1469-4번지','부산광역시 북구 금곡대로 304 (화명동)',NULL,'차동물병원','2007-08-07 11:36','I','2018-08-31 23:59',383277.6521,194763.9);
--행 171
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6972,3320000,'3.32E+17',to_date('2016-06-10', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051)343-3834','부산광역시 북구 구포동 935-2번지','부산광역시 북구 백양대로 1053 (구포동)',46649,'해든동물병원','2019-09-06 16:45','U','2019-09-08 2:40',381760.255,190742.6321);
--행 172
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6973,3320000,'3.32E+17',to_date('2009-07-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','363-7593','부산광역시 북구 화명동 1528-5번지 화명빌딩202호','부산광역시 북구 금곡대로 344 (화명동,화명빌딩202호)',NULL,'행복한동물병원','2009-07-02 16:00','I','2018-08-31 23:59',383303.8909,195174.3782);
--행 173
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6974,3320000,'3.32E+17',to_date('2012-03-08', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','513380075','부산광역시 북구 만덕동 916-7번지','부산광역시 북구 덕천로 227 (만덕동)',46571,'만덕24시동물병원','2012-03-08 14:02','I','2018-08-31 23:59',384684.1348,192061.9041);
--행 174
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6975,3320000,'3.32E+17',to_date('2013-04-16', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051361-7582','부산광역시 북구 화명동 898-19 새마을금고','부산광역시 북구 금곡대로 182, 새마을금고 (화명동)',46539,'카이저 동물병원','2021-05-07 13:16','U','2021-05-09 2:40',382940.7371,193602.7466);
--행 175
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6976,3320000,'3.32E+17',to_date('2014-06-09', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','365-7588','부산광역시 북구 금곡동 1880-12번지 해림빌딩','부산광역시 북구 학사로 299, 해림빌딩 (금곡동)',46519,'그랜드 동물병원','2019-05-07 14:45','U','2019-05-09 2:40',383111.1017,196111.9007);
--행 176
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6977,3320000,'3.32E+17',to_date('2017-06-14', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','343-7566','부산광역시 북구 덕천동 381-7번지','부산광역시 북구 만덕대로 41 (덕천동)',46548,'유동물의료센터','2018-08-17 13:43','I','2018-08-31 23:59',382906.3354,192089.3221);
--행 177
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6978,3320000,'3.32E+17',to_date('2018-01-31', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-341-3344','부산광역시 북구 덕천동 373-1번지 삼정그린코아아파트','부산광역시 북구 만덕대로155번길 9 (덕천동, 삼정그린코아아파트)',46554,'더힐동물병원','2019-03-27 14:46','U','2019-03-29 2:40',383934.8365,192378.5329);
--행 178
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6979,3280000,'3.28E+17',to_date('2002-01-04', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-415-2566','부산광역시 영도구 영선동1가 20-4번지','부산광역시 영도구 태종로 111 (영선동1가)',49036,'영도동물병원','2019-03-07 11:08','U','2019-03-09 2:40',386238.8453,178803.0597);
--행 179
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6980,3280000,'3.28E+17',to_date('1996-05-09', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-405-9493','부산광역시 영도구 동삼동 266-3번지','부산광역시 영도구 동삼로 80 (동삼동)',49097,'태종동물병원','2019-03-07 11:08','U','2019-03-09 2:40',388779.0746,177680.767);
--행 180
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6981,3280000,'3.28E+17',to_date('2004-01-03', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','415-2468','부산광역시 영도구 대교동1가 143번지','부산광역시 영도구 태종로 78 (대교동1가)',49045,'센트럴종합동물병원','2019-03-07 11:12','U','2019-03-09 2:40',385893.7103,178909.5597);
--행 181
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6982,3280000,'3.28E+17',to_date('2009-09-30', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','414-7588','부산광역시 영도구 청학동 62-60번지 한라청학아파트','부산광역시 영도구 태종로 430, 한라청학아파트 2층 (청학동)',49088,'천동물병원','2019-03-07 11:13','U','2019-03-09 2:40',388500.1629,178645.3397);
--행 182
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6983,3330000,'3.33E+17',to_date('2017-01-13', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-927-7575','부산광역시 해운대구 반여동 1465-57번지 농협반여동지점','부산광역시 해운대구 선수촌로 65-19, 농협반여동지점 2층 (반여동)',48038,'반여착한동물병원','2019-03-27 17:11','U','2019-03-29 2:40',392797.4651,190989.3748);
--행 183
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6984,3330000,'3.33E+17',to_date('2017-06-14', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 해운대구 좌동 1476-1 해운대베르나움','부산광역시 해운대구 양운로 45, 해운대베르나움 111호 (좌동)',48104,'해운대 24시 동물의료원','2022-06-15 11:40','U','2022-06-17 2:40',398251.7811,187524.3185);
--행 184
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6985,3330000,'3.33E+17',to_date('2018-01-24', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-710-2004','부산광역시 해운대구 중동 1262-1','부산광역시 해운대구 해운대해변로357번길 17, 4~8층 (중동)',48096,'큰마음동물메디컬센터','2022-05-25 10:46','U','2022-05-27 2:40',397433.6619,187207.142);
--행 185
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6986,3330000,'3.33E+17',to_date('2018-01-11', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 해운대구 중동 1809번지 해운대힐스테이트위브','부산광역시 해운대구 좌동순환로433번길 30-1, 해운대힐스테이트위브 224~227호 (중동)',48114,'힐 동물병원','2019-03-27 17:16','U','2019-03-29 2:40',398546.5723,186991.922);
--행 186
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6987,3330000,'3.33E+17',to_date('2013-07-22', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','731-7530','부산광역시 해운대구 좌동 1340-3번지 피렌체오피스텔 204호','부산광역시 해운대구 좌동순환로402번길 8, 204호 (좌동, 피렌체오피스텔)',48104,'닥터주 동물병원','2019-03-06 19:46','U','2019-03-08 2:40',398351.677,187037.6461);
--행 187
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6988,3330000,'3.33E+17',to_date('2014-03-16', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-702-1626','부산광역시 해운대구 좌동 1407-2번지 영풍프라자 302호','부산광역시 해운대구 좌동순환로 173, 영풍프라자 302호 (좌동)',48075,'사랑의동물병원','2019-03-06 19:49','U','2019-03-08 2:40',398088.8767,188716.5782);
--행 188
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6989,3330000,'3.33E+17',to_date('2014-06-30', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-702-5750','부산광역시 해운대구 좌동 1473-2번지 엘리움 306호','부산광역시 해운대구 해운대로 794, 엘리움 306호 (좌동)',48104,'마리동물병원','2019-03-27 17:11','U','2019-03-29 2:40',398155.6608,187681.5736);
--행 189
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6990,3330000,'3.33E+17',to_date('2014-10-13', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-701-7599','부산광역시 해운대구 송정동 85-1번지','부산광역시 해운대구 송정2로13번길 46 (송정동)',48069,'누리동물병원','2020-04-17 10:16','U','2020-04-19 2:40',400877.3254,190630.1977);
--행 190
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6991,3330000,'3.33E+17',to_date('2015-05-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','746-7077','부산광역시 해운대구 중동 1512번지 해운대 달맞이 유림 노르웨이숲 상가동 305호','부산광역시 해운대구 달맞이길65번길 33, 상가동 3층 305호 (중동, 해운대 달맞이 유림 노르웨이숲)',48117,'달맞이 호두네 동물병원','2019-03-06 19:46','U','2019-03-08 2:40',398058.7221,186789.9814);
--행 191
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6992,3330000,'3.33E+17',to_date('2016-05-16', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','915-8275','부산광역시 해운대구 좌동 1315 해운대삼정코아주상복합','부산광역시 해운대구 세실로 48, 상가동 1-2, 2-2호 (좌동, 해운대삼정코아주상복합)',48110,'해운대 플러스동물병원','2022-06-15 17:54','U','2022-06-17 2:40',398407.0433,187784.8439);
--행 192
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6993,3330000,'3.33E+17',to_date('2003-12-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 해운대구 반여동 1202-2번지','부산광역시 해운대구 선수촌로 101 (반여동)',48038,'우리동물병원','2019-03-04 15:47','U','2019-03-06 2:40',392922.6227,191342.1604);
--행 193
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6994,3330000,'3.33E+17',to_date('2004-02-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','746-0075','부산광역시 해운대구 우동 1488 대우월드마크센텀아파트','부산광역시 해운대구 센텀동로 25, B동 204호 (우동, 대우월드마크센텀아파트)',48059,'아이센텀 동물메디컬센터','2022-05-04 12:57','U','2022-05-06 2:40',394112.5249,187887.9317);
--행 194
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6995,3330000,'3.33E+17',to_date('2004-03-03', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','704-4376','부산광역시 해운대구 좌동 1315번지 해운대삼정코아복합상가 206호','부산광역시 해운대구 세실로 48, 206호 (좌동)',48110,'화목종합동물병원','2019-03-04 15:43','U','2019-03-06 2:40',398407.0433,187784.8439);
--행 195
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6996,3400000,'3.40E+17',to_date('2012-09-05', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','728-2236','부산광역시 기장군 정관읍 매학리 713-3번지','부산광역시 기장군 정관읍 정관로 565',46015,'킴스동물병원','2019-03-04 15:42','U','2019-03-06 2:40',397801.2386,204661.7615);
--행 196
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6997,3330000,'3.33E+17',to_date('2004-03-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','746-7775','부산광역시 해운대구 우동 529-2번지','부산광역시 해운대구 해운대로 624 (우동)',48095,'해운대조은동물병원','2019-03-04 15:43','U','2019-03-06 2:40',396661.6112,187066.9015);
--행 197
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6998,3330000,'3.33E+17',to_date('2006-08-17', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','744-6336','부산광역시 해운대구 재송동 1200번지 센텀파크아파트상가 6동 205호','부산광역시 해운대구 센텀중앙로 145, 205호 (재송동)',48050,'센텀동물종합병원','2019-03-04 15:49','U','2019-03-06 2:40',393239.2379,188619.1496);
--행 198
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (6999,3330000,'3.33E+17',to_date('2010-02-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','544-0775','부산광역시 해운대구 반송동 20-16번지','부산광역시 해운대구 반송로 922 (반송동)',48004,'토마스동물병원','2017-07-31 13:59','I','2018-08-31 23:59',396052.8154,194703.1301);
--행 199
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7000,3330000,'3.33E+17',to_date('2010-04-05', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-702-7511','부산광역시 해운대구 좌동 985-2번지','부산광역시 해운대구 양운로 108, 2층 (좌동)',48079,'조앤박동물병원','2019-03-06 19:58','U','2019-03-08 2:40',397990.4695,188084.8798);
--행 200
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7001,3330000,'3.33E+17',to_date('2004-08-16', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','784-7844','부산광역시 해운대구 재송동 1098-1번지 14통2반 현대맨션 303호','부산광역시 해운대구 재반로 148, 32호 (재송동)',48053,'갑을동물병원','2019-03-04 15:51','U','2019-03-06 2:40',393214.9667,189314.4738);
--행 201
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7002,3330000,'3.33E+17',to_date('2010-04-09', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','747-7407','부산광역시 해운대구 우동 1435번지 벽산이오렌지프라자','부산광역시 해운대구 마린시티3로 23, 벽산이오렌지프라자 333~336호 (우동)',48118,'마린시티 종합동물병원','2018-05-01 9:57','I','2018-08-31 23:59',395560.2205,186273.7691);
--행 202
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7003,3330000,'3.33E+17',to_date('2011-02-10', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','544-7588','부산광역시 해운대구 반송동 62-508번지','부산광역시 해운대구 윗반송로 73 (반송동)',48007,'BS조은동물병원','2019-03-06 19:40','U','2019-03-08 2:40',396298.3028,194496.4019);
--행 203
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7004,3330000,'3.33E+17',to_date('2011-02-17', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-701-7555','부산광역시 해운대구 좌동 1443-7번지 삼정프라자 303호','부산광역시 해운대구 좌동순환로 309, 303호 (좌동)',48113,'온누리동물병원','2019-03-04 15:48','U','2019-03-06 2:40',398833.568,187648.429);
--행 204
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7005,3330000,'3.33E+17',to_date('2007-03-07', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','529-5388','부산광역시 해운대구 반여동 1629-5번지','부산광역시 해운대구 반여로 96, 1층 (반여동, 영풍빌딩)',48036,'장산동물병원','2019-03-04 15:45','U','2019-03-06 2:40',393310.0757,191056.546);
--행 205
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7006,3330000,'3.33E+17',to_date('2011-05-11', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-746-1075','부산광역시 해운대구 우동 586-23번지','부산광역시 해운대구 해운대로 658-1 (우동)',48095,'스펀지동물병원','2019-03-06 19:53','U','2019-03-08 2:40',396927.881,187259.8968);
--행 206
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7007,3330000,'3.33E+17',to_date('2013-03-20', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-742-7975','부산광역시 해운대구 재송동 1200','부산광역시 해운대구 센텀중앙로 145, 202호 (재송동, 센텀파크상가2동)',48050,'로이종합동물병원','2020-11-11 8:52','U','2020-11-13 2:40',393239.2379,188619.1496);
--행 207
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7008,3370000,'3.37E+17',to_date('1975-10-14', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','862-8668','부산광역시 연제구 거제동 608-18번지','부산광역시 연제구 거제대로 146 (거제동)',47546,'거제동물병원','2019-03-06 16:14','U','2019-03-08 2:40',388481.6072,188882.0699);
--행 208
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7009,3310000,'3.31E+17',to_date('1992-10-20', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','634-4017','부산광역시 남구 문현동 248-21번지','부산광역시 남구 수영로 38 (문현동)',48457,'문현동물병원','2019-04-23 10:04','U','2019-04-25 2:40',388762.2663,183880.0007);
--행 209
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7010,3310000,'3.31E+17',to_date('1995-04-08', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','628-0855','부산광역시 남구 용호동 368-4번지 목련아파트','부산광역시 남구 용호로123번길 5 (용호동, 목련아파트)',48578,'용호동물병원','2019-04-23 10:05','U','2019-04-25 2:40',392505.2154,182296.1227);
--행 210
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7011,3370000,'3.37E+17',to_date('1991-11-23', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','503-0688','부산광역시 연제구 연산동 300-3번지 2통2반','부산광역시 연제구 온천천남로 4 (연산동)',47559,'청조동물병원','2015-04-01 9:59','I','2018-08-31 23:59',390401.3859,190192.3725);
--행 211
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7012,3310000,'3.31E+17',to_date('2013-08-13', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-627-1275','부산광역시 남구 용호동 957-1번지 힐탑탑플레이스 A동 403호','부산광역시 남구 분포로 115, 힐탑탑플레이스 A동 403호 (용호동)',48515,'헬로동물병원','2019-07-15 14:48','U','2019-07-17 2:40',392515.6897,183481.9411);
--행 212
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7013,3370000,'3.37E+17',to_date('2011-01-12', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','753-7580','부산광역시 연제구 연산동 2235-8번지','부산광역시 연제구 과정로 84 (연산동)',47573,'망미동물병원','2019-03-06 16:18','U','2019-03-08 2:40',391900.6472,188657.6668);
--행 213
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7014,3310000,'3.31E+17',to_date('1996-12-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','636-5242','부산광역시 남구 감만동 46-1번지 우암 자유 4차 아파트 상가동 109호','부산광역시 남구 석포로 7, 상가동 109호 (감만동, 우암 자유 4차 아파트)',48489,'우암동물병원','2019-04-23 10:07','U','2019-04-25 2:40',389680.6778,182339.0175);
--행 214
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7015,3310000,'3.31E+17',to_date('2000-06-26', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','635-0402','부산광역시 남구 문현동 359-21번지','부산광역시 남구 수영로 34 (문현동)',48457,'25시 동물병원','2019-04-23 10:08','U','2019-04-25 2:40',388721.0053,183893.2178);
--행 215
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7016,3310000,'3.31E+17',to_date('2002-08-13', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','516217555','부산광역시 남구 대연동 39-22','부산광역시 남구 수영로334번길 3, 2층 (대연동)',48509,'튼튼동물병원','2022-07-08 17:39','U','2022-07-10 2:40',391546.8499,184145.7671);
--행 216
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7017,3310000,'3.31E+17',to_date('2003-03-24', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','623-7588','부산광역시 남구 용호동 176-7번지 메트로동물병원','부산광역시 남구 용호로 20, 메트로동물병원 (용호동)',48518,'메트로동물병원','2019-04-23 10:09','U','2019-04-25 2:40',391986.9735,183043.6328);
--행 217
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7018,3310000,'3.31E+17',to_date('2003-10-13', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','627-2885','부산광역시 남구 대연동 1746-5 호수약국','부산광역시 남구 수영로 224-1, 호수약국 (대연동)',48492,'조양래 동물의료센터','2023-03-22 17:48','U','2023-03-25 2:40',390524.5493,183746.2824);
--행 218
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7021,3310000,'3.31E+17',to_date('2013-05-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051)612-7552','부산광역시 남구 용호동 554-1번지','부산광역시 남구 용호로 233 (용호동)',48593,'해온동물병원','2019-03-06 13:36','U','2019-03-08 2:40',392414.0191,181186.1114);
--행 219
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7022,3310000,'3.31E+17',to_date('2015-11-12', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-622-2171','부산광역시 남구 대연동 1858 대연힐스테이트푸르지오','부산광역시 남구 수영로 345, 1115동 124, 125호 (대연동, 대연힐스테이트푸르지오)',48432,'다온 동물병원','2022-05-04 9:51','U','2022-05-06 2:40',391411.4502,184553.6728);
--행 220
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7023,3310000,'3.31E+17',to_date('2017-10-12', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-624-2475','부산광역시 남구 대연동 1745-9','부산광역시 남구 수영로 221 (대연동)',48445,'UN동물의료센터','2022-10-04 13:59','U','2022-10-06 2:40',390487.343,183799.2048);
--행 221
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7024,3370000,'3.37E+17',to_date('2003-03-28', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','755-4765','부산광역시 연제구 연산동 418-10번지','부산광역시 연제구 과정로 171-1 (연산동)',NULL,'현대동물병원','2019-03-06 16:23','U','2019-03-08 2:40',391842.9893,189546.3727);
--행 222
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7025,3370000,'3.37E+17',to_date('1999-06-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-867-5595','부산광역시 연제구 연산동 746-12번지','부산광역시 연제구 월드컵대로114번길 1 (연산동)',NULL,'양지동물병원','2019-03-06 16:22','U','2019-03-08 2:40',389639.4196,189253.9436);
--행 223
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7026,3370000,'3.37E+17',to_date('2009-05-04', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','864-7582','부산광역시 연제구 연산동 581-4번지','부산광역시 연제구 거제천로 258 (연산동, 월드빌스포츠센터)',47518,'피정현 동물병원','2016-01-25 15:44','I','2018-08-31 23:59',389856.5724,190029.7107);
--행 224
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7027,3370000,'3.37E+17',to_date('2010-12-27', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','868-7591','부산광역시 연제구 거제동 2-7','부산광역시 연제구 거제대로 278 (거제동)',47522,'부산동물메디컬센터','2023-03-22 9:30','U','2023-03-24 2:40',389195.6262,189929.6);
--행 225
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7028,3310000,'3.31E+17',to_date('2013-05-23', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051)636-7582','부산광역시 남구 문현동 403-7 다솜 동물 병원','부산광역시 남구 수영로13번길 3, 다솜 동물 병원 (문현동)',48415,'다솜고양이메디컬센터','2022-10-21 15:54','U','2022-10-23 2:40',388526.2039,183992.3288);
--행 226
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7029,3310000,'3.31E+17',to_date('2013-06-11', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051)704-0220','부산광역시 남구 용호동 532-19번지','부산광역시 남구 용호로 199 (용호동)',48591,'지경희동물병원','2019-03-07 18:32','U','2019-03-09 2:40',392400.4891,181526.932);
--행 227
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7030,3310000,'3.31E+17',to_date('2013-07-15', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-632-7580','부산광역시 남구 문현동 403-7 다솜 동물 병원','부산광역시 남구 수영로13번길 3, 다솜 동물 병원 (문현동)',48415,'(주)다솜동물메디컬센터','2023-03-10 15:05','U','2023-03-12 2:40',388526.2039,183992.3288);
--행 228
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7031,3370000,'3.37E+17',to_date('2018-01-24', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-868-7579','부산광역시 연제구 거제동 1466-24번지','부산광역시 연제구 세병로 84 (거제동)',47516,'온천천동물병원','2018-01-24 14:55','I','2018-08-31 23:59',389618.6578,190495.9021);
--행 229
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7032,3370000,'3.37E+17',to_date('2014-05-20', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-759-8669','부산광역시 연제구 연산동 399-12','부산광역시 연제구 과정로 234-1 (연산동)',47565,'토곡동물병원','2023-02-07 17:23','U','2023-02-09 2:40',391356.083,189652.149);
--행 230
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7033,3370000,'3.37E+17',to_date('2014-06-17', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','868-6631','부산광역시 연제구 연산동 104-82번지','부산광역시 연제구 과정로 354 (연산동)',47559,'MS동물병원','2018-10-19 10:42','U','2018-11-03 4:00',390299.9242,190031.8533);
--행 231
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7034,3370000,'3.37E+17',to_date('2015-09-24', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-868-0075','부산광역시 연제구 연산동 1948-7번지','부산광역시 연제구 연수로 140 (연산동)',47610,'이룸동물병원','2018-10-19 11:29','U','2018-11-03 4:00',389968.7895,188130.6562);
--행 232
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7035,3370000,'3.37E+17',to_date('2015-08-31', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-863-8638','부산광역시 연제구 연산동 306-39','부산광역시 연제구 과정로344번길 1 (연산동)',47559,'아이디펫 동물병원','2021-04-12 10:46','U','2021-04-14 2:40',390337.7549,189955.214);
--행 233
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7036,3370000,'3.37E+17',to_date('2017-08-03', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-753-9875','','부산광역시 연제구 안연로 28, 1층 (연산동, 그린주택)',47565,'해비치동물병원','2017-08-03 10:02','I','2018-08-31 23:59',391228.4176,189893.1211);
--행 234
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7037,3370000,'3.37E+17',to_date('2018-04-20', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-997-8275','부산광역시 연제구 연산동 417-20번지','부산광역시 연제구 과정로237번길 115 (연산동)',47558,'진석범동물병원','2018-04-20 11:08','I','2018-08-31 23:59',391835.1053,189316.067);
--행 235
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7038,3370000,'3.37E+17',to_date('2018-07-12', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-853-7579','부산광역시 연제구 연산동 844-28','부산광역시 연제구 연수로 98 (연산동)',47607,'Jpet동물병원','2023-03-24 13:15','U','2023-03-26 2:40',389553.2447,188196.9353);
--행 236
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7039,3380000,'3.38E+17',to_date('2014-10-24', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-514-5404','','부산광역시 수영구 광안로 19 (광안동)',48297,'서울동물병원','2014-10-24 10:45','I','2018-08-31 23:59',392645.3072,186207.1302);
--행 237
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7040,3380000,'3.38E+17',to_date('2015-03-18', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','','부산광역시 수영구 광남로 184 (광안동)',48303,'나비동물병원','2022-10-25 10:59','U','2022-10-27 2:40',393099.6739,186269.8253);
--행 238
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7041,3380000,'3.38E+17',to_date('2015-06-04', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-627-7542','','부산광역시 수영구 황령산로 3, 2층 (남천동)',48316,'차이 동물병원','2022-08-12 14:40','U','2022-08-14 2:40',392204.5422,185165.5845);
--행 239
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7042,3380000,'3.38E+17',to_date('2016-03-10', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-757-7845','','부산광역시 수영구 수영로 602, 1층 (광안동)',48294,'알로하 동물병원','2016-03-10 14:36','I','2018-08-31 23:59',392534.7146,186505.3719);
--행 240
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7043,3380000,'3.38E+17',to_date('2017-05-22', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','','부산광역시 수영구 수영로702번길 18, 3층 (광안동)',48266,'클릭퍼피 동물병원','2017-05-22 16:18','I','2018-08-31 23:59',392764.4714,187347.8314);
--행 241
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7044,3380000,'3.38E+17',to_date('1989-10-05', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 수영구 남천동','부산광역시 수영구 황령대로 505, 1층 (남천동)',48313,'남천동물병원','2014-07-14 14:41','I','2018-08-31 23:59',392147.4103,184089.0357);
--행 242
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7045,3380000,'3.38E+17',to_date('2018-01-05', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','517444179','부산광역시 수영구 민락동 28-1번지 1층','부산광역시 수영구 광남로 258, 1층 (민락동)',48288,'박종현동물병원','2018-01-05 10:39','I','2018-08-31 23:59',393723.5924,186557.2603);
--행 243
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7046,3380000,'3.38E+17',to_date('2018-02-08', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-752-8883','부산광역시 수영구 망미동 430-3번지 1층','부산광역시 수영구 과정로 37, 1층 (망미동)',48210,'이랑동물병원','2018-02-08 11:39','I','2018-08-31 23:59',391916.3754,188188.477);
--행 244
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7047,3380000,'3.38E+17',to_date('2018-04-12', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','516252345','부산광역시 수영구 남천동 69-20','부산광역시 수영구 수영로 405-1, 2-4층 (남천동)',48316,'더프라임동물의료원','2023-02-10 16:51','U','2023-02-12 2:40',392056.8066,184646.2066);
--행 245
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7048,3380000,'3.38E+17',to_date('1995-05-08', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 수영구 광안동','부산광역시 수영구 수영로 567, 2층 (광안동)',48260,'광안동물병원','2014-10-31 15:11','I','2018-08-31 23:59',392434.2976,186192.5508);
--행 246
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7049,3380000,'3.38E+17',to_date('1996-05-20', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-759-0225','부산광역시 수영구 수영동','부산광역시 수영구 수영로 757, 2층 (수영동)',48222,'이상동물병원','2014-12-24 11:16','I','2018-08-31 23:59',393259.403,187424.4945);
--행 247
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7050,3380000,'3.38E+17',to_date('1998-04-30', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-628-8211','부산광역시 수영구 남천동 47-1번지 화목아파트 6동 2호','부산광역시 수영구 수영로 485, 6동 2호 (남천동, 화목아파트)',48265,'소망애견종합병원','2013-07-01 9:46','I','2018-08-31 23:59',392232.2151,185358.9658);
--행 248
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7051,3380000,'3.38E+17',to_date('2004-02-04', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 수영구 망미동 777번지 45통1반 삼성아파트 7동 1107호','부산광역시 수영구 과정로15번길 7 (망미동, 국화)',48211,'세진동물병원','2015-12-04 10:44','I','2018-08-31 23:59',391420.713,187567.309);
--행 249
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7052,3380000,'3.38E+17',to_date('2004-11-25', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 수영구 수영동 76-1번지 16통5반 백제삼정데파트 1401호','부산광역시 수영구 수영로 733 (수영동)',48223,'사랑동물병원','2015-12-04 10:41','I','2018-08-31 23:59',393045.4707,187552.7454);
--행 250
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7053,3380000,'3.38E+17',to_date('2006-07-27', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','753-8875','부산광역시 수영구 망미동 963-21번지','부산광역시 수영구 연수로 241 (망미동)',48207,'연제종합동물병원','2013-07-31 9:44','I','2018-08-31 23:59',390998.5338,188044.1321);
--행 251
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7054,3380000,'3.38E+17',to_date('2007-02-15', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-754-3270','부산광역시 수영구 망미동 837-4번지 19통5반','부산광역시 수영구 연수로 235 (망미동)',48207,'삼성동물병원','2013-12-30 13:32','I','2018-08-31 23:59',390929.9312,188050.5082);
--행 252
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7055,3380000,'3.38E+17',to_date('2012-02-21', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-761-2502','부산광역시 수영구 광안동 117-10번지','부산광역시 수영구 수영로 618-1 (광안동)',48291,'ABC동물병원','2012-02-21 13:51','I','2018-08-31 23:59',392549.0995,186685.2639);
--행 253
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7056,3380000,'3.38E+17',to_date('2014-06-30', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','517578529','','부산광역시 수영구 광남로 207 (광안동)',48303,'민락동물병원','2015-08-06 13:45','I','2018-08-31 23:59',393248.5105,186475.2907);
--행 254
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7196,3290000,'3.29E+17',to_date('2020-04-13', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-818-5975','부산광역시 부산진구 전포동 667-16번지 이오스프라자','부산광역시 부산진구 서전로 25, 이오스프라자 201호 (전포동)',47247,'서면Q 외과 동물병원','2020-04-13 13:48','I','2020-04-15 0:23',387863.7161,186257.5075);
--행 255
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7202,3300000,'3.30E+17',to_date('2020-06-03', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','515142470','부산광역시 동래구 온천동 777-49번지','부산광역시 동래구 중앙대로1381번길 43, 2층 (온천동)',47728,'린동물병원','2020-06-03 11:31','I','2020-06-05 0:23',388925.1298,192172.8389);
--행 256
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7203,3320000,'3.32E+17',to_date('2020-04-08', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-342-5999','부산광역시 북구 만덕동 918-13번지','부산광역시 북구 만덕3로 55-1, 2층 (만덕동)',46563,'베이직 동물병원','2020-04-08 16:37','I','2020-04-10 0:23',384754.3119,192101.4961);
--행 257
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7209,3330000,'3.33E+17',to_date('2020-06-05', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-742-7585','부산광역시 해운대구 우동 1435-3 한일오르듀','부산광역시 해운대구 마린시티3로 37, 한일오르듀 207호 (우동)',48118,'마린숲 동물병원','2023-03-27 17:32','U','2023-03-29 2:40',395534.3219,186145.1302);
--행 258
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7241,3330000,'3.33E+17',to_date('2020-05-06', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-711-5999','부산광역시 해운대구 반여동 1441-85 다솜빌딩','부산광역시 해운대구 선수촌로 78, 다솜빌딩 2층 (반여동)',48037,'오션동물메디컬센터','2022-06-09 9:06','U','2022-06-11 2:40',392947.5294,191104.6491);
--행 259
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7248,3360000,'3.36E+17',to_date('2020-04-06', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 강서구 명지동 3357-2번지','부산광역시 강서구 명지국제8로 233, 2층 203호 (명지동)',46726,'홈즈 동물병원','2020-04-23 10:22','U','2020-04-25 2:40',374846.3635,179403.949);
--행 260
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7249,3390000,'3.39E+17',to_date('2020-06-09', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','517157979','부산광역시 사상구 주례동 191-17번지','부산광역시 사상구 가야대로 325 (주례동)',47004,'가나다 동물병원','2020-06-09 9:03','I','2020-06-11 0:23',382913.5352,185404.72);
--행 261
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7293,3700000,'3.70E+17',to_date('2021-12-03', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-936-0075','울산광역시 남구 야음동 717-2','울산광역시 남구 중앙로28번길 2(야음동)',44755,'수정동물병원','2021-12-08 10:02','U','2021-12-10 2:40',410251.3404,227382.9986);
--행 262
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7304,3290000,'3.29E+17',to_date('2021-11-12', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-818-1101','부산광역시 부산진구 초읍동 203-17','부산광역시 부산진구 성지로 110-1(초읍동)',47115,'풍경동물병원','2021-11-12 9:20','I','2021-11-14 0:22',386858.3424,188687.2409);
--행 263
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7326,3350000,'3.35E+17',to_date('2023-03-16', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-515-5179','부산광역시 금정구 장전동 615-6','부산광역시 금정구 식물원로 38, 1층 (장전동)',46297,'금빛동물병원','2023-03-16 8:58','I','2023-03-18 0:41',389697.6318,193741.7614);
--행 264
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7344,3380000,'3.38E+17',to_date('2023-02-07', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-753-2966','부산광역시 수영구 망미동 803-10','부산광역시 수영구 연수로 296(망미동)',48235,'베스트프렌드 동물병원','2023-02-21 16:42','U','2023-02-23 2:40',391527.4307,187966.6296);
--행 265
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7350,3350000,'3.35E+17',to_date('2023-03-21', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 금정구 장전동 607-37','부산광역시 금정구 식물원로 11, 2층 (장전동)',46301,'보담동물의료센터','2023-03-21 17:37','I','2023-03-23 0:41',389912.897,193614.5837);
--행 266
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7398,3330000,'3.33E+17',to_date('2001-04-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','703-6996','부산광역시 해운대구 좌동 1289-4번지 한솔빌딩','부산광역시 해운대구 좌동순환로 178, 2층 (좌동)',48078,'신도시동물병원','2012-03-26 15:36','I','2018-08-31 23:59',398114.7254,188646.7314);
--행 267
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7399,3330000,'3.33E+17',to_date('2001-07-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','784-1235','부산광역시 해운대구 반여동 1291-1346번지','부산광역시 해운대구 해운대로61번길 104 (반여동)',48051,'푸른동물병원','2019-03-27 17:07','U','2019-03-29 2:40',393889.3996,190459.9555);
--행 268
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7400,3330000,'3.33E+17',to_date('1995-03-22', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','784-0079','부산광역시 해운대구 재송동 1059-3번지','부산광역시 해운대구 재반로 117-1, 2층 (재송동)',48054,'재송동물병원','2013-12-26 9:31','I','2018-08-31 23:59',393617.9119,189822.8846);
--행 269
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7401,3330000,'3.33E+17',to_date('1996-11-29', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','704-7540','부산광역시 해운대구 좌동 1327-5번지 10통송강빌딩','부산광역시 해운대구 좌동순환로 308, 3층 (좌동)',48110,'성심동물병원','2012-01-10 16:25','I','2018-08-31 23:59',398779.0602,187679.4036);
--행 270
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7402,3330000,'3.33E+17',to_date('1999-01-22', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','704-7582','부산광역시 해운대구 우동 641-7번지','부산광역시 해운대구 해운대로 580, 4층 (우동)',48094,'김준완 동물의료센터','2019-03-06 19:43','U','2019-03-08 2:40',396290.775,186797.7446);
--행 271
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7403,3330000,'3.33E+17',to_date('2003-02-25', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','545-0041','부산광역시 해운대구 반송동 257-248번지','부산광역시 해운대구 아랫반송로 11-1 (반송동)',48017,'반송동물병원','2019-03-04 15:50','U','2019-03-06 2:40',395445.9279,193925.8128);
--행 272
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7404,3300000,'3.30E+17',to_date('2014-05-12', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','515540010','부산광역시 동래구 명륜동 676-112번지','부산광역시 동래구 명륜로 194, 1층 (명륜동)',47747,'훈 동물병원','2019-11-19 12:51','U','2019-11-21 2:40',389597.477,192179.4203);
--행 273
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7405,3300000,'3.30E+17',to_date('2016-03-08', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-555-4813','부산광역시 동래구 수안동 568번지','부산광역시 동래구 명륜로 90 (수안동, 호원메디컬)',47814,'유성준동물병원','2019-01-17 10:30','U','2019-01-19 2:40',389730.5437,191213.3798);
--행 274
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7406,3300000,'3.30E+17',to_date('2016-10-28', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-505-4088','부산광역시 동래구 온천동 1266-4번지','부산광역시 동래구 아시아드대로 207 (온천동)',47852,'온천동물병원','2019-01-17 10:31','U','2019-01-19 2:40',388057.9041,191229.0182);
--행 275
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7407,3300000,'3.30E+17',to_date('2018-05-31', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-982-2580','부산광역시 동래구 사직동 64-24번지 1,2층','부산광역시 동래구 아시아드대로 160, 1,2층 (사직동)',47842,'노블동물병원','2018-05-31 11:51','I','2018-08-31 23:59',388037.5021,190778.6013);
--행 276
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7408,3300000,'3.30E+17',to_date('1992-01-14', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','504-1813','부산광역시 동래구 사직동 28-15번지','부산광역시 동래구 사직북로63번길 11 (사직동)',47860,'사직삼보동물병원','2019-03-28 11:35','U','2019-03-30 2:40',387322.6727,190886.3262);
--행 277
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7409,3300000,'3.30E+17',to_date('1998-01-13', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','555-8300','부산광역시 동래구 명륜동 429-17번지','부산광역시 동래구 명륜로98번길 1 (명륜동)',47814,'한사랑동물병원','2016-05-23 17:56','I','2018-08-31 23:59',389677.7442,191267.8055);
--행 278
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7410,3300000,'3.30E+17',to_date('1998-02-26', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','552-3003','부산광역시 동래구 명륜동 627-4번지','부산광역시 동래구 충렬대로237번길 148 (명륜동)',47809,'동양축산병원','2019-01-17 10:32','U','2019-01-19 2:40',389560.473,191788.2264);
--행 279
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7411,3300000,'3.30E+17',to_date('2006-06-15', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','525-1275','부산광역시 동래구 안락동 469-8번지','부산광역시 동래구 명장로 150 (안락동)',47794,'초원동물병원','2016-05-23 17:59','I','2018-08-31 23:59',392296.4456,190840.0906);
--행 280
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7412,3300000,'3.30E+17',to_date('2012-07-10', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','524-8275','부산광역시 동래구 안락동 946-7번지','부산광역시 동래구 반송로 243 (안락동)',47754,'레알피부전문동물병원','2020-02-20 10:49','U','2020-02-22 2:40',391075.3324,191261.0795);
--행 281
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7413,3300000,'3.30E+17',to_date('2012-07-27', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-531-7582','부산광역시 동래구 안락동 64-1번지','부산광역시 동래구 충렬대로 488 (안락동)',47905,'바른동물병원','2016-05-23 18:02','I','2018-08-31 23:59',392221.1881,190383.5461);
--행 282
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7414,3300000,'3.30E+17',to_date('2013-04-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','555-2119','부산광역시 동래구 수안동 4-17','부산광역시 동래구 명륜로 65, 1층 (수안동)',47818,'뉴욕동물병원','2021-10-13 16:07','U','2021-10-15 2:40',389735.5106,190957.4117);
--행 283
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7415,3300000,'3.30E+17',to_date('2008-02-22', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','506-7975','부산광역시 동래구 사직동 42-1번지','부산광역시 동래구 사직로70번길 50 (사직동)',47864,'자연동물병원','2012-08-02 15:51','I','2018-08-31 23:59',387331.3603,190631.6142);
--행 284
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7416,3300000,'3.30E+17',to_date('2012-03-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 동래구 온천동 402-21번지 22통4반 105호','부산광역시 동래구 금강로 69, 105호 (온천동)',47706,'동래종합동물병원','2019-03-13 17:43','U','2019-03-15 2:40',389072.9541,192669.6585);
--행 285
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7417,3300000,'3.30E+17',to_date('2014-04-04', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-557-7577','부산광역시 동래구 복천동 177-2번지','부산광역시 동래구 동래로147번길 6 (복천동)',47802,'학산동물병원','2017-10-12 17:31','I','2018-08-31 23:59',389989.7061,191486.2968);
--행 286
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7418,3300000,'3.30E+17',to_date('2014-05-01', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-506-8875','부산광역시 동래구 온천동 1440-1','부산광역시 동래구 충렬대로 160, 1층 (온천동)',47824,'스카이동물병원','2020-06-29 15:51','U','2020-07-01 2:40',389112.3373,191433.4406);
--행 287
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7419,3300000,'3.30E+17',to_date('1982-11-29', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','555-4130','부산광역시 동래구 낙민동 288-58번지','부산광역시 동래구 충렬대로 268-1 (낙민동)',47878,'재생동물병원','2019-01-17 10:33','U','2019-01-19 2:40',390130.9977,191048.9997);
--행 288
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7420,3300000,'3.30E+17',to_date('1990-07-07', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-556-8747','부산광역시 동래구 안락동 756-57번지','부산광역시 동래구 안연로98번길 4 (안락동)',47894,'안락동물병원','2019-01-17 10:33','U','2019-01-19 2:40',391004.4886,190526.7084);
--행 289
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7421,3300000,'3.30E+17',to_date('1991-06-07', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','553-4409','부산광역시 동래구 온천동 170-2번지','부산광역시 동래구 금강공원로 11-1 (온천동)',47711,'류태현동물병원','2019-01-17 10:34','U','2019-01-19 2:40',389584.1651,193008.3248);
--행 290
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7422,3300000,'3.30E+17',to_date('1991-09-03', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','527-8742','부산광역시 동래구 명장동 29-4번지','부산광역시 동래구 반송로 265 (명장동)',47752,'한양종합동물병원','2019-01-17 10:35','U','2019-01-19 2:40',391225.7738,191419.5697);
--행 291
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7578,3730000,'3.73E+17',to_date('2004-12-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','248-7582','울산광역시 울주군 범서읍 천상리 639-6','울산광역시 울주군 범서읍 천상중앙길 47, 더조은동물병원 1층',44931,'더조은동물병원','2021-08-03 10:52','U','2021-08-05 2:40',402223.2502,231600.8952);
--행 292
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7579,3730000,'3.73E+17',to_date('2006-01-04', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','264-7872','울산광역시 울주군 언양읍 서부리 232-1번지','울산광역시 울주군 언양읍 웃방천5길 14, 바동 104호 (서부상가)',44944,'원동물병원','2019-03-06 17:04','U','2019-03-08 2:40',391270.1869,231944.3553);
--행 293
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7580,3730000,'3.73E+17',to_date('2007-03-14', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-262-6114','울산광역시 울주군 삼남면 교동리 1499-264번지','울산광역시 울주군 삼남면 상평강변길 3',44947,'초록동물병원','2019-03-06 17:07','U','2019-03-08 2:40',392265.5738,231268.6629);
--행 294
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7581,3730000,'3.73E+17',to_date('2007-03-31', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-239-7585','울산광역시 울주군 온양읍 발리 1311번지 온양서희스타힐스','울산광역시 울주군 온양읍 보곡3길 40 (온양서희스타힐스)',44976,'온양 발리동물병원','2019-03-06 16:34','U','2019-03-08 2:40',408257.1255,214729.8141);
--행 295
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7582,3730000,'3.73E+17',to_date('2011-08-17', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','225-0075','울산광역시 울주군 언양읍 동부리 370-15번지','울산광역시 울주군 언양읍 읍성로 135',44938,'와우동물병원','2019-03-06 16:58','U','2019-03-08 2:40',392401.1956,232134.5749);
--행 296
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7583,3730000,'3.73E+17',to_date('2012-02-03', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','울산광역시 울주군 언양읍 서부리 265-2','울산광역시 울주군 언양읍 방천4길 19-9, 서울산 동물병원 1층 101호',44945,'서울산 동물병원','2021-04-12 21:36','U','2021-04-14 2:40',391580.374,231645.4986);
--행 297
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7584,3730000,'3.73E+17',to_date('2013-11-08', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-238-7511','울산광역시 울주군 온양읍 대안리 567-4','울산광역시 울주군 온양읍 대운길 12, 남창미르동물병원',44978,'남창미르동물병원','2023-02-27 17:15','U','2023-03-01 2:40',407047.4201,214885.5845);
--행 298
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7585,3730000,'3.73E+17',to_date('2014-04-09', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-211-7599','울산광역시 울주군 범서읍 구영리 386-1번지','울산광역시 울주군 범서읍 점촌6길 5',44925,'BB동물병원','2019-03-06 13:12','U','2019-03-08 2:40',403304.2445,232196.9548);
--행 299
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7586,3730000,'3.73E+17',to_date('2014-07-04', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','울산광역시 울주군 온산읍 덕신리 561번지','울산광역시 울주군 온산읍 덕신로 250',45005,'MK동물병원','2019-03-06 13:13','U','2019-03-08 2:40',409585.8342,217298.3277);
--행 300
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7587,3730000,'3.73E+17',to_date('1995-08-31', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','울산광역시 울주군 두동면 봉계리 925-2번지','울산광역시 울주군 두동면 구미월평로 787',44914,'언양동물병원','2019-10-17 15:46','U','2019-10-19 2:40',399694.1951,247100.8615);
--행 301
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7588,3730000,'3.73E+17',to_date('1983-07-15', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-262-4888','울산광역시 울주군 삼남면 교동리 355-7번지','울산광역시 울주군 삼남면 중평로 79',NULL,'제일동물병원','2019-03-06 17:05','U','2019-03-08 2:40',392264.0614,231197.4418);
--행 302
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7589,3730000,'3.73E+17',to_date('1996-04-01', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-262-6797','울산광역시 울주군 두동면 봉계리 525번지 봉계재래시장 203호','울산광역시 울주군 두동면 계명3길 9, 봉계재래시장 203호',44914,'벧엘동물병원','2019-03-06 16:10','U','2019-03-08 2:40',398939.8395,248151.2859);
--행 303
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7590,3730000,'3.73E+17',to_date('1976-01-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-262-1076','울산광역시 울주군 언양읍 동부리 133-3번지','울산광역시 울주군 언양읍 동부8길 19-6',44941,'대동동물병원','2019-03-06 13:26','U','2019-03-08 2:40',392734.5626,231524.1954);
--행 304
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7591,3730000,'3.73E+17',to_date('1997-07-31', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-264-6708','울산광역시 울주군 언양읍 서부리','울산광역시 울주군 언양읍 읍성로 20, 나동 1층',44946,'울산축협동물병원','2016-08-02 17:31','I','2018-08-31 23:59',391938.0204,231649.6757);
--행 305
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7592,3730000,'3.73E+17',to_date('1979-12-15', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','268-9074','울산광역시 울주군 청량읍 상남리 577-1번지','울산광역시 울주군 청량읍 덕하장터길 7',44984,'통일동물병원','2019-03-06 17:07','U','2019-03-08 2:40',409171.5224,223786.2137);
--행 306
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7593,3730000,'3.73E+17',to_date('2016-08-11', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','울산광역시 울주군 언양읍 태기리 693-7','울산광역시 울주군 언양읍 태기길 23-6',44935,'박동물병원','2022-12-30 16:56','U','2023-01-01 2:40',393590.5449,234262.7986);
--행 307
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7594,3730000,'3.73E+17',to_date('2017-04-24', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','울산광역시 울주군 삼남면 교동리 1555-1번지 울산 교동 리슈빌아파트 상가2층 202호','울산광역시 울주군 삼남면 향교로 164, 2층 202호 (울산 교동 리슈빌아파트)',44949,'중산동물병원','2019-03-06 17:06','U','2019-03-08 2:40',391566.8817,231231.8495);
--행 308
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7595,3730000,'3.73E+17',to_date('2017-07-03', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','울산광역시 울주군 삼남면 방기리 176-6번지','울산광역시 울주군 삼남면 하방로 27',44955,'박지호 동물병원','2019-03-06 15:48','U','2019-03-08 2:40',389524.6529,224884.2421);
--행 309
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7596,3730000,'3.73E+17',to_date('2018-01-22', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','울산광역시 울주군 삼남면 신화리 1481-29번지','울산광역시 울주군 삼남면 중남로 72, 3층',44953,'라인동물병원','2019-03-06 13:44','U','2019-03-08 2:40',391184.6147,228477.6967);
--행 310
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7643,3690000,'3.69E+17',to_date('2020-07-09', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-713-7575','울산광역시 중구 태화동 123-2','울산광역시 중구 태화로 250 (태화동)',44456,'리버동물의료센터','2020-07-12 18:00','U','2020-07-14 2:40',408742.38,230578.0873);
--행 311
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7648,3380000,'3.38E+17',to_date('2020-07-03', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-757-1275','부산광역시 수영구 민락동 774 센텀비스타동원2차 상가 401동 203호','부산광역시 수영구 무학로63번길 142, 401동 2층 203호 (민락동, 센텀비스타동원2차)',48272,'유어캣 고양이병원','2020-07-13 13:22','U','2020-07-15 2:40',393053.9747,187433.2652);
--행 312
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7674,3330000,'3.33E+17',to_date('2020-08-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-782-7275','부산광역시 해운대구 재송동 369-1','부산광역시 해운대구 해운대로177번길 6 (재송동)',48056,'박창언 동물병원','2020-09-14 17:15','U','2020-09-16 2:40',393347.123,189033.8418);
--행 313
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7698,3330000,'3.33E+17',to_date('2021-08-10', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-702-8275','부산광역시 해운대구 좌동 1486-1 봉황빌딩','부산광역시 해운대구 양운로 40, 봉황빌딩 301호 (좌동)',48111,'해운대동물메디컬센터','2021-08-31 12:40','U','2021-09-02 2:40',398342.925,187510.7976);
--행 314
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7699,3300000,'3.30E+17',to_date('2021-09-07', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-505-7578','부산광역시 동래구 온천동 1250-8 지영아이니드빌','부산광역시 동래구 아시아드대로 209, 2층 (온천동, 지영아이니드빌)',47851,'사직동물의료센터','2021-10-29 16:15','U','2021-10-31 2:40',388064.6091,191257.7432);
--행 315
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7700,3300000,'3.30E+17',to_date('2021-07-08', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-552-6800','부산광역시 동래구 온천동 180-14 온천장역삼정그린코아더시티','부산광역시 동래구 중앙대로1473번길 24, 온천장역삼정그린코아더시티 상가동 109~110호 (온천동)',47711,'온마음동물병원','2021-07-08 11:55','I','2021-07-10 0:22',389550.0051,192966.7933);
--행 316
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7716,3360000,'3.36E+17',to_date('2021-08-17', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-972-0972','부산광역시 강서구 신호동 304-9','부산광역시 강서구 신호산단1로 124, 103호 (신호동)',46760,'신호동물병원','2021-08-17 18:39','I','2021-08-19 0:22',371138.9765,177398.8558);
--행 317
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7741,3310000,'3.31E+17',to_date('2021-09-01', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','517117515','부산광역시 남구 대연동 29-1','부산광역시 남구 수영로 364, 4층 (대연동)',48509,'더본 외과동물의료센터','2022-03-22 10:08','U','2022-03-24 2:40',391808.9157,184281.9547);
--행 318
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7779,3300000,'3.30E+17',to_date('2022-12-28', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-513-6060','부산광역시 동래구 온천동 456-29 신화타워아파트','부산광역시 동래구 온천장로 20, 1층 (온천동, 신화타워아파트)',47714,'24시 더휴동물의료센터','2023-03-30 16:17','U','2023-04-01 2:40',389289.7675,192509.9942);
--행 319
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7780,3260000,'3.26E+17',to_date('2022-12-06', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-710-0719','부산광역시 서구 암남동 123-15 송도힐스테이트이진베이시티아파트','부산광역시 서구 송도해변로 192, 상가B동 2층 201호 (암남동, 송도힐스테이트이진베이시티아파트)',49264,'베이시티 동물병원','2022-12-06 10:02','I','2022-12-08 0:40',384495.0667,177326.0295);
--행 320
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7806,3330000,'3.33E+17',to_date('2021-06-25', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 해운대구 우동 1488 대우월드마크센텀아파트','부산광역시 해운대구 센텀동로 25, B상가동 203호 (우동, 대우월드마크센텀아파트)',48059,'아이케어 동물병원','2022-02-18 9:38','U','2022-02-20 2:40',394112.5249,187887.9317);
--행 321
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (7856,3320000,'3.32E+17',to_date('2021-06-08', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-908-7575','부산광역시 북구 덕천동 561-2 채움센트럴','부산광역시 북구 금곡대로 126, 채움센트럴 3층 (덕천동)',46545,'동행동물의료센터','2021-06-08 19:45','I','2021-06-10 0:22',382766.7643,193052.6885);
--행 322
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8480,3320000,'3.32E+17',to_date('2018-09-20', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-333-7584','부산광역시 북구 화명동 2277-4번지 삼한골든뷰','부산광역시 북구 금곡대로 287, 삼한골든뷰 2층 202,203호 (화명동)',46526,'원 동물병원','2019-03-27 14:50','U','2019-03-29 2:40',383206.814,194624.5038);
--행 323
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8499,3290000,'3.29E+17',to_date('2020-09-09', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-808-5550','부산광역시 부산진구 초읍동 263-36','부산광역시 부산진구 새싹로 218 (초읍동)',47127,'더원동물의료센터','2020-09-09 14:35','I','2020-09-11 0:23',386576.1236,188193.2817);
--행 324
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8500,3720000,'3.72E+17',to_date('2020-09-07', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','052-713-7582','울산광역시 북구 송정동 1235-4','울산광역시 북구 박상진11로 1, 203,204,205호 (송정동)',44236,'잘하는 동물메디컬센터','2022-01-03 16:32','U','2022-01-05 2:40',414148.3858,235960.4524);
--행 325
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8508,3380000,'3.38E+17',to_date('2020-10-06', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-753-7582','부산광역시 수영구 민락동 110-82 3층','부산광역시 수영구 광안해변로370번길 9-8, 블루오션 3층 (민락동)',48280,'오리진 동물피부과병원','2020-10-06 19:35','I','2020-10-08 0:23',394369.8731,186131.0946);
--행 326
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8513,3290000,'3.29E+17',to_date('2020-10-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','518065000','부산광역시 부산진구 부암동 318-76 협성휴포레시티즌파크아파트','부산광역시 부산진구 동평로 173, 207,208호 (부암동, 협성휴포레시티즌파크아파트)',47141,'대디동물병원','2020-10-19 10:02','I','2020-10-21 0:23',386480.1877,187219.3063);
--행 327
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8518,3270000,'3.27E+17',to_date('2020-10-29', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-638-9977','부산광역시 동구 범일동 325-3','부산광역시 동구 범일로 64(범일동)',48747,'구구동물병원','2022-06-08 10:18','U','2022-06-10 2:40',387652.2424,183763.9158);
--행 328
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8523,3350000,'3.35E+17',to_date('2020-11-03', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-515-7272','부산광역시 금정구 구서동 471-8','부산광역시 금정구 금강로403번길 1, 2층 (구서동)',46245,'웰동물병원','2020-11-03 16:15','I','2020-11-05 0:23',389908.8959,195823.1149);
--행 329
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8549,3300000,'3.30E+17',to_date('2022-10-14', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-531-8275','부산광역시 동래구 안락동 633-4 동림빌딩','부산광역시 동래구 안연로 72, 동림빌딩 1층 (안락동)',47901,'온정동물병원','2022-10-25 13:58','U','2022-10-27 2:40',391100.1762,190292.6509);
--행 330
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8568,3320000,'3.32E+17',to_date('2022-09-05', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-714-5251','부산광역시 북구 화명동 190-2 대진빌딩','부산광역시 북구 금곡대로 366, 대진빌딩 1층 (화명동)',46517,'허그동물의료센터','2022-09-05 16:23','I','2022-09-07 0:22',383283.3027,195388.5103);
--행 331
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8580,3330000,'3.33E+17',to_date('2021-04-12', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 해운대구 반여동 1190-1 우방신세계아파트','부산광역시 해운대구 삼어로 61, 201호 (반여동, 우방신세계아파트)',48046,'행복드림 동물병원','2021-09-24 19:07','U','2021-09-26 2:40',392600.0999,191419.5175);
--행 332
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8586,3400000,'3.40E+17',to_date('2021-02-18', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','517217975','부산광역시 기장군 일광면 삼성리 830-8 스타타워Ⅱ, 301,302호','부산광역시 기장군 일광면 해빛6로 85-4, 스타타워Ⅱ 3층 301,302호',46048,'일광해빛동물병원','2021-02-18 9:01','I','2021-02-20 0:23',402594.2917,198486.9329);
--행 333
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8595,3290000,'3.29E+17',to_date('2021-03-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-819-6061','부산광역시 부산진구 전포동 876-7','부산광역시 부산진구 동성로 152 (전포동)',47241,'24시 온동물의료센터','2022-11-09 13:26','U','2022-11-11 2:40',387881.1591,186682.8442);
--행 334
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8602,3300000,'3.30E+17',to_date('2021-03-23', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-555-1125','부산광역시 동래구 낙민동 205-12','부산광역시 동래구 충렬대로 288 (낙민동)',47879,'헤아림동물병원','2021-03-23 13:17','I','2021-03-25 0:22',390306.7341,190985.686);
--행 335
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8606,3330000,'3.33E+17',to_date('2021-02-10', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-747-1275','부산광역시 해운대구 중동 942-6','부산광역시 해운대구 달맞이길 58, 2층 (중동)',48097,'리안 동물병원','2021-11-18 10:38','U','2021-11-20 2:40',397748.0983,186818.8506);
--행 336
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8620,3300000,'3.30E+17',to_date('2021-03-31', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-711-0006','부산광역시 동래구 명륜동 506-13 동림빌딩','부산광역시 동래구 충렬대로 194, 동림빌딩 2층 (명륜동)',47815,'24시 리본동물의료센터','2023-02-15 13:42','U','2023-02-18 2:40',389439.9718,191276.3279);
--행 337
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8623,3400000,'3.40E+17',to_date('2021-03-26', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','517247570','부산광역시 기장군 일광면 삼성리 825-2 일광제일프라자, 2층 203호','부산광역시 기장군 일광면 해빛로 13, 일광제일프라자 2층 203호',46048,'바른진료 동물병원','2021-03-26 9:26','I','2021-03-28 0:22',402521.1775,198590.0505);
--행 338
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (8630,3300000,'3.30E+17',to_date('2021-03-31', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-711-0006','부산광역시 동래구 명륜동 506-13 동림빌딩','부산광역시 동래구 충렬대로 194, 동림빌딩 3층 (명륜동)',47815,'24시 리본동물영상센터','2023-02-15 13:12','U','2023-02-18 2:40',389439.9718,191276.3279);
--행 339
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (9097,3360000,'3.36E+17',to_date('2022-07-08', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','','부산광역시 강서구 명지동 3597-5','부산광역시 강서구 명지국제2로 29, 203호 (명지동)',46726,'명지 수동물병원','2022-07-11 9:28','U','2022-07-13 2:40',373808.7564,178891.0303);
--행 340
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (9099,3340000,'3.34E+17',to_date('2022-07-06', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-717-2316','부산광역시 사하구 다대동 1548-47','부산광역시 사하구 다대로 700, 2층 (다대동)',49505,'더바른 동물병원','2022-07-14 16:58','U','2022-07-16 2:40',379207.7254,173951.8004);
--행 341
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (9113,3360000,'3.36E+17',to_date('2022-07-12', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-711-7581','부산광역시 강서구 명지동 3420-7','부산광역시 강서구 명지국제8로 270, 1동 202호 (명지동)',46772,'어울림동물메디컬센터','2022-07-12 14:26','I','2022-07-14 0:22',375192.2933,179291.2555);
--행 342
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (9550,3330000,'3.33E+17',to_date('2018-11-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-701-7588','부산광역시 해운대구 좌동 1479-3번지 세종월드프라자','부산광역시 해운대구 해운대로 814, 세종월드프라자 A동 301호 (좌동)',48111,'리더스동물병원','2019-11-18 15:01','U','2019-11-20 2:40',398330.5165,187771.5114);
--행 343
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (9569,3710000,'3.71E+17',to_date('2020-12-05', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','522327575','울산광역시 동구 일산동 945','울산광역시 동구 방어진순환도로 652, 테라스파크 301,302,304호 (일산동)',44056,'척척 동물의료센터','2021-07-14 14:45','U','2021-07-16 2:40',420356.2744,224949.0991);
--행 344
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (9578,3400000,'3.40E+17',to_date('2020-12-02', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-755-1175','부산광역시 기장군 기장읍 대라리 417-16','부산광역시 기장군 기장읍 차성로 286',46066,'배산 동물병원','2020-12-02 10:57','I','2020-12-04 0:23',401439.6919,195982.2579);
--행 345
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (9583,3330000,'3.33E+17',to_date('2021-01-21', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-751-7585','부산광역시 해운대구 우동 1405 마린파크','부산광역시 해운대구 마린시티2로 2, 마린파크 208~209호 (우동)',48092,'마린파크 동물병원','2023-02-15 16:14','U','2023-02-18 2:40',394304.2715,187325.7713);
--행 346
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (9600,3370000,'3.37E+17',to_date('2021-01-13', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-791-0175','부산광역시 연제구 연산동 1953-1','부산광역시 연제구 연수로 135 (연산동)',47603,'연산동물의료센터','2023-02-03 16:38','U','2023-02-05 2:40',389916.4819,188188.0447);
--행 347
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (9614,3340000,'3.34E+17',to_date('2022-04-29', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-714-2435','부산광역시 사하구 신평동 569-51','부산광역시 사하구 을숙도대로 713, 1층 (신평동)',49396,'행복한 동물병원','2022-05-11 18:47','U','2022-05-13 2:40',380804.6773,178043.9189);
--행 348
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (9647,3270000,'3.27E+17',to_date('2022-05-04', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-465-7582','부산광역시 동구 초량동 1145-9 신화하니엘 더시티 주건축물제1동','부산광역시 동구 고관로 48, 신화하니엘 더시티 주건축물제1동 103호 (초량동)',48792,'성경완 동물병원','2022-05-11 13:29','U','2022-05-13 2:40',386216.078,182410.0825);
--행 349
INSERT INTO HOSPITAL_DATA (HD_ID, HD_CODE, HD_MANAGE, HD_PERDATE, HD_STATUSCODE, HD_SATUSNAME, HD_DETAILCODE, HD_DETAILNAME, HD_TEL, HD_ADDRESS_GENERAL, HD_ADDRESS_ROAD, HD_ADDRESS_ROADNUM, HD_NAME, HD_ADIT_DATE, HD_ADIT_GUBUN, HD_ADIT_RESDATE, HD_LNG, HD_LAT) VALUES (9657,3340000,'3.34E+17',to_date('2022-05-19', 'YYYY-MM-DD'),1,'영업/정상',0,'정상','051-265-0114','부산광역시 사하구 장림동 325-67','부산광역시 사하구 장림번영로 41, 1층 (장림동)',49475,'모아동물병원','2022-12-30 16:16','U','2023-01-01 2:40',379594.3462,177529.7771);


--테이블 구조 확인
desc HOSPITAL_DATA;
commit;



------------
--병원정보
------------
CREATE TABLE hospital_info(
  H_NUM              NUMBER,         --순번
  HD_ID              NUMBER(4),      --동물병원 데이터번호
  H_ID               varchar2(20),   --병원회원 아이디
  H_NAME             varchar2(52),   --병원 상호명
  H_TEL              VARCHAR2(30),   --병원 연락처
  H_PLIST            varchar2(40),   --진료동물
  H_TIME             clob,           --진료시간
  H_INFO             varchar2(60),   --편의시설정보
  H_ADDINFO          varchar2(60),   --병원기타정보
  H_IMG              BLOB,           --병원이미지
  H_CREATE_DATE       timestamp default systimestamp,         --생성일시
  H_UPDATE            timestamp default systimestamp          --수정일시
);
--기본키생성
alter table HOSPITAL_INFO add Constraint HOSPITAL_INFO_H_NUM_pk primary key (H_NUM);
--외래키
alter table HOSPITAL_INFO add constraint  HOSPITAL_INFO_H_ID_fk
    foreign key(H_ID) references hmember(H_ID);
alter table HOSPITAL_INFO add constraint  HOSPITAL_INFO_HD_ID_fk
    foreign key(HD_ID) references hospital_data(HD_ID);

--제약조건
alter table HOSPITAL_INFO modify H_ID constraint HOSPITAL_INFO_H_ID_nn not null;
alter table HOSPITAL_INFO modify H_NAME constraint HOSPITAL_INFO_H_NAME_nn not null;
alter table HOSPITAL_INFO modify H_CREATE_DATE constraint HOSPITAL_INFO_H_CREATE_DATE_nn not null;
-- not null 제약조건은 add 대신 modify 명령문 사용

--시퀀스 생성
create sequence HOSPITAL_INFO_H_NUM_seq;

--------  아래 샘플데이터 생성 전에 hospital_data 샘플데이터 먼저 생성해야함!!!!  ----------
--샘플데이터 of hospital_info
insert into hospital_info (H_NUM , HD_ID, H_ID, H_NAME, H_TEL, H_PLIST, H_TIME, H_INFO, H_ADDINFO)
    values(
    hospital_info_h_num_seq.nextval, 
    5400, 
    'htest1', 
    '메이 동물병원', 
    '211-3375', 
    '강아지, 고양이', 
    '월요일	오전 9:30~오후 7:00
    화요일	오전 9:30~오후 7:00
    수요일
    (식목일)
    오전 9:30~오후 7:00
    시간이 달라질 수 있음
    목요일	오전 9:30~오후 7:00
    금요일	오전 9:30~오후 7:00
    토요일	오전 9:30~오후 4:00
    일요일	휴무일', 
    '주차, 무선 인터넷, 반려동물 동반',
    '강아지, 고양이 전문 병원입니다!'
    );


COMMIT;
--테이블 구조 확인
DESC HOSPITAL_INFO;

------------
--반려동물 정보
------------
CREATE TABLE PET_INFO(
  PET_NUM            NUMBER,         --순번
  USER_ID            varchar2(20),   --일반회원 아이디
  PET_IMG            BLOB,           --반려동물 사진
  PET_NAME           varchar2(40),   --반려동물 이름
  PET_TYPE           VARCHAR2(20),   --반려동물 품종
  PET_GENDER         CHAR(1) default 'M',   --반려동물 성별(남: M, 여: F)
  PET_BIRTH          DATE,           --반려동물 생일
  PET_YN             CHAR(1) default 'N',       --중성화 여부(완료: Y, 미완료: N)
  PET_DATE           DATE,           --입양일
  PET_VAC            VARCHAR2(15) default 'p0101',   
  --기초접종 여부(미접종(P0101), 접종 전(P0102), 접종 중(P0103), 접종 완료(P0104))
  PET_INFO           VARCHAR2(60)    --기타사항
);
--기본키생성
alter table PET_INFO add Constraint PET_INFO_PET_NUM_pk primary key (PET_NUM);
--외래키
alter table PET_INFO add constraint  PET_INFO_USER_ID_fk
    foreign key(USER_ID) references member(USER_ID);
alter table PET_INFO add constraint  PET_INFO_PET_VAC_fk
    foreign key(PET_VAC) references  code(code_id);

--제약조건
alter table PET_INFO modify USER_ID constraint PET_INFO_USER_ID_nn not null;
alter table PET_INFO modify PET_NAME constraint PET_INFO_PET_NAME_nn not null;
alter table PET_INFO modify PET_VAC constraint PET_INFO_PET_VAC_nn not null;
alter table PET_INFO modify PET_GENDER constraint PET_INFO_PET_GENDER_nn not null;

alter table PET_INFO add constraint PET_INFO_PET_YN_ck check(PET_YN in ('Y','N'));
alter table PET_INFO add constraint PET_INFO_PET_GENDER_ck check(PET_GENDER in ('M','F'));
-- not null 제약조건은 add 대신 modify 명령문 사용

--시퀀스 생성
create sequence PET_INFO_PET_NUM_seq;

--테이블 구조 확인
DESC PET_INFO;

--샘플데이터 of PET_INFO
insert into PET_INFO (PET_NUM , USER_ID, PET_NAME, PET_TYPE, PET_GENDER, PET_BIRTH, PET_YN, PET_DATE, PET_VAC)
    values(
    PET_INFO_PET_NUM_seq.nextval, 
    'test1', 
    '반려동물1', 
    '강아지', 
    'F', 
    '2022-01-01', 
    'Y', 
    '2022-03-01', 
    'P0104'
    );

COMMIT;


------------
--의료수첩
------------
CREATE TABLE PET_NOTE(
  NOTE_NUM            NUMBER,         --순번
  USER_ID            varchar2(20),   --일반회원 아이디
  PET_NAME           varchar2(40),   --반려동물 이름
  PET_IMG            BLOB,           --반려동물 사진
  PET_TYPE           VARCHAR2(20),   --반려동물 품종
  PET_GENDER         CHAR(1) default 'M',   --반려동물 성별(남: M, 여: F)
  PET_BIRTH          DATE,           --반려동물 생일
  PET_YN             CHAR(1),        --중성화 여부(완료: Y, 미완료: N)
  PET_INFO           varchar2(60),   --기타사항
  PET_WEIG           number,         --반려동물 몸무게
  PET_H_CHECK        DATE,           --병원 방문날짜
  PET_H_NAME         VARCHAR2(52),   --방문한 병원이름
  PET_H_TEACHER       VARCHAR2(10),   --담당수의사
  PET_REASON         VARCHAR2(60),  --병원내방이유
  PET_STMP           VARCHAR2(60),  --동물 증상
  PET_SIGNICE        VARCHAR2(60),  --유의사항
  PET_NEXTDATE       DATE,           --다음 예약일
  PET_VAC            VARCHAR2(15) default 'p0101',   
  --기초접종 여부(미접종(P0101), 접종 전(P0102), 접종 중(P0103), 접종 완료(P0104))
  PET_DATE           VARCHAR2(15),  --작성 날짜(캘린더 선택날짜)
  PET_EDITDATE       VARCHAR2(15)   --수정 날짜
);
--기본키생성
alter table PET_NOTE add Constraint PET_NOTE_NOTE_NUM_pk primary key (NOTE_NUM);
--외래키
alter table PET_NOTE add constraint  PET_NOTE_USER_ID_fk
    foreign key(USER_ID) references member(USER_ID);
alter table PET_NOTE add constraint  PET_NOTE_PET_VAC_fk
    foreign key(PET_VAC) references  code(code_id);

--제약조건
alter table PET_NOTE modify USER_ID constraint PET_NOTE_USER_ID_nn not null;
alter table PET_NOTE modify PET_H_CHECK constraint PET_NOTE_PET_H_CHECK_nn not null;
alter table PET_NOTE modify PET_NAME constraint PET_NOTE_PET_NAME_nn not null;
alter table PET_NOTE modify PET_DATE constraint PET_NOTE_PET_DATE_nn not null;
alter table PET_NOTE modify PET_EDITDATE constraint PET_NOTE_PET_EDITDATE_nn not null;
alter table PET_NOTE add constraint PET_NOTE_PET_YN_ck check(PET_YN in ('Y','N'));
alter table PET_NOTE add constraint PET_NOTE_PET_GENDER_ck check(PET_GENDER in ('M','F'));
-- not null 제약조건은 add 대신 modify 명령문 사용

--시퀀스 생성
create sequence PET_NOTE_NOTE_NUM_seq;

--샘플데이터 of PET_NOTE 
insert into PET_NOTE (
    NOTE_NUM , USER_ID, PET_NAME, PET_TYPE, PET_GENDER, PET_BIRTH, PET_YN, PET_WEIG, PET_H_CHECK, 
    PET_H_NAME, PET_H_TEACHER, PET_REASON, PET_STMP, PET_SIGNICE,PET_DATE, PET_NEXTDATE, PET_VAC, PET_EDITDATE)
    values(
    PET_NOTE_NOTE_NUM_seq.nextval, 
    'test1', 
    '반려동물1', 
    '강아지', 
    'F', 
    '2022-01-01', 
    'Y', 
    4,
    '2023-03-02',
    '메이 동물병원',
    '홍길동',
    '정기검진',
    '안구건조증',
    '수분섭취를 신경써야함',
    '2023-04-01',
    '2023-04-01',
    'P0104',
    '2023-04-03'
    );
COMMIT;
--테이블 구조 확인
DESC PET_NOTE;

------------
--게시판: 병원후기
------------
CREATE TABLE BBSH(
  BBSH_ID            NUMBER,          --게시글 번호(순번)
  BH_TITLE           varchar2(150),   --글 제목
  BH_CONTENT         clob,            --글 내용
  PET_TYPE           varchar2(20),    --반려동물 품종
  BH_ATTACH          BLOB,            --첨부파일
  BH_HNAME           VARCHAR2(52),    --병원이름
  BH_HIT             NUMBER default 0,--조회수
  BH_GUBUN           VARCHAR2(15) default 'B0101',      --게시판 구분(병원후기: B0101, 커뮤니티: B0102)
  USER_NICK          varchar2(30),    --일반회원 닉네임
  BH_CDATE           timestamp default systimestamp,   --작성일
  BH_UDATE           timestamp default systimestamp    --수정일 
);
--기본키생성
alter table BBSH add Constraint BBSH_BBSH_ID_pk primary key (BBSH_ID);
--외래키
alter table BBSH add constraint  BBSH_BH_GUBUN_fk
    foreign key(BH_GUBUN) references  code(code_id);

--제약조건
alter table BBSH modify BH_TITLE constraint BBSH_BH_TITLE_nn not null;
alter table BBSH modify BH_CONTENT constraint BBSH_BH_CONTENT_nn not null;
alter table BBSH modify USER_NICK constraint BBSH_USER_NICK_nn not null;
alter table BBSH modify BH_HIT constraint BBSH_BH_HIT_nn not null;
-- not null 제약조건은 add 대신 modify 명령문 사용


--시퀀스 생성
create sequence BBSH_BBSH_ID_seq;

--샘플데이터 of BBSH
insert into BBSH (BBSH_ID , BH_TITLE, BH_CONTENT, PET_TYPE, BH_HNAME, BH_GUBUN, USER_NICK)
    values(BBSH_BBSH_ID_seq.nextval, '병원후기제목1', '병원후기본문1', '고양이', '메이 동물병원', 'B0101','별칭1');

COMMIT;

--테이블 구조 확인
DESC BBSH;

------------
--댓글: 병원후기
------------
CREATE TABLE C_BBSH(
  HC_ID              NUMBER,          --댓글 번호(순번)
  BBSH_ID            NUMBER,          --게시글 번호
  HC_CONTENT         varchar2(1500),  --댓글 내용
  USER_NICK          varchar2(30),    --일반회원 닉네임
  BH_CDATE           timestamp default systimestamp,   --작성일
  BH_UDATE           timestamp default systimestamp    --수정일 
);
--기본키생성
alter table C_BBSH add Constraint C_BBSH_HC_ID_pk primary key (HC_ID);
--외래키
alter table C_BBSH add constraint  C_BBSH_BBSH_ID_fk
    foreign key(BBSH_ID) references BBSH(BBSH_ID);

--제약조건
alter table C_BBSH modify BBSH_ID constraint C_BBSH_BBSH_ID_nn not null;
alter table C_BBSH modify HC_CONTENT constraint C_BBSH_HC_CONTENT_nn not null;
alter table C_BBSH modify USER_NICK constraint C_BBSH_USER_NICK_nn not null;
-- not null 제약조건은 add 대신 modify 명령문 사용

--시퀀스 생성
create sequence C_BBSH_HC_ID_SEQ;

--샘플데이터 of C_BBSH
insert into C_BBSH (HC_ID, BBSH_ID , HC_CONTENT, USER_NICK) values(C_BBSH_HC_ID_SEQ.nextval, 1,'병원후기댓글1', '별칭1');

COMMIT;

--테이블 구조 확인
DESC C_BBSH;

------------
--게시판: 커뮤니티
------------
CREATE TABLE BBSC(
  BBSC_ID            NUMBER,              --게시글 번호(순번)
  BC_TITLE           varchar2(150),       --글 제목
  BC_CONTENT         clob,                --글 내용
  PET_TYPE           varchar2(20),        --반려동물 품종
  BC_ATTACH          BLOB,                --첨부파일
  BC_HIT             NUMBER  default 0,   --조회수
  BC_LIKE            NUMBER  default 0,   --좋아요수
  BC_PUBLIC          CHAR(1) default 'N', --게시글 공개여부(공개: Y, 비공개: N)
  BC_GUBUN           VARCHAR2(15) default 'B0102',      --게시판 구분(병원후기: B0101, 커뮤니티: B0102)
  USER_NICK          varchar2(30),        --일반회원 닉네임
  BC_CDATE           timestamp default systimestamp,   --작성일
  BC_UDATE           timestamp default systimestamp    --수정일 
);
--기본키생성
alter table BBSC add Constraint BBSC_BBSC_ID_pk primary key (BBSC_ID);
--외래키
alter table BBSC add constraint  BBSC_BC_GUBUN_fk
    foreign key(BC_GUBUN) references code(code_id);
    
--제약조건
alter table BBSC modify BC_TITLE constraint BBSC_BC_TITLE_nn not null;
alter table BBSC modify BC_CONTENT constraint BBSC_BC_CONTENT_nn not null;
alter table BBSC modify BC_HIT constraint BBSC_BC_HIT_nn not null;
alter table BBSC modify BC_LIKE constraint BBSC_BC_LIKE_nn not null;
alter table BBSC modify BC_PUBLIC constraint BBSC_BC_PUBLIC_nn not null;
alter table BBSC modify USER_NICK constraint BBSC_USER_NICK_nn not null;
-- not null 제약조건은 add 대신 modify 명령문 사용

--시퀀스 생성
create sequence BBSC_BBSC_ID_seq;

--샘플데이터 of BBSC
insert into BBSC (BBSC_ID , BC_TITLE, BC_CONTENT, PET_TYPE, BC_PUBLIC, BC_GUBUN, USER_NICK)
    values(BBSC_BBSC_ID_seq.nextval, '커뮤니티제목1', '커뮤니티본문1', '고양이', 'N', 'B0102', '별칭1');

COMMIT;

--테이블 구조 확인
DESC BBSC;

------------
--댓글: 커뮤니티
------------
CREATE TABLE C_BBSC(
  CC_ID              NUMBER,          --댓글 번호(순번)
  BBSC_ID            NUMBER,          --게시글 번호
  CC_CONTENT         varchar2(1500),  --댓글 내용
  USER_NICK          varchar2(30),    --일반회원 닉네임
  CC_CDATE           timestamp default systimestamp,   --작성일
  CC_UDATE           timestamp default systimestamp    --수정일 
);
--기본키생성
alter table C_BBSC add Constraint C_BBSC_CC_ID_pk primary key (CC_ID);
--외래키
alter table C_BBSC add constraint  C_BBSC_BBSC_ID_fk
    foreign key(BBSC_ID) references BBSC(BBSC_ID);

--제약조건
alter table C_BBSC modify BBSC_ID constraint C_BBSC_BBSC_ID_nn not null;
alter table C_BBSC modify CC_CONTENT constraint C_BBSC_CC_CONTENT_nn not null;
alter table C_BBSC modify USER_NICK constraint C_BBSC_USER_NICK_nn not null;
-- not null 제약조건은 add 대신 modify 명령문 사용

--시퀀스 생성
create sequence C_BBSC_CC_ID_SEQ;

--샘플데이터 of C_BBSC
insert into C_BBSC (CC_ID, BBSC_ID , CC_CONTENT, USER_NICK) values(C_BBSC_CC_ID_SEQ.nextval, 1, '커뮤니티댓글1', '별칭1');

COMMIT;

--테이블 구조 확인
DESC C_BBSC;