CREATE TABLE TEMP(
	USERID VARCHAR2(20),
	USERPW VARCHAR2(20)
);
INSERT INTO TEMP VALUES('XOGNS','1234');
INSERT INTO TEMP VALUES('TAEHOON','1234');
SELECT * FROM TEMP;

DELETE FROM TEMP WHERE USERID ='TAEHOON' AND USERPW = '1234';