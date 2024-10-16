--데이터 타입 
--sqlite : integer,  real, text, null, blob
--mysql



CREATE TABLE users(
  user_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  username char(10) NOT NULL unique, 
  email varchar(50) not null ,
  gender ENUM ('Male','Female') not null,
  interests SET('Technology','Sports','Music','Art','Travel','Food','Fashion','Science') not null,
  bio TEXT not null,
  profile_picture TINYBLOB , 
  age tinyint unsigned not null ,
  is_admin boolean default false not null ,
  balance float default 0.0 not null,
  joined_at timestamp default current_timestamp not null,  
  update_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP not null, 
  birth_date DATE not null, 
  bed_time TIME not null, 
  graduation_year YEAR not null, 
  constraint chk_age check(age<100),
  constraint uq_email unique(email)
  );


DROP TABLE users;

