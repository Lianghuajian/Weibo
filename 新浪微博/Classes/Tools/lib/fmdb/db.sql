-- 微博表 --
CREATE TABLE "T_Status" (
"statusId" INTEGER NOT NULL,
"status" TEXT,
"userId" INTEGER,
"createTime" TEXT DEFAULT (datetime('now','localtime')),
PRIMARY KEY("statusId")
);
