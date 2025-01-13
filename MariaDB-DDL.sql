CREATE TABLE "component" (
  "uuid" varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
  "ver" int DEFAULT NULL,
  "name" varchar(400) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "_type" varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "subType" varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "createdBy" varchar(128) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "deleted" varchar(12) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "currentVersion" varchar(12) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "folderName" varchar(128) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "folderId" varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "branchName" varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "prodPackageId" varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "parentUUID" varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY ("uuid")
);

CREATE TABLE "componentMap" (
  "uuid" varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
  "ver" int NOT NULL,
  "fromProfile" varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "fromProfileType" varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "toProfile" varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "toProfileType" varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "fromKey" varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
  "fromPath" varchar(400) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "toKey" varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
  "toPath" varchar(400) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY ("uuid","ver","fromKey","toKey"),
  CONSTRAINT "component_uuidFK" FOREIGN KEY ("uuid") REFERENCES "component" ("uuid")
);

CREATE TABLE "componentShape" (
  "uuid" varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
  "ver" int NOT NULL,
  "shapeName" varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "step" int NOT NULL,
  "shapeType" varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "shapeImage" varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "toShape" varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "shapeUUID" varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  "connectorType" varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  "opId" varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  "opType" varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY ("uuid","ver","step")
);

CREATE VIEW "vwComponentMap" AS
select
    "c"."uuid" AS "uuid",
    "c"."ver" AS "ver",
    "c"."name" AS "name",
    "cm"."fromPath" AS "fromPath",
    "cm"."fromProfileType" AS "fromProfileType",
    "cm"."toPath" AS "toPath",
    "cm"."toProfileType" AS "toProfileType"
from
    ("component" "c"
join "componentMap" "cm" on
    ((("c"."uuid" = "cm"."uuid")
        and ("c"."ver" = "cm"."ver"))));

CREATE VIEW "vwProcessConnection" AS with "ivCon" as (
select
    "cs"."uuid" AS "uuid",
    "cs"."ver" AS "ver",
    "cs"."shapeName" AS "shapeName",
    "cs"."step" AS "step",
    "cs"."shapeType" AS "shapeType",
    "cs"."shapeImage" AS "shapeImage",
    "cs"."toShape" AS "toShape",
    "cs"."shapeUUID" AS "shapeUUID",
    "cs"."connectorType" AS "connectorType",
    "cs"."opId" AS "opId"
from
    "componentShape" "cs"
where
    (("cs"."shapeType" in ('connectoraction', 'map'))
        and ("cs"."toShape" is not null)
            and ("cs"."toShape" <> 'unset')))
select
    "iv"."uuid" AS "uuid",
    "iv"."ver" AS "ver",
    "iv"."shapeName" AS "shapeName",
    "iv"."step" AS "step",
    "iv"."shapeType" AS "shapeType",
    "iv"."shapeImage" AS "shapeImage",
    "iv"."toShape" AS "toShape",
    "iv"."shapeUUID" AS "shapeUUID",
    "iv"."connectorType" AS "connectorType",
    "iv"."opId" AS "opId"
from
    ("component" "c"
join "ivCon" "iv" on
    (("c"."uuid" = "iv"."uuid")));
