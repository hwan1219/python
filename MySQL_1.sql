-- 주석
-- MySQL: 대소문자 구분X (예외: 비밀번호)
-- script 실행:

-- (1) DB만들기 (ex: analysis)
create database analysis;

-- (2) 사용 DB 설정
use analysis;

-- (3) Table 만들기
create table users(
	id INT primary key auto_increment,
    name varchar(50),
    age int
);

-- (4) 데이터 삽입
insert into users(name,age) values ('홍길동',25);
insert into users(name,age) values ('김철수',30),('이영희',21);

-- (5) 데이터 조회 (*: all)
SELECT * FROM users;
SELECT * FROM users
where age>24;

-- (6) 정렬
SELECT * FROM users
order by age>24;

-- (7) 수정
-- 에러 발생 - Edit > Preferences > SQLEditor > Safe Updates 체크해제
set sql_safe_updates=0;
update users
set age=26
where name='홍길동';

-- (8) 삭제
delete from users where name='김철수';
select * from users;
rollback;
select * from users;

-- (9) 집계함수(avg,max,min,sum,count,...)
select avg(age) from users;

-- (10) 그룹화(Group by)
select avg(age),count(*) from users group by age;