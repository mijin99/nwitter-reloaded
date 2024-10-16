INSERT INTO users (
 	username,
  email,
  gender,
  interests,
  bio,
  age,
  is_admin,
  birth_date,
  bed_time,
  graduation_year
  )VALUES(
    'mr. nobody',
    'mr@nobody.com',
    'Male',
    'Travel,Food,Technology',
    'I like traveling and eating',
    88,
    TRUE,
    '1999.05.08',
    '22:30',
    '1976'
    );
  
--데이터 추가 삭제 제약조건 수정
--drop column
ALTER TABLE users DROP COLUMN profile_picture;

--컬럼명 변경
ALTER TABLE users CHANGE COLUMN bio about_me TINYTEXT;

--컬럼유형변경 (호환되는 타입으로 변경해야됨)
--ALTER TABLE users CHANGE COLUMN about_me about_me TEXT;
ALTER TABLE users MODIFY COLUMN about_me TINYTEXT; 

--구조 확인 
SHOW CREATE TABLE users;

--RENAME DABABASE 이름 변경
ALTER TABLE customers RENAME TO users;

--제약조건 삭제 (유니크라 자체 생성된 항목도 SHOW CREATE TABLE로 확인 후에 지울 수 있음)
ALTER TABLE users DROP CONSTRAINT uq_email,
									DROP CONSTRAINT username;
                  
--adding constraint 
ALTER TABLE users ADD CONSTRAINT uq_email UNIQUE(email),
									ADD CONSTRAINT uq_username UNIQUE(username);
             
ALTER TABLE users ADD CONSTRAINT chk_age CHECK(age<100);
ALTER TABLE users MODIFY COLUMN bed_time TIME NULL; --널값 허용


--컬럼을 변경할 때 드는 공수..
--오류발생! 이미 값 존재
ALTER TABLE users MODIFY COLUMN graduation_year DATE;
--방법 1 완전 새로운 컬럼을 만들기 (마이그레이션).. 
ALTER TABLE users ADD COLUMN graduation_date DATE ;
UPDATE users SET graduation_date = MAKEDATE(graduation_year,1);
ALTER TABLE users DROP COLUMN graduation_year;

--방법 2 컬럼 만들면서 기본값 세팅, NOT NULL하려면 기본값 넣어줘야함(기본은 NULL이기 때문에 오류)
ALTER TABLE users ADD COLUMN graduation_date DATE NOT NULL DEFAULT MAKEDATE(graduation_year,1);



