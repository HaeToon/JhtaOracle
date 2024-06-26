--subquery
--query 를 한번더쓰기 
SELECT * FROM EMP;
--JONES보다 SAL 이 큰사람 출력 QUERY 안의 QUERY 
SELECT * FROM EMP;
SELECT SAL FROM EMP WHERE ENAME = 'JONES';
SELECT * FROM EMP WHERE SAL > (SELECT SAL FROM EMP WHERE ENAME = 'JONES');

--ALLEN의 커미션보다 많은 커미션 받는 사람
--비교대상 쿼리의 데이터타입이 일치해야함.
SELECT * FROM EMP WHERE COMM > (SELECT COMM FROM EMP WHERE ENAME = 'ALLEN');

SELECT * FROM EMP WHERE HIREDATE<(SELECT HIREDATE FROM EMP WHERE ENAME = 'SCOTT');

--20번 부서에 속한 사원중 전체 사원의 평균급여보다 높은 급여를 받는 사람의 사원번호, 이름,SAL,부서번호,부서명,위치 뽑기
--1
SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP WHERE DEPTNO = 20;
--2
SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP WHERE DEPTNO =20 AND SAL > (SELECT AVG(SAL) FROM EMP WHERE DEPTNO=20);
--3-1 ORACLE 
SELECT EMPNO,ENAME,SAL,E.DEPTNO,DNAME,LOC FROM EMP E,DEPT D WHERE E.DEPTNO =D.DEPTNO AND E.DEPTNO =20 AND SAL > (SELECT AVG(SAL) FROM EMP WHERE DEPTNO=20);
--3-2 INNER JOIN INNER 는 생략가능
SELECT EMPNO,ENAME,SAL,E.DEPTNO,DNAME,LOC FROM EMP E INNER JOIN DEPT D ON(E.DEPTNO=D.DEPTNO) WHERE E.DEPTNO =20 AND SAL > (SELECT AVG(SAL) FROM EMP WHERE DEPTNO=20);
SELECT EMPNO,ENAME,SAL,E.DEPTNO,DNAME,LOC FROM EMP E JOIN DEPT D ON(E.DEPTNO=D.DEPTNO) WHERE E.DEPTNO =20 AND SAL > (SELECT AVG(SAL) FROM EMP WHERE DEPTNO=20);
--위의 것들은 단일행을 반환하는 스칼라 서브쿼리 이다.


--복수행 서브쿼리
SELECT * FROM EMP WHERE DEPTNO = 20 OR DEPTNO =30;
 --위와 동일함.
SELECT * FROM EMP WHERE DEPTNO IN(20,30);

--부서별 최고급여와 동일급여를 받는 사람 뽑기

SELECT * FROM EMP WHERE SAL IN (SELECT MAX(SAL) FROM EMP GROUP BY DEPTNO) ORDER BY DEPTNO;
--SUBQUERY 결과중 하나라도 일치하면 출력
SELECT * FROM EMP WHERE SAL = ANY (SELECT MAX(SAL) FROM EMP GROUP BY DEPTNO) ORDER BY DEPTNO;
SELECT * FROM EMP WHERE SAL = SOME (SELECT MAX(SAL) FROM EMP GROUP BY DEPTNO) ORDER BY DEPTNO;
--SUBQUERY 결과중 전체가 일치하면 출력 ALL
SELECT * FROM EMP WHERE SAL = ALL (SELECT MAX(SAL) FROM EMP GROUP BY DEPTNO) ORDER BY DEPTNO;

--30번 부서의 최소급여보다 더 작은 월급을 받는 사원 출력 
SELECT * FROM EMP WHERE SAL< ALL (SELECT SAL FROM EMP WHERE DEPTNO=30);
--30번 부서의 최소급여보다 더 많은 월급을 받는 사원 출력 
SELECT * FROM EMP WHERE SAL> ALL (SELECT SAL FROM EMP WHERE DEPTNO=30);
--30번 부서의 최대급여보다 더 많은 월급을 받는 사원 출력 
SELECT * FROM EMP WHERE SAL> ANY (SELECT SAL FROM EMP WHERE DEPTNO=30);
--30번 부서의 최대급여보다 더 적은 월급을 받는 사원 출력 
SELECT * FROM EMP WHERE SAL< ANY (SELECT SAL FROM EMP WHERE DEPTNO=30);

--EXISTS 존재하는지 안하는지 있으면 출력 없으면 X
SELECT * FROM EMP WHERE EXISTS (SELECT SAL FROM EMP WHERE DEPTNO=30);

--SUBQUERY 는 아무데서나 쓸수있다.
--FROM절에도 사용가능 이때 INLINE VIEW 라고도 함
SELECT E10.EMPNO,E10.ENAME,E10.DEPTNO FROM (SELECT *FROM EMP WHERE DEPTNO = 10) E10;

--VIEW 는 MASKING 된 TABLE과 같다.
SELECT E10.EMPNO,E10.ENAME,E10.DEPTNO,D.DNAME,D.LOC FROM (SELECT * FROM EMP WHERE DEPTNO=10) E10,
(SELECT * FROM DEPT)D WHERE E10,DPETNO

SELECT E10.EMPNO,E10.ENAME,E10.DEPTNO,D.DNAME,D.LOC FROM (SELECT * FROM EMP WHERE DEPTNO=10) E10
JOIN(SELECT * FROM DEPT)D ON E10.DEPTNO=D.DEPTNO;

--SELECT에도 쓸수있다.
SELECT * FROM EMP ;
SELECT EMPNO , ENAME , JOB , SAL,
(SELECT GRADE FROM SALGRADE WHERE E.SAL BETWEEN LOSAL AND HISAL) 
AS GRADE,DEPTNO,
(SELECT DNAME FROM DEPT WHERE E.DEPTNO = DEPTNO)AS DNAME FROM EMP E;

--1-1 ORACLE
--SELECT JOB FROM EMP WHERE ENAME ='ALLEN';
SELECT JOB , EMPNO, ENAME, SAL,E.DEPTNO,DNAME 
FROM EMP E , DEPT D WHERE E.DEPTNO = D. DEPTNO 
AND JOB = (SELECT JOB FROM EMP WHERE ENAME ='ALLEN' );

--1-2표준 JOIN
SELECT JOB , EMPNO, ENAME, SAL,E.DEPTNO,DNAME 
FROM EMP E JOIN DEPT D ON E.DEPTNO = D.DEPTNO 
WHERE JOB = (SELECT JOB FROM EMP WHERE ENAME='ALLEN');

--2-1 ORACLE
--SELECT AVG(SAL) FROM EMP;
SELECT EMPNO,ENAME,DNAME,HIREDATE,LOC,SAL,GRADE FROM EMP E,DEPT D,SALGRADE S 
WHERE E.DEPTNO =D.DEPTNO 
AND SAL BETWEEN LOSAL AND HISAL 
AND SAL > (SELECT AVG(SAL) FROM EMP) 
ORDER BY SAL DESC;

--2-2 표준
--SELECT AVG(SAL) FROM EMP;
SELECT EMPNO,ENAME,DNAME,HIREDATE,LOC,SAL,GRADE FROM EMP E
JOIN DEPT D ON E.DEPTNO = D.DEPTNO
JOIN SALGRADE S ON E.SAL > (SELECT AVG(SAL) FROM EMP) 
AND E.SAL BETWEEN S.LOSAL AND S.HISAL
ORDER BY E.SAL DESC;

--2-3
--SELECT AVG(SAL) FROM EMP;
SELECT EMPNO,ENAME,DNAME,HIREDATE,LOC,SAL,
(SELECT GRADE FROM SALGRADE WHERE E.SAL BETWEEN LOSAL AND HISAL) AS GRADE
FROM EMP E INNER JOIN DEPT D ON E.DEPTNO = D.DEPTNO 
WHERE E.SAL > (SELECT AVG(SAL) FROM EMP)
ORDER BY E.SAL DESC;

--3-1 ORACLE
--SELECT * FROM EMP WHERE DEPTNO = 10;
--SELECT JOB FROM EMP WHERE DEPTNO = 30;
SELECT EMPNO,ENAME,JOB,E.DEPTNO,DNAME,LOC 
FROM (SELECT * FROM EMP WHERE DEPTNO = 10) E,DEPT D WHERE E.DEPTNO = D.DEPTNO 
AND JOB NOT IN (SELECT JOB FROM EMP WHERE DEPTNO = 30);

--3-2 표준
--SELECT * FROM EMP WHERE DEPTNO = 10;
--SELECT JOB FROM EMP WHERE DEPTNO = 30;
SELECT EMPNO,ENAME,JOB,E.DEPTNO,DNAME,LOC FROM (SELECT*FROM EMP WHERE DEPTNO=10) E
JOIN DEPT D ON E.DEPTNO = D.DEPTNO
AND JOB NOT IN (SELECT JOB FROM EMP WHERE DEPTNO=30);

--3-3
--SELECT * FROM EMP WHERE DEPTNO = 10;
--SELECT JOB FROM EMP WHERE DEPTNO = 30;
SELECT E.EMPNO,E.ENAME,E.JOB,E.DEPTNO,D.DNAME,D.LOC 
FROM EMP E INNER JOIN DEPT D ON E.DEPTNO = D. DEPTNO
WHERE E.DEPTNO =10 AND JOB NOT IN (SELECT DISTINCT JOB FROM EMP WHERE DEPTNO=30);

--4-1 ORACLE
--SELECT MAX(SAL) FROM EMP WHERE JOB = 'SALESMAN';
SELECT EMPNO,ENAME,SAL,GRADE FROM EMP E, SALGRADE S 
WHERE E.SAL BETWEEN S.LOSAL  AND S.HISAL 
AND SAL > (SELECT MAX(SAL) FROM EMP WHERE JOB = 'SALESMAN');

--4-2 표준
SELECT MAX(SAL) FROM EMP WHERE JOB = 'SALESMAN';
SELECT EMPNO,ENAME,SAL,GRADE 
FROM EMP E INNER JOIN SALGRADE S ON E.SAL BETWEEN S.LOSAL AND S.HISAL
WHERE E.SAL > (SELECT MAX(SAL) FROM EMP WHERE JOB = 'SALESMAN')
--WHERE E.SAL > ALL (SELECT DISTINCT SAL FROM EMP WHERE JOB = 'SALESMAN')
ORDER BY SAL DESC;



