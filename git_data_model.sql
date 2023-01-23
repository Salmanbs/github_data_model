CREATE TABLE users (
id BIGSERIAL PRIMARY KEY NOT NULL,
name VARCHAR (255) NOT NULL,
email VARCHAR (255) NOT NULL,
password VARCHAR(255) NOT NULL,
created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT(NOW() AT TIME ZONE 'UTC'),
UNIQUE (email)
);


INSERT INTO users (name, email, password)
VALUES ('salman', 'sal@gmail.com','pass1');

INSERT INTO users (name, email, password)
VALUES ('salman2', 'sal2@gmail.com','pass2');

INSERT INTO users (name, email, password)
VALUES ('salman3', 'sal3@gmail.com','pass3');

SELECT * FROM users;

CREATE TABLE repos (
id BIGSERIAL PRIMARY KEY NOT NULL,
name VARCHAR (255) NOT NULL,
description VARCHAR (255) NOT NULL,
created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT(NOW() AT TIME ZONE 'UTC'),
updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT(NOW() AT TIME ZONE 'UTC'),
visibility VARCHAR(255) NOT NULL
);

INSERT INTO repos (name,description,visibility)
VALUES ('repo1','first repo of sal', 'private');


INSERT INTO repos (name,description,visibility)
VALUES ('repo2','second repo of sal', 'public');

SELECT * FROM repos;

CREATE TABLE user_repos(
  repo_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  access_level VARCHAR(255) NOT NULL,
  FOREIGN KEY  (repo_id) REFERENCES repos(id),
  FOREIGN KEY  (user_id) REFERENCES users(id)
);

CREATE INDEX index_repo_access ON user_repos(repo_id,access_level);

INSERT INTO user_repos (repo_id,user_id,access_level)
VALUES (1,1,'owner');


INSERT INTO user_repos (repo_id,user_id,access_level)
VALUES (1,2,'collaborator');

SELECT * FROM user_repos;


CREATE TABLE commits(
  hash VARCHAR(255) PRIMARY KEY NOT NULL,
  parent_commit VARCHAR (255),
  user_id BIGINT NOT NULL REFERENCES users(id),
  messages TEXT,
  created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT(NOW() AT TIME ZONE 'UTC'),
  repo_id BIGINT NOT NULL,
  FOREIGN KEY (repo_id) REFERENCES repos(id),
  FOREIGN KEY (parent_commit) REFERENCES commits(hash),
  UNIQUE (hash)
);

CREATE INDEX index_parent_commit ON commits(parent_commit);
CREATE INDEX index_commit_repo ON commits(repo_id);

INSERT INTO commits (hash, user_id,messages,repo_id)
VALUES ('abcd', 1,'message1',1);

INSERT INTO commits (hash, parent_commit ,user_id,messages,repo_id)
VALUES ('efgh','abcd', 1,'message2',1);

INSERT INTO commits (hash,parent_commit, user_id,messages,repo_id)
VALUES ('ijkl','efgh', 1,'message3',1);

INSERT INTO commits (hash,parent_commit, user_id,messages,repo_id)
VALUES ('mnop','ijkl', 1,'message4',1);

INSERT INTO commits (hash,parent_commit, user_id,messages,repo_id)
VALUES ('pqrs','mnop', 1,'message5',1);

INSERT INTO commits (hash, user_id,messages,repo_id)
VALUES ('aaa1', 2,'message5',2);

SELECT * FROM commits;


CREATE TABLE branches(
  id BIGSERIAL PRIMARY KEY NOT NULL,
  name VARCHAR (255) NOT NULL,
  head_pointer VARCHAR(255) NOT NULL,
  parent_branch BIGINT REFERENCES branches,
  merge_status VARCHAR (255) ,
  created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT(NOW() AT TIME ZONE 'UTC'),
  updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT(NOW() AT TIME ZONE 'UTC'),
  repo_id BIGINT NOT NULL,
  FOREIGN KEY (head_pointer) REFERENCES commits(hash),
  FOREIGN KEY (repo_id) REFERENCES repos(id),
  FOREIGN KEY (parent_branch) REFERENCES branches(id)
);

CREATE INDEX index_branches_repo ON branches(repo_id);


INSERT INTO branches (name,head_pointer,merge_status,repo_id)
VALUES ('master','abcd', 'merged',1);

INSERT INTO branches (name,head_pointer,parent_branch,merge_status,repo_id)
VALUES ('branch2','ijkl', 1,'unmerged',1);


SELECT * FROM branches;


CREATE TABLE issues (
  id BIGSERIAL PRIMARY KEY NOT NULL,
  title VARCHAR (255) NOT NULL,
  user_id BIGINT NOT NULL,
  created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT(NOW() AT TIME ZONE 'UTC'),
  updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT(NOW() AT TIME ZONE 'UTC'),
  status TEXT NOT NULL,
  type  VARCHAR(255) NOT NULL,
  repo_id BIGINT NOT NULL,
  FOREIGN KEY (repo_id) REFERENCES repos(id),
  FOREIGN KEY (user_id) REFERENCES users(id)

);

INSERT INTO issues (title,user_id,status,type,repo_id)
VALUES ('ISSUE2', 2,'unresolved','bug',1);

INSERT INTO issues (title,user_id,status,type,repo_id)
VALUES ('ISSUE1', 2,'resolved','feature_request',1);


SELECT * FROM issues;

CREATE TABLE issue_comments (
  id BIGSERIAL PRIMARY KEY NOT NULL,
  issue_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT(NOW() AT TIME ZONE 'UTC'),
  comments TEXT NOT NULL,
  FOREIGN KEY (issue_id) REFERENCES issues(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO issue_comments (issue_id,user_id,comments)
VALUES (1,1,'the button is not working');

SELECT * FROM issue_comments;


CREATE TABLE pull_requests (
  id BIGSERIAL PRIMARY KEY NOT NULL,
  title VARCHAR (255) NOT NULL,
  description VARCHAR (255) NOT NULL,
  user_id BIGINT NOT NULL,
  created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT(NOW() AT TIME ZONE 'UTC'),
  updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT(NOW() AT TIME ZONE 'UTC'),
  source_branch BIGINT NOT NULL,
  target_branch BIGINT NOT NULL,
  status  VARCHAR NOT NULL,
  comments TEXT,
  repo_id BIGINT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (source_branch) REFERENCES branches(id),
  FOREIGN KEY (target_branch) REFERENCES branches(id),
  FOREIGN KEY (repo_id) REFERENCES repos(id)
);


INSERT INTO pull_requests (title,description,user_id,source_branch,target_branch,status,comments,repo_id)
VALUES ('pull1','desc1', 2,2,1,'unmerged','worked on the styles',1);

INSERT INTO pull_requests (title,description,user_id,source_branch,target_branch,status,comments,repo_id)
VALUES ('pull2','desc2', 1,2,1,'raised','worked on the bug',1);

INSERT INTO pull_requests (title,description,user_id,source_branch,target_branch,status,comments,repo_id)
VALUES ('pull3','desc3', 2,2,1,'rejected','worked on the feature pop up',1);

INSERT INTO pull_requests (title,description,user_id,source_branch,target_branch,status,comments,repo_id)
VALUES ('pull4','desc4', 2,2,1,'merged','refactored the code',1);

INSERT INTO pull_requests (title,description,user_id,source_branch,target_branch,status,comments,repo_id)
VALUES ('pull5','desc5', 2,2,1,'merged','refactored the code again',1);


SELECT * FROM pull_requests;

CREATE TABLE pull_request_commits (
  id BIGSERIAL PRIMARY KEY NOT NULL,
  pull_request_id BIGINT NOT NULL,
  commit_hash  VARCHAR(255) NOT NULL,
  FOREIGN KEY (pull_request_id) REFERENCES pull_requests(id),
  FOREIGN KEY (commit_hash) REFERENCES commits(hash)
);


INSERT INTO pull_request_commits (pull_request_id,commit_hash)
VALUES (1,'abcd');

SELECT * FROM pull_request_commits


CREATE TABLE pull_request_reviews (
  id BIGSERIAL PRIMARY KEY NOT NULL,
  pull_request_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT(NOW() AT TIME ZONE 'UTC'),
  message TEXT,
  status VARCHAR(255) NOT NULL,
  FOREIGN KEY (pull_request_id) REFERENCES pull_requests(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO pull_request_reviews (pull_request_id,user_id,message,status)
VALUES (1,1,'feature upgrade','approved');

SELECT * FROM pull_request_reviews


CREATE TABLE files (
  id BIGSERIAL PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL,
  path VARCHAR(255) NOT NULL,
  hash VARCHAR(255) NOT NULL,
  size BIGINT NOT NULL,
  type VARCHAR NOT NULL,
  repo_id BIGINT NOT NULL,
  commit_hash  VARCHAR(255) NOT NULL,
  UNIQUE(hash),
  FOREIGN KEY (repo_id) REFERENCES repos(id),
  FOREIGN KEY (commit_hash) REFERENCES commits(hash)
);

INSERT INTO files (name,path,hash,size,type,repo_id,commit_hash)
VALUES ('file','path1','hhhj',2,'txt',1,'abcd');



-- CREATE TABLE pull_request_reviews (
--   id BIGSERIAL PRIMARY KEY NOT NULL,
--   pull_request_id BIGINT NOT NULL,
--   user_id BIGINT NOT NULL,
--   created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT(NOW() AT TIME ZONE 'UTC'),
-- );

-- number of commits

SELECT COUNT(DISTINCT c.hash) as total_commits
FROM commits as c WHERE c.repo_id = 1
AND c.created_at >=  '2023-01-22' AND c.created_at <= '2023-01-23' ;

-- pull request

SELECT COUNT(DISTINCT pr.id) as total_pull_requests,
SUM(CASE WHEN pr.status ='raised' THEN 1 ELSE 0 END) as
total_pull_requests_raised,
SUM(CASE WHEN pr.status ='merged' THEN 1 ELSE 0 END) as
total_pull_requests_merged,
SUM(CASE WHEN pr.status ='rejected' THEN 1 ELSE 0 END) as
total_pull_requests_rejected,
SUM(CASE WHEN pr.status ='unmerged' THEN 1 ELSE 0 END) as
total_pull_requests_unmerged
FROM pull_requests as pr WHERE pr.repo_id = 1
AND pr.created_at >=  '2023-01-22' AND pr.created_at <= '2023-01-24' ;

-- number of commits, pull request raised, merged, rejected, reviewed.

SELECT u.name, COUNT(DISTINCT c.hash) as total_commits,
COUNT(DISTINCT pr.id) as total_pull_requests,
SUM(CASE WHEN pr.status ='raised' THEN 1 ELSE 0 END) as
total_pull_requests_raised,
SUM(CASE WHEN pr.status ='merged' THEN 1 ELSE 0 END) as
total_pull_requests_merged,
SUM(CASE WHEN pr.status ='rejected' THEN 1 ELSE 0 END) as
total_pull_requests_rejected,
SUM(CASE WHEN pr.status ='unmerged' THEN 1 ELSE 0 END) as
total_pull_requests_unmerged,
COUNT (DISTINCT prr.id) as total_pull_requests_reviewd
FROM users as u
JOIN commits as c on u.id = c.user_id
JOIN pull_requests as pr on u.id = pr.user_id
LEFT JOIN pull_request_reviews as prr ON u.id = prr.user_id
WHERE u.id = 2
GROUP BY u.id;

-- Given pull request ID write minimum number of queries to fetch all the required to render pull request page.

SELECT pr.title,pr.description,pr.user_id,pr.created_at,pr.updated_at,pr.status,
u.name as user_name ,u.email,prc.commit_hash,c.messages,c.user_id as commit_user_id,c.created_at,
u2.name as commit_user_name,u2.email as commit_user_email ,
prr.user_id as pull_request_reviewer_id,u3.name as pull_request_reviewer_name,
u3.email as pull_request_reviewer_email,prr.created_at,prr.message,prr.status
FROM pull_requests as pr 
JOIN users as u ON pr.user_id = u.id
JOIN pull_request_commits as prc ON pr.id = prc.pull_request_id
JOIN commits as c ON prc.commit_hash = c.hash
JOIN users as u2 ON c.user_id =u2.id
LEFT JOIN pull_request_reviews as prr ON pr.id = prr.pull_request_id
LEFT JOIN users as u3 ON prr.user_id = u3.id;


SELECT pr.title,pr.description,pr.user_id,pr.created_at,pr.updated_at,pr.status,
u.name as user_name ,u.email,prc.commit_hash,c.messages,c.user_id as commit_user_id,c.created_at,
u2.name as commit_user_name,u2.email as commit_user_email ,
prr.user_id as pull_request_reviewer_id,u3.name as pull_request_reviewer_name,
u3.email as pull_request_reviewer_email,prr.created_at,prr.message,prr.status
FROM pull_requests as pr 
JOIN users as u ON pr.user_id = u.id
JOIN pull_request_commits as prc ON pr.id = prc.pull_request_id
JOIN commits as c ON prc.commit_hash = c.hash
JOIN users as u2 ON c.user_id =u2.id
JOIN pull_request_reviews as prr ON pr.id = prr.pull_request_id
JOIN users as u3 ON prr.user_id = u3.id;



-- query , indexing ,file table 3 table data pending
--table version
-- repo branches

-- SELECT repo.repo_name,branches.branch_name FROM
--  repo JOIN branches
--   ON repo.repo_id = branches.repo_id ;




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



















