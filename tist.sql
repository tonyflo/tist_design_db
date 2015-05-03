##### enumerations
# page_type: 0=institution, 1=project, 2=lab, 3=profile, else=invalid
# gender: 0=male, else=female
# verified: 0=false, else=true
# permission_*: 0=false, else=true

##### static reference tables

create table LOCATION(TODO) ENGINE=InnoDB;

create table DISCIPLINE(TODONE) ENGINE=InnoDB;

create table TITLE(
	title_id int not null auto_increment,
	title varchar(5) unique not null,
	primary key(title_id)
) ENGINE=InnoDB;

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

#### independent tables

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

#### main tables

create table PROFILE(
	user_id int not null,
	bio text not null,
	picture_profile varchar(250),
	public_picture bit(1) default 0 not null,
	public_location bit(1) default 0 not null,
	title_id int,
	location_id int not null,
	num_views int default 0 not null,
	nickname varchar(25),
	datetime_created timestamp not null,
	datetime_updated timestamp,
	foreign key(user_id) references USER(user_id),
	foreign key(title_id) references TITLE(title_id),
	foreign key(location_id) references LOCATION(location_id))
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
	verified tinyint default 0 not null,
	datetime_created timestamp not null,
	datetime_updated timestamp,
	primary key(project_id),
	foreign key(project_creator_id) references USER(user_id),
	foreign key(state_id) references PROJECT_STATE(state_id)
) ENGINE=InnoDB;

create table INSTITUTION(
	institution_id int not null auto_increment,
	institution_creator_id int not null,
	name varchar(150) unique not null,
	academia tinyint default 0 not null,
	date_founded datetime not null,
	picture_logo varchar(250) not null,
	mission_statement text not null,
	link_website varchar(250),
	location_id int not null,
	num_views int default 0 not null,
	nickname varchar(25),
	datetime_created timestamp not null,
	datetime_updated timestamp,
	primary key(institution_id),
	foreign key(institution_creator_id) references USER(user_id),
	foreign key(location_id) references LOCATION(location_id)
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
	location_id int not null,
	num_views int default 0 not null,
	nickname varchar(25),
	verified tinyint default 0 not null,
	permission_edit tinyint default 0 not null,
	permission_appoint tinyint default 0 not null,
	permission_approve tinyint default 0 not null,
	datetime_created timestamp not null,
	datetime_updated timestamp,
	foreign key(institution_id) references INSTITUTION(institution_id),
	foreign key(location_id) references LOCATION(location_id)
	foreign key(lab_creator_id) references USER(user_id),
) ENGINE=InnoDB;

#### supplementary "one to one" tables

create table CREDENTIALS(
	user_id int not null,
	email varchar(50) unique not null,
	password char(60) not null,
	verified tinyint default 0 not null,
	activation_code char(10),
	datetime_updated timestamp,
	foreign key(user_id) references USER(user_id)
) ENGINE=InnoDB;

#### supplementary "many to many" tables

create table ACADEMIC_CAREER(
	institution_id int not null,
	user_id int not null,
	date_start datetime not null,
	date_grad datetime not null,
	degree_id int not null,
	discipline_id int not null,
	datetime_created timestamp not null,
	datetime_updated timestamp,
	verified tinyint default 0 not null,
	foreign key(institution_id) references INSTITUTION(institution_id),
	foreign key(user_id) references USER(user_id),
	foreign key(degree_id) referenced DEGREE(degree_id),
	foreign key(discipline_id) referenced DISCIPLINE(discipline_id)
) ENGINE=InnoDB;

create table PROFESSIONAL_CAREER(
	institution_id int not null,
	user_id int not null,
	date_start datetime not null,
	date_grad datetime not null,
	discipline_id int not null,
	job_title varchar(150) not null,
	job_description text not null,
	datetime_created timestamp not null,
	datetime_updated timestamp,
	verified tinyint default 0 not null,
	foreign key(institution_id) references INSTITUTION(institution_id),
	foreign key(user_id) references USER(user_id),
	foreign key(job_title_id) referenced JOB_TITLE(job_title_id),
	foreign key(discipline_id) referenced DISCIPLINE(discipline_id)
) ENGINE=InnoDB;

create table PROJECT_CONTRIBUTOR(
	project_id int not null,
	user_id int not null,
	date_start datetime not null,
	date_grad datetime not null,
	discipline_id int not null,
	contribution_description text not null,
	datetime_created timestamp not null,
	datetime_updated timestamp,
	verified tinyint default 0 not null,
	permission_edit tinyint default 0 not null,
	permission_appoint tinyint default 0 not null,
	permission_approve tinyint default 0 not null,
	foreign key(project_id) references PROJECT(project_id),
	foreign key(user_id) references USER(user_id),
	foreign key(discipline_id) referenced DISCIPLINE(discipline_id)
) ENGINE=InnoDB;

create table PROJECT_LAB(
	project_id int not null,
	lab_id int not null,
	date_start datetime not null,
	date_grad datetime not null,
	description text not null,
	datetime_created timestamp not null,
	datetime_updated timestamp,
	verified tinyint default 0 not null,
	permission_edit tinyint default 0 not null,
	permission_appoint tinyint default 0 not null,
	permission_approve tinyint default 0 not null,
	foreign key(project_id) references PROJECT(project_id),
	foreign key(lab_id) references LAB(lab_id)
) ENGINE=InnoDB;

#### supplementary "one to many" tables

create table HISTORY(
	history_id int not null auto_increment,
	user_id int not null,
	page_type tinyint not null,
	institution_id int,
	project_id int,
	lab_id int,
	profile_id int,
	datetime_view timestamp not null,
	foreign key(user_id) references USER(user_id),
	foreign key(institution_id) references INSTITUTION(institution_id),
	foreign key(project_id) references PROJECT(project_id),
	foreign key(lab_id) references LAB(lab_id),
	foreign key(profile_id) references PROFILE(profile_id)
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
	foreign key(institution_id) references INSTITUTION(institution_id),
	foreign key(project_id) references PROJECT(project_id),
	foreign key(lab_id) references LAB(lab_id),
	foreign key(profile_id) references PROFILE(profile_id)
) ENGINE=InnoDB;
