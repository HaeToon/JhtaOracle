--sql을 입력하면 됨  한줄실행 ctrl+enter
account unlock;
-- 아래의 명령어로 USER name 에 c##안붙여도됨
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

CREATE USER scott IDENTIFIED BY tiger;
--21c에서는 user name 앞에 c##을 붙여야함.>> CREATE USER c##scott IDENTIFIED BY tiger <<원래 해야하는것
ALTER USER scott IDENTIFIED BY tiger ;
--권한주는명령어GRANT  
-- GRANT resource, CONNECT TO scott;
GRANT DBA TO scott;
--GRANT CONNECT,RESOURCE,UNLIMITED TABLESPACE TO scott;
DROP USER scott CASCADE;


