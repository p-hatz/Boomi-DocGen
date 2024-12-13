CREATE TABLE component (
  uuid varchar(64) NOT NULL,
  ver int DEFAULT NULL,
  name varchar(400) DEFAULT NULL,
  _type varchar(64) DEFAULT NULL,
  subType varchar(64) DEFAULT NULL,
  createdBy varchar(128) DEFAULT NULL,
  deleted varchar(12) DEFAULT NULL,
  currentVersion varchar(12) DEFAULT NULL,
  folderName varchar(128) DEFAULT NULL,
  folderId varchar(32) DEFAULT NULL,
  branchName varchar(64) DEFAULT NULL,
  prodPackageId varchar(64) DEFAULT NULL,
  PRIMARY KEY (uuid)
);

CREATE TABLE componentMap (
  uuid varchar(64) NOT NULL,
  ver int NOT NULL,
  fromProfile varchar(64) DEFAULT NULL,
  fromProfileType varchar(64) DEFAULT NULL,
  toProfile varchar(64) DEFAULT NULL,
  toProfileType varchar(64) DEFAULT NULL,
  fromKey varchar(128) NOT NULL,
  fromPath varchar(400) DEFAULT NULL,
  toKey varchar(128) NOT NULL,
  toPath varchar(400) DEFAULT NULL,
  PRIMARY KEY (uuid,ver,fromKey,toKey),
  CONSTRAINT component_uuidFK FOREIGN KEY (uuid) REFERENCES component (uuid)
);


CREATE TABLE componentShape (
  uuid varchar(64) NOT NULL,
  ver int NOT NULL,
  shapeName varchar(64) DEFAULT NULL,
  step int NOT NULL,
  shapeType varchar(32) DEFAULT NULL,
  shapeImage varchar(64) DEFAULT NULL,
  toShape varchar(64) DEFAULT NULL,
  shapeUUID varchar(64) CHARACTER SET utf8mb4 DEFAULT NULL,
  connectorType varchar(64) CHARACTER SET utf8mb4 DEFAULT NULL,
  opId varchar(64) COLLATE  DEFAULT NULL,
  PRIMARY KEY (uuid,ver,step)
);
