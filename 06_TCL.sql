-- TCL(TRANSACTION CONTROL LANGUAGE) : 트랜잭션 제어 언어
-- COMMIT(트랜잭션 종료 후 저장), ROLLBACK(트랜잭션 취소), SAVEPOINT(임시저장)

-- DML : 데이터 조작 언어로 데이터의 삽입, 수정, 삭제
--> 트랜잭션은 DML과 관련되어 있음.


/* TRANSACTION이란?
 - 데이터베이스의 논리적 연산 단위
 
 - 데이터 변경 사항을 묶어 하나의 트랜잭션에 담아 처리함.

 - 트랜잭션의 대상이 되는 데이터 변경 사항 : INSERT, UPDATE, DELETE (DML), MERGE
 
 EX) INSERT 수행 --------------------------------> DB 반영(X)
   
     INSERT 수행 --> 트랜잭션에 추가 --> COMMIT --> DB 반영(O)- T
     
     INSERT 10번 수행 --> 1개 트랜잭션에 10개 추가 --> ROLLBACK --> DB 반영 안됨


    1) COMMIT : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 DB에 반영
    
    2) ROLLBACK : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 삭제하고
                 마지막 COMMIT 상태로 돌아감.(DB에 변경 내용 반영 X)
                
    3) SAVEPOINT : 메모리 버퍼(트랜잭션)에 저장 지점을 정의하여
                   ROLLBACK 수행 시 전체 작업을 삭제하는 것이 아닌
                   저장 지점까지만 일부 ROLLBACK 
    
    [SAVEPOINT 사용법]
    
    SAVEPOINT 포인트명1;
    ...
    SAVEPOINT 포인트명2;
    ...
    ROLLBACK TO 포인트명1; -- 포인트1 지점 까지 데이터 변경사항 삭제

*/

SELECT * FROM DEPARTMENT2;

-- 새로운 데이터 INSERT
INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2');


-- INSERT 확인
SELECT * FROM DEPARTMENT2;
--> DB에 반영된 것처럼 보이지만
-- SQL 수행 시 트랜잭션 내용도 포함해서 수행된다.
-- (실제로 아직 DB에 반영 X)

-- ROLLBACK 후 확인
ROLLBACK;
SELECT * FROM DEPARTMENT2;


--COMMIT 후 ROLLBACK이 되는지 확인
INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2');

COMMIT;

SELECT * FROM DEPARTMENT2;

ROLLBACK;

SELECT * FROM DEPARTMENT2; --> 롤백 안됨!

-------------------------------------------------------------------------------------------

-- SAVEPOINT 확인
INSERT INTO DEPARTMENT2 VALUES('T4', '개발4팀', 'L2');
SAVEPOINT SP1;

SELECT * FROM DEPARTMENT2;

INSERT INTO DEPARTMENT2 VALUES('T5', '개발5팀', 'L2');
SAVEPOINT SP2;

SELECT * FROM DEPARTMENT2;

INSERT INTO DEPARTMENT2 VALUES('T6', '개발6팀', 'L2');
SAVEPOINT SP3;



ROLLBACK TO SP1;


SELECT * FROM DEPARTMENT2; --> 개발4팀까지 있다


DELETE FROM DEPARTMENT2
WHERE DEPT_ID LIKE 'T%';


SELECT * FROM DEPARTMENT2;

-- SP2 지점까지 롤백
ROLLBACK TO SP2;

SELECT * FROM DEPARTMENT2;

-- SP1 지점까지 롤백
ROLLBACK TO SP1;

SELECT * FROM DEPARTMENT2;

ROLLBACK;

SELECT * FROM DEPARTMENT2; --> 개발 3팀까지 있다


-------------------------------------------------------------------------------------------

-- 예제

-- 1.
CREATE TABLE USER_TEST(
	ID NUMBER,
	Name VARCHAR2(30),
	ReserveDate VARCHAR2(20),
	RoomNum NUMBER
);

SELECT * FROM USER_TEST;

INSERT INTO USER_TEST VALUES(1, '홍길동', '2016-01-05', '2014');
INSERT INTO USER_TEST VALUES(2, '임꺽정', '2016-02-12', '918');
INSERT INTO USER_TEST VALUES(3, '장길산', '2016-01-16', '1208');
INSERT INTO USER_TEST VALUES(4, '홍길동', '2016-03-17', '504');
INSERT INTO USER_TEST VALUES(6, '김유신', NULL, NULL);

ROLLBACK;


-- 2.
UPDATE USER_TEST SET ROOMNUM = '2002'
WHERE ID = '1';

UPDATE USER_TEST SET ROOMNUM = '2002'
WHERE ID = '4';

DELETE FROM USER_TEST
WHERE NAME = '김유신';


-- 3.
UPDATE USER_TEST SET ROOMNUM = '2002';


-- 4.
CREATE TABLE EMPLOYEE4 AS SELECT * FROM EMPLOYEE;


-- 5.
UPDATE EMPLOYEE4 SET SALARY = SALARY + 1000000
WHERE HIRE_DATE < '2000-0101';


-- 6.
UPDATE EMPLOYEE4 SET BONUS = 0.5
WHERE EMP_NAME IN(
SELECT EMP_NAME
FROM EMPLOYEE4
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
LEFT JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
LEFT JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국');

SELECT * FROM EMPLOYEE4;



