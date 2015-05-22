-- @brief Database design definition for the tist website

---------- enumerations
-- page_type: 0=institution, 1=project, 2=lab, 3=profile, else=invalid
-- gender: 0=male, else=female
-- verified: 0=false, else=true
-- permission_*: 0=false, else=true
-- public_*: 0=false, else=true

---------- static reference tables
--TODO: we must pre-populate all static reference tables

--see discipline.sql for create table DISCIPLINE

--EX: mr. ms. mrs. dr. etc
create table TITLE(
	title_id int not null auto_increment,
	title varchar(5) unique not null,
	primary key(title_id)
) ENGINE=InnoDB;
insert into TITLE(title) values("Dr.", "Miss", "Mr.", "Mrs.", "Ms.", "Prof.");

create table PROJECT_STATE(
	state_id int not null auto_increment,
	name varchar(50) unique not null,
	primary key(state_id)
) ENGINE=InnoDB;

create table DEGREE(
	degree_id int not null auto_increment,
	name varchar(50) unique not null,
	primary key(degree_id)
) ENGINE=InnoDB;

-------- independent tables

create table USER(
	user_id int not null auto_increment,
	first_name varchar(40) not null,
	last_name varchar(40) not null,
	date_birth date not null,
	gender tinyint not null,
	datetime_created timestamp not null,
	datetime_updated timestamp,
	primary key(user_id)
) ENGINE=InnoDB;

create table VERIFIED(
	verified_id int not null auto_increment,
	verified tinyint default 0 not null,
	verified_by_user_id int,
	verified_datetime timestamp,
	primary key(verified_id),
	foreign key(verified_by_user_id) references USER(user_id)
) ENGINE=InnoDB;

create table PERMISSION(
	permission_id int not null auto_increment,
	verified_id int not null,
	permission_edit tinyint default 0 not null,
	permission_edit_granted_by_user_id int,
	permission_edit_datetime timestamp,
	permission_appoint tinyint default 0 not null,
	permission_appoint_granted_by_user_id int,
	permission_appoint_datetime timestamp,
	permission_verify tinyint default 0 not null,
	permission_verify_granted_by_user_id int,
	permission_verify_datetime timestamp,
	primary key(permission_id),
	foreign key(verified_id) references VERIFIED(verified_id),
	foreign key(permission_edit_granted_by_user_id) references USER(user_id),
	foreign key(permission_appoint_granted_by_user_id) references USER(user_id),
	foreign key(permission_verify_granted_by_user_id) references USER(user_id)
) ENGINE=InnoDB;

-------- main tables

create table PROFILE(
	user_id int not null,
	bio text not null,
	picture_profile varchar(250),
	title_id int,
	num_views int default 0 not null,
	nickname varchar(25),
	datetime_created timestamp not null,
	datetime_updated timestamp,
	foreign key(user_id) references USER(user_id),
	foreign key(title_id) references TITLE(title_id),
) ENGINE=InnoDB;

create table PROJECT(
	project_id int not null auto_increment,
	project_creator_id int not null,
	name varchar(150) unique not null,
	date_start datetime not null,
	date_end datetime not null,
	picture_logo varchar(250) not null,
	link_website varchar(250),
	summary_science text not null,
	summary_impact text not null,
	state_id int not null,
	num_views int default 0 not null,
	nickname varchar(25),
	datetime_created timestamp not null,
	datetime_updated timestamp,
	primary key(project_id),
	foreign key(project_creator_id) references USER(user_id),
	foreign key(state_id) references PROJECT_STATE(state_id)
) ENGINE=InnoDB;

create table INSTITUTION(
	institution_id int not null auto_increment,
	name varchar(150) unique not null,
	link_website varchar(250),
	latitude varchar(25),
	longiture varchar(25),
	street_address varchar(255),
	state_abbrev(2),
	zip_code varchar(10),
	city varchar(50),
	date_founded datetime,
	picture_logo varchar(250),
	mission_statement text,
	num_views int default 0,
	primary key(institution_id),
) ENGINE=InnoDB;

create table LAB(
	lab_id int not null auto_increment,
	institution_id int not null,
	lab_creator_id int not null,
	name varchar(150) not null,
	date_founded datetime not null,
	picture_logo varchar(250) not null,
	mission_statement text not null,
	link_website varchar(250),
	num_views int default 0 not null,
	nickname varchar(25),
	datetime_created timestamp not null,
	datetime_updated timestamp,
	verified_id int not null,
	primary key(lab_id),
	foreign key(verified_id) references VERIFIED(verified_id),
	foreign key(institution_id) references INSTITUTION(institution_id),
	foreign key(lab_creator_id) references USER(user_id)
) ENGINE=InnoDB;

-------- supplementary "one to one" tables

create table CREDENTIALS(
	user_id int not null,
	email varchar(50) unique not null,
	password char(60) not null,
	datetime_updated timestamp,
	foreign key(user_id) references USER(user_id)
) ENGINE=InnoDB;

-------- supplementary "many to many" tables

create table PROJECT_LAB(
	project_lab_id int not null auto_increment,
	project_id int not null,
	lab_id int not null,
	datetime_created timestamp not null,
	primary key(project_lab_id),
	foreign key(project_id) references PROJECT(project_id),
	foreign key(lab_id) references LAB(lab_id)
) ENGINE=InnoDB;

create table INSTITUTION_MEMBER(
	institution_member_id int not null auto_increment,
	user_id int not null,
	institution_id int not null,
	activation_code char(13),
	confirmed tinyint default 0 not null,
	datetime_created timestamp not null,
	datetime_confirmed timestamp not null,
	primary key(institution_member_id),
	foreign key(user_id) references USER(user_id),
	foreign key(institution_id) references INSTITUTION(institution_id)
) ENGINE=InnoDB;

create table LAB_MEMBER(
	lab_member_id int not null auto_increment,
	user_id int not null,
	lab_id int not null,
	datetime_created timestamp not null,
	primary key(lab_member_id),
	foreign key(user_id) references USER(user_id),
	foreign key(lab_id) references LAB(lab_id)
) ENGINE=InnoDB;

create table PROJECT_MEMBER(
	lab_member_id int not null,
	project_lab_id int not null,
	discipline_id int not null,
	job_title varchar(150) not null,
	contribution_description text not null,
	date_start datetime not null,
	date_end datetime not null,
	datetime_created timestamp not null,
	datetime_updated timestamp,
	foreign key(discipline_id) references DISCIPLINE(discipline_id),
	foreign key(project_lab_id) references PROJECT_LAB(project_lab_id),
	foreign key(lab_member_id) references LAB_MEMBER(lab_member_id)
) ENGINE=InnoDB;

-------- supplementary "one to many" tables

create table HISTORY(
	history_id int not null auto_increment,
	user_id int not null,
	page_type tinyint not null,
	institution_id int,
	project_id int,
	lab_id int,
	profile_id int,
	datetime_view timestamp not null,
	primary key(history_id),
	foreign key(user_id) references USER(user_id),
	foreign key(institution_id) references INSTITUTION(institution_id),
	foreign key(project_id) references PROJECT(project_id),
	foreign key(lab_id) references LAB(lab_id),
	foreign key(profile_id) references PROFILE(user_id)
) ENGINE=InnoDB;

create table POST(
	post_id int not null auto_increment,
	post_content text not null,
	page_type tinyint not null,
	institution_id int,
	project_id int,
	lab_id int,
	profile_id int,
	datetime_created timestamp not null,
	primary key(post_id),
	foreign key(institution_id) references INSTITUTION(institution_id),
	foreign key(project_id) references PROJECT(project_id),
	foreign key(lab_id) references LAB(lab_id),
	foreign key(profile_id) references PROFILE(user_id)
) ENGINE=InnoDB;
