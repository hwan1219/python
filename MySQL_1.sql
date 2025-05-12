-- 주석
-- MySQL: 대소문자 구분X(예외: 비밀번호)
-- script 실행:

-- (1) DB만들기(ex: analysis)
CREATE DATABASE analysis;

-- (2) 사용 DB 설정
USE analysis;

-- (3) Table 만들기
CREATE TABLE users(
	id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(50),
    age INT
);

-- (4) 데이터 삽입
INSERT INTO users(user_name,age) VALUES
('홍길동', 25);
INSERT INTO users(user_name,age) VALUES
('김철수', 30), ('이영희', 21);

-- (5) 데이터 조회(*: all)
SELECT * FROM users;
SELECT * FROM users
WHERE age>24;

-- (6) 정렬
SELECT * FROM users
ORDER BY age>24;

-- (7) 수정
-- 에러 발생 - Edit > Preferences > SQLEditor > Safe Updates 체크해제
SET SQL_SAFE_UPDATES=0;
UPDATE users
SET age=26
WHERE user_name='홍길동';

-- (8) 삭제
DELETE FROM users WHERE user_name='김철수';
SELECT * FROM users;
ROLLBACK;
SELECT * FROM users;

-- (9) 집계함수(avg,max,min,sum,count,...)
SELECT AVG(age) FROM users;

-- (10) 그룹화(Group by)
SELECT AVG(age), COUNT(*) FROM users GROUP BY age;


CREATE DATABASE data_collection;
USE data_collection;
CREATE TABLE data_types_example(
	id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    product_description TEXT,
    release_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    attributes JSON
);

INSERT INTO data_types_example
(product_name, price, product_description, release_date, attributes)
VALUES
('스마트폰', 999.99, '최신 스마트폰 모델', '2025-05-06', '{"color": "black", "storage": "128GB"}'),
('노트북', 1499.50, '고성능 게이밍 노트북', '2025-04-15', '{"color": "silver", "RAM": "32GB"}');

-- JSON 키 값 조회(--> 연산자 사용)
SELECT
	product_name,
    attributes->>'$.color' AS color,
    attributes->>'$.storage' AS storage
FROM data_types_example;

-- JSON 키 존재 여부 확인(JSON_CONTAINS_PATH())
SELECT
	product_name,
    JSON_CONTAINS_PATH(attributes, 'one', '$.color') AS has_color,
    JSON_CONTAINS_PATH(attributes, 'one', '$.RAM') AS has_RAM
FROM data_types_example;

-- 조건 검색(특정 JSON 키/값 필터링)
SELECT
	product_name,
    attributes->>'$.color' AS color
FROM data_types_example
WHERE attributes->>'$.color' = 'black';

-- JSON 값을 숫자로 변환해서 조건 검색
-- attributes 안에 "storage_size": "128" 같이 저장되어 있다고 가정
SELECT
	product_name,
    CAST(attributes->>'$.storage_size' AS UNSIGNED) AS storage_size
FROM data_types_example
WHERE CAST(attributes->>'$.storage_size' AS UNSIGNED) >= 128;


-- CRUD 기본
-- (1) Create
CREATE TABLE members(
	member_id INT AUTO_INCREMENT PRIMARY KEY,
    member_name VARCHAR(50),
    email VARCHAR(100),
    join_date DATETIME DEFAULT NOW()
);

-- (2) Insert
INSERT INTO members(member_name, email) VALUES
('Kim', 'kim@mail.com'),
('Lee', 'lee@mail.com'),
('Park', 'park@mail.com');

-- (3) Select
-- 전체 조회
SELECT * FROM members;
-- 조건 검색
SELECT * FROM members WHERE member_name = 'Kim';
-- 정렬
-- DESC(내림차순 정렬)
SELECT * FROM members ORDER BY join_date DESC;

-- (4) Update
-- Park 의 이메일 수정
UPDATE members
SET email = 'park2025@mail.com'
WHERE member_name = 'Park';
-- 결과 확인
SELECT * FROM members WHERE member_name = 'Park';

-- (5) Delete
-- Lee 회원 삭제
DELETE FROM members WHERE member_name = 'Lee';
-- 삭제 후 확인
SELECT * FROM members;

-- (6) LIKE, LIMIT 사용
--  wild card: %(여러문자 대체), ?(하나의 문자)
-- 이름에 'K'가 포함된 회원 조회
SELECT * FROM members WHERE member_name LIKE '%K%';
-- 가장 최근 가입자 1명 조회
SELECT * FROM members ORDER BY join_date DESC LIMIT 1;

-- (7) 실습 마무리 과제
-- 1. 새로운 회원 두 명 추가(이름, 이메일 입력)
-- 2. 한 명의 이메일 수정
-- 3. 이름이 'P'로 시작하는 회원 모두 삭제
INSERT INTO members(member_name, email) VALUES
('Tom', 'tom@mail.com'),
('Annie', 'annie@mail.com');
INSERT INTO members(member_name, email) VALUES
(null, null);
SELECT * FROM members;

UPDATE members
SET email = 'tom777@mail.com'
WHERE member_name = 'Tom';
SELECT * FROM members;

DELETE FROM members WHERE member_name LIKE 'P%';
SELECT * FROM members;


-- 제약조건(constraint)
-- PRIMARY KEY : 중복X, NULL 허용X, 하나의 테이블에 1개만 가능
-- UNIQUE + NOT NULL : 중복X, NULL 허용X, PRIMARY KEY와 사실상 같음
-- FOREIGN KEY : 다른 테이블의 기본 키를 참조

-- 부모 테이블(부서) 생성
CREATE TABLE departments(
	dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) UNIQUE NOT NULL
);

-- 부모 테이블 데이터 삽입
INSERT INTO departments(dept_name) VALUES
('IT'), ('HR'), ('Marketing');

-- 자식 테이블(직원) 생성 + 제약조건 적용
CREATE TABLE employees(
	emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    dept_id INT NOT NULL,
    FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
);

-- 자식 테이블 데이터 삽입
INSERT INTO employees(emp_name, email, dept_id) VALUES
	('Kim', 'kim@company.com', 1),
    ('lee', 'lee@company.com', 2),
    ('Park', 'park@company.com', 3);
    
-- 관계형 데이터 조회 (JOIN)
SELECT e.emp_name, e.email, d.dept_name
FROM employees e
JOIN departments d
ON e.dept_id = d.dept_id;


-- 집계 함수 & GROUP BY 실습

-- (1) 직원 추가
INSERT INTO employees (emp_name, email, dept_id) VALUES
('Choi', 'choi@company.com', 1),
('Han', 'han@company.com', 2);
SELECT * FROM employees;

-- (2) 부서별 직원 월급 데이터를 추가한 테이블 만들기
DROP TABLE IF EXISTS employees_salary;
CREATE TABLE employees_salary(
	emp_id INT PRIMARY KEY,
    dept_id INT NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

INSERT INTO employees_salary (emp_id, dept_id, salary) VALUES
(1, 1, 5000),
(2, 2, 4000),
(3, 3, 4500),
(4, 1, 5500),
(5, 2, 3800);

-- (3) 부서별 직원 수(COUNT)
SELECT d.dept_name AS 부서명,
COUNT(e.emp_id) AS 직원수
FROM departments d
JOIN employees e
ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- (4) 부서별 평균 급여(AVG)
SELECT d.dept_name AS 부서명,
ROUND(AVG(s.salary), 2) AS 평균급여
FROM departments d
JOIN employees_salary s
ON d.dept_id = s.dept_id
GROUP BY d.dept_name;

-- (5) 부서별 최고/최저 급여(MIN, MAX)
SELECT d.dept_name AS 부서명,
MAX(s.salary) AS 최고급여,
MIN(s.salary) AS 최저급여
FROM departments d
JOIN employees_salary s
ON d.dept_id = s.dept_id
GROUP BY d.dept_name;

-- (6) 평균 급여가 4500 이상인 부서(HAVING)
SELECT d.dept_name AS 부서명,
ROUND(AVG(s.salary), 2) AS 평균급여
FROM departments d
JOIN employees_salary s
ON d.dept_id = s.dept_id
GROUP BY d.dept_name
HAVING AVG(s.salary) >= 4500;

-- (7) 부서와 급여가 같은 인원수 (복합 GROUP BY)
SELECT d.dept_name AS 부서명,
s.salary AS 급여,
COUNT(*) AS 인원수
FROM departments d
JOIN employees_salary s
ON d.dept_id = s.dept_id
GROUP BY d.dept_name, s.salary
ORDER BY d.dept_name, s.salary DESC;

-- (8) vscode

-- (9) 총 급여가 8000 이상인 부서만 조회
SELECT d.dept_name AS 부서명,
COUNT(*) AS 직원수,
SUM(s.salary) AS 총급여
FROM employees_salary s
JOIN departments d
ON s.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING sum(s.salary) >= 8000;


-- JOIN(INNER, LEFT, RIGHT, CROSS)
-- 2개 이상의 테이블 사용

-- (1) INNER JOIN (교집합)
SELECT e.emp_name AS 이름,
e.email AS 이메일,
d.dept_name AS 부서명
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id;

-- (2) LEFT JOIN (employees 기준)
-- 왼쪽 테이블은 무조건, 오른쪽은 있으면 보여줌
-- 오른쪽에 값이 없다면 NULL로 반환한다는 뜻
SELECT e.emp_name AS 이름,
e.email AS 이메일,
d.dept_name AS 부서명
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id;

-- (3) RIGHT JOIN (departments 기준)
SELECT e.emp_name AS 이름,
e.email AS 이메일,
d.dept_name AS 부서명
FROM employees e
RIGHT JOIN departments d
ON e.dept_id = d.dept_id;

-- (4) CROSS JOIN (참고용)
-- 모든 직원과 모든 부서 조합 출력
SELECT e.emp_name AS 이름,
e.email AS 이메일,
d.dept_name AS 부서명
FROM employees e
CROSS JOIN departments d;

-- (5) 실습: 부서별 직원 수를 LEFT JOIN을 이용해 직원이 없는 부서도 포함되게끔 출력
INSERT INTO departments(dept_name) VALUES
('AI');
SELECT d.dept_name AS 부서명,
COUNT(e.emp_id) AS 직원수
FROM departments d
LEFT JOIN employees e
ON d.dept_id = e.dept_id
GROUP BY d.dept_name;


-- 고급 JOIN(SELF, CROSS응용)
-- (1) 현재 사용 중인 DB와 상관없이 테이블을 정확히 지정
SELECT * FROM data_collection.employees_salary;

-- (2) SELF JOIN(같은 부서 직원 비교)
SELECT
	e1.emp_name AS 직원1,
	e2.emp_name AS 직원2,
	d.dept_name AS 부서명
FROM employees e1
JOIN employees e2
	ON e1.dept_id = e2.dept_id
	AND e1.emp_id < e2.emp_id
JOIN departments d
	ON e1.dept_id = d.dept_id;
    
-- (3) SELF JOIN(급여 비교)
SELECT
	e1.emp_name AS A,
    e2.emp_name AS B,
    s1.salary AS A_salary,
    s2.salary AS B_salary
FROM employees_salary s1
JOIN employees_salary s2
	ON s1.salary > s2.salary
JOIN employees e1
	ON e1.emp_id = s1.emp_id
JOIN employees e2
	ON e2.emp_id = s2.emp_id;
    
-- (4) CROSS JOIN(모든 직원 간 상호작용 시뮬레이션)
SELECT
	e1.emp_name AS sender,
    e2.emp_name AS receiver
FROM employees e1
CROSS JOIN employees e2
WHERE e1.emp_id != e2.emp_id;

-- (5) 직원 간 급여 차이 계산
SELECT
	e1.emp_name AS A,
    e2.emp_name AS B,
	s1.salary AS A_salary,
	s2.salary AS B_salary,
    s1.salary - s2.salary AS 급여차이
FROM employees_salary s1
JOIN employees_salary s2
	ON s1.salary > s2.salary
JOIN employees e1
	ON e1.emp_id = s1.emp_id
JOIN employees e2
	ON e2.emp_id = s2.emp_id;
    
-- (6) 실습: CROSS JOIN을 활용해 직원x부서 조합을 만들고, 자기 부서가 아닌 직원/부서 조합만 출력
SELECT
	e.emp_name AS 직원명,
    d.dept_name AS 부서명
FROM employees e
CROSS JOIN departments d
WHERE e.dept_id != d.dept_id
ORDER BY e.emp_name;


-- SubQuery & View
-- 데이터베이스 선택
USE data_collection;

-- (1) WHERE 절 서브쿼리(평균 이상 급여)
SELECT
	e.emp_name AS 직원명,
    s.salary AS 급여
FROM employees e
JOIN employees_salary s
	ON e.emp_id = s.emp_id
WHERE s.salary >= (
	SELECT AVG(salary) FROM employees_salary
);

-- (2) SELECT 절 스칼라 서브쿼리(전체 평균과 함께 출력)
SELECT
	e.emp_name AS 직원명,
    s.salary AS 급여,
    (SELECT AVG(salary) FROM employees_salary) AS 전체평균
FROM employees e
JOIN employees_salary s
	ON e.emp_id = s.emp_id;
    
-- (3) FROM 절 인라인 서브쿼리(부서별 평균급여 >= 4500)
SELECT
	부서명, 평균급여
FROM (
	SELECT dept_name AS 부서명, AVG(s.salary) AS 평균급여
    FROM departments d
    JOIN employees_salary s
		ON d.dept_id = s.dept_id
	GROUP BY dept_name
) AS dept_avg
WHERE 평균급여 >= 4500;

-- (4) VIEW 생성(복잡한 쿼리 저장)
CREATE OR REPLACE VIEW v_dept_salary_summary AS
SELECT
	d.dept_name AS 부서명,
	COUNT(*) AS 인원수,
	ROUND(AVG(s.salary), 2) AS 평균급여
FROM departments d
JOIN employees_salary s
	ON d.dept_id = s.dept_id
GROUP BY d.dept_name;

-- (5) VIEW 활용
-- 전체행 출력
SELECT * FROM v_dept_salary_summary;
-- 평균급여 4500이상만 출력
SELECT * FROM v_dept_salary_summary
WHERE 평균급여 >= 4500;

-- (6) VIEW + JOIN
SELECT v.부서명, v.평균급여
FROM v_dept_salary_summary v;

-- (7) 실습
-- 전체 급여 평균보다 높은 직원만 VIEW로 저장
-- 저장한 VIEW 를 통해 급여 상위 직원 이름과 급여를 출력
CREATE OR REPLACE VIEW v_salary AS
SELECT
	e.emp_name AS 직원명,
    s.salary AS 급여
FROM employees e
JOIN employees_salary s
	ON e.emp_id = s.emp_id
WHERE s.salary > (
	SELECT AVG(salary) FROM employees_salary
);
SELECT * FROM v_salary
ORDER BY 급여 DESC;

    