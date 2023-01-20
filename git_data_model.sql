CREATE TABLE users (
user_id BIGSERIAL PRIMARY KEY NOT NULL,
user_name VARCHAR (255) NOT NULL,
email VARCHAR (255) NOT NULL,
password VARCHAR(255) NOT NULL,
UNIQUE (user_id)
);


INSERT INTO users (user_name, email, password)
VALUES ('salman', 'sal@gmail.com','pass1');

INSERT INTO users (user_name, email, password)
VALUES ('salman2', 'sal2@gmail.com','pass2');

INSERT INTO users (user_name, email, password)
VALUES ('salman3', 'sal3@gmail.com','pass3');

SELECT * FROM users;

CREATE TABLE repo (
repo_id BIGSERIAL PRIMARY KEY NOT NULL,
repo_name VARCHAR (255) NOT NULL,
descriptions VARCHAR (255) NOT NULL,
owner_id  BIGINT REFERENCES users(user_id),
files text ,
UNIQUE (repo_id)
);

INSERT INTO repo (repo_name,descriptions, owner_id,files)
VALUES ('repo1','first repo of sal', 1, 'file1');

SELECT * FROM repo;

CREATE TABLE collaborators(
  repo_id BIGINT,
  collaborator_id BIGINT,
  FOREIGN KEY  (repo_id) REFERENCES users(user_id),
  FOREIGN KEY  (collaborator_id) REFERENCES users(user_id)
);

INSERT INTO collaborators (repo_id,collaborator_id)
VALUES (1,2);

INSERT INTO collaborators (repo_id,collaborator_id)
VALUES (1,3);

SELECT * FROM collaborators;


CREATE TABLE commits(
  commit_hash VARCHAR(255) PRIMARY KEY NOT NULL,
  parent_commit VARCHAR (255),
  author BIGINT REFERENCES users(user_id),
  messages TEXT,
  dates DATE,
  repo_id BIGINT,
  FOREIGN KEY (repo_id) REFERENCES repo(repo_id),
  FOREIGN KEY (parent_commit) REFERENCES commits(commit_hash),
  UNIQUE (commit_hash)
);

INSERT INTO commits (commit_hash, author,messages,dates,repo_id)
VALUES ('abcd', 1,'message1', '2022-01-01',1);

INSERT INTO commits (commit_hash, parent_commit ,author,messages,dates,repo_id)
VALUES ('efgh','abcd', 1,'message2', '2022-02-01',1);

INSERT INTO commits (commit_hash,parent_commit, author,messages,dates,repo_id)
VALUES ('ijkl','efgh', 1,'message3', '2022-03-01',1);


SELECT * FROM commits;


CREATE TABLE branches(
  branch_id BIGSERIAL PRIMARY KEY NOT NULL,
  branch_name VARCHAR (255),
  head_pointer VARCHAR(255) ,
  parent_branch BIGINT REFERENCES branches,
  merge_status VARCHAR (255),
  dates date NOT NULL,
  repo_id BIGINT,
  FOREIGN KEY (head_pointer) REFERENCES commits(commit_hash),
  FOREIGN KEY (repo_id) REFERENCES repo(repo_id),
  FOREIGN KEY (parent_branch) REFERENCES branches(branch_id),
  UNIQUE (branch_id)
);


INSERT INTO branches (branch_name,head_pointer,merge_status,dates,repo_id)
VALUES ('master','abcd', 'merged','2022-02-01',1);

INSERT INTO branches (branch_name,head_pointer,parent_branch,merge_status,dates,repo_id)
VALUES ('branch2','ijkl', 1,'unmerged', '2022-01-01',1);


SELECT * FROM branches;


CREATE TABLE issues (
  issue_id BIGSERIAL PRIMARY KEY NOT NULL,
  title VARCHAR (255),
  author BIGINT ,
  statuses TEXT,
  dates DATE,
  comments TEXT,
  repo_id BIGINT,
  UNIQUE (issue_id),
  FOREIGN KEY (repo_id) REFERENCES repo(repo_id),
  FOREIGN KEY (author) REFERENCES users(user_id)

);

INSERT INTO issues (title,author,statuses,dates,comments,repo_id)
VALUES ('ISSUE2', 2,'unresolved', '2022-02-01','work on the bug b',1);

INSERT INTO issues (title,author,statuses,dates,comments,repo_id)
VALUES ('ISSUE1', 2,'resolved', '2022-01-01','work on the styles',1);


SELECT * FROM issues;

CREATE TABLE pull_requests (
  pull_request_id BIGSERIAL PRIMARY KEY,
  title VARCHAR (255),
  descriptions VARCHAR (255) NOT NULL,
  author BIGINT ,
  source_branch BIGINT ,
  target_branch BIGINT,
  commit_id VARCHAR,
  statuses  VARCHAR,
  dates DATE,
  comments TEXT,
  repo_id BIGINT,
  UNIQUE (pull_request_id),
  FOREIGN KEY (author) REFERENCES users(user_id),
  FOREIGN KEY (source_branch) REFERENCES branches(branch_id),
  FOREIGN KEY (target_branch) REFERENCES branches(branch_id),
  FOREIGN KEY (commit_id) REFERENCES commits(commit_hash),
  FOREIGN KEY (repo_id) REFERENCES repo(repo_id)
);


INSERT INTO pull_requests (title,descriptions,author,source_branch,target_branch,commit_id,statuses,dates,comments,repo_id)
VALUES ('Ipull1','desc1', 2,2,1,'abcd','unmerged', '2022-01-01','worked on the styles',1);


SELECT * FROM pull_requests;



-- repo branches

SELECT repo.repo_name,branches.branch_name FROM
 repo JOIN branches
  ON repo.repo_id = branches.repo_id ;




-- --collaboarators

-- SELECT *
-- FROM repo JOIN collaborators
--  ON repo.repo_id = collaborators.collaborator_id ; 




-- CREATE TABLE repo (
-- repo_id BIGSERIAL PRIMARY KEY NOT NULL,
-- repo_name VARCHAR (255) NOT NULL,
-- descriptions VARCHAR (255) NOT NULL,
-- owner_id  BIGINT REFERENCES users(user_id),
-- collaborators BIGINT REFERENCES users(user_id),
-- files text ,
-- UNIQUE (repo_id)
-- );

-- INSERT INTO repo (repo_name,descriptions, owner_id,collaborators,files,history)
-- VALUES ('repo1','first repo of sal', 1,2, 'file1','abcd');


-- SELECT * FROM repo;


-- CREATE TABLE branches(
--   branch_id BIGSERIAL PRIMARY KEY NOT NULL,
--   branch_name VARCHAR (255),
--   head_pointer VARCHAR(255) ,
--   parent_branch BIGINT REFERENCES branches,
--   merge_status VARCHAR (255),
--   dates date NOT NULL,
--   repo_id BIGINT,
--   FOREIGN KEY (head_pointer) REFERENCES commits(commit_hash),
--   FOREIGN KEY (repo_id) REFERENCES repo(repo_id),
--   FOREIGN KEY (parent_branch) REFERENCES branches(branch_id),
--   UNIQUE (branch_id)
-- );


-- INSERT INTO branches (branch_name,head_pointer,merge_status,dates,repo_id)
-- VALUES ('master','abcd', 'merged','2022-02-01',1);

-- INSERT INTO branches (branch_name,head_pointer,parent_branch,merge_status,dates,repo_id)
-- VALUES ('branch2','ijkl', 1,'unmerged', '2022-01-01',1);


-- SELECT * FROM branches;


















-- CREATE TABLE branches(
--   branch_id BIGSERIAL (255) PRIMARY KEY NOT NULL,
--   branch_name VARCHAR (255),
--   head_pointer BIGINT REFERENCES commits(commit_hash),
--   parent_branch BIGINT REFERENCES branches,
--   dates date NOT NULL,
-- FOREIGN KEY (parent_branch) REFERENCES branches(branch_id),
-- UNIQUE (branch_id)
-- )


-- INSERT INTO branches (branch_name,head_pointer)
-- VALUES ('repo1','first repo of sal', 1,2, 'file1','abcd');

-- INSERT INTO branches (branch_name,head_pointer,parent_branch)
-- VALUES ('repo1','first repo of sal', 1,2, 'file1','abcd');



-- CREATE TABLE issues (
--   issue_id BIGSERIAL (255) PRIMARY KEY NOT NULL,
--   title VARCHAR (255),
--   author BIGINT ,
--   statuses TEXT,
--   dates DATE,
--   comments TEXT,
--   repo_id BIGINT,
--   UNIQUE (issue_id),
--   FOREIGN KEY (repo_id) REFERENCES repo(repo_id),
--   FOREIGN KEY (author) REFERENCES users(user_id)

-- );

-- INSERT INTO issues (title,author,statuses,dates,comments,repo_id)
-- VALUES ('ISSUE2', 2,'unresolved', '2022-02-01','work on the bug b',1);

-- INSERT INTO issues (title,author,statuses,dates,comments,repo_id)
-- VALUES ('ISSUE1', 2,'resolved', '2022-01-01','work on the styles',1);

-- -- INSERT INTO issues (titile, author,statuses,dates,comments)
-- -- VALUES ('abcd', 1,'message1', '2022-01-01')

-- CREATE TABLE branches(
--   branch_id BIGSERIAL (255) PRIMARY KEY NOT NULL,
--   branch_name VARCHAR (255),
--   -- commit_history VARCHAR REFERENCES commits(commit_hash),
--   head_pointer BIGINT REFERENCES commits(commit_hash),
--   parent_branch BIGINT REFERENCES branches,
--   dates date NOT NULL,
--   -- repo_id BIGINT REFERENCES repo(repo_id)
-- FOREIGN KEY (parent_branch) REFERENCES branches(branch_id),
-- UNIQUE (branch_id)
-- )

-- CREATE TABLE pull_requests (
--   pull_requests_id BIGSERIAL (255) PRIMARY KEY,
--   title VARCHAR (255),
--   descriptions VARCHAR (255) NOT NULL,
--   author BIGINT REFERENCES users(user_id),
--   source_branch BIGINT REFERENCES branches(branch_id),
--   target_branch BIGINT REFERENCES branches (branch_id),
--   commit_id BIGINT REFERENCES commits(commit_hash),
--   statuses  VARCHAR,
--   dates DATE,
--   comments TEXT,
--   UNIQUE (pull_requests_id)
-- )

-- -- repo contains commit 

-- CREATE TABLE repo (
-- repo_id BIGSERIAL NOT NULL,
-- repo_name VARCHAR (255) NOT NULL,
-- descriptions VARCHAR (255) NOT NULL,
-- branch_id BIGINT REFERENCES branches(branch_id),
-- owner_id  BIGINT REFERENCES users(user_id),
-- collaborators BIGINT REFERENCES users(user_id),
-- issues BIGINT REFERENCES issues(issue_id),
-- pull_requests BIGINT REFERENCES pull_request(pull_request_id),
-- files text ,
-- history VARCHAR REFERENCES commits(commit_hash)
--  UNIQUE (repo_id)
-- );



















