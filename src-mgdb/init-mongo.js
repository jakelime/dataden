// init-mongo.js

const root = process.env.MONGO_INITDB_ROOT_USERNAME;
const root_pwd = process.env.MONGO_INITDB_ROOT_PASSWORD;
const dbadmin = process.env.MONGO_ADMIN_DBADMIN;
const dbadmin_pwd = process.env.MONGO_ADMIN_DBADMIN_PASSWORD;

const user_app = process.env.MONGO_USER_APP;
const user_app_pwd = process.env.MONGO_USER_APP_PASSWORD;
const user_reader = process.env.MONGO_USER_READER;
const user_reader_pwd = process.env.MONGO_USER_READER_PASSWORD;

const dbname01 = "gmail_bucket"
const db01_collection01 = "raw";

db = db.getSiblingDB("admin");
console.log(`switched to DB(admin)`);
db.createUser({
  user: root,
  pwd: root_pwd,
  roles: [{ role: "root", db: "admin" }],
});
console.log(`created user root=${root}`);

db.createUser({
  user: user_app,
  pwd: user_app_pwd,
  roles: [
    { role: "dbAdmin", db: dbname01 },
    { role: "readWrite", db: dbname01 },
  ],
});
console.log(`created user user_app=${user_app}`);

db.createUser({
  user: user_reader,
  pwd: user_reader_pwd,
  roles: [{ role: "read", db: db01_collection01 }],
});
console.log(`created user user_reader=${user_reader}`);

db.createUser({
  user: dbadmin,
  pwd: dbadmin_pwd,
  roles: [
    { role: "dbOwner", db: "admin" },
    { role: "dbAdmin", db: dbname01 },
    { role: "userAdmin", db: dbname01 },
  ],
});
console.log(`created user dbadmin=${dbadmin}`);



db = db.getSiblingDB(dbname01);
console.log(`switched to DB(${dbname01})`);
db.createCollection(`${db01_collection01}`, {
  timeseries: {
    timeField: "timestamp",
    metaField: "metadata",
    granularity: "seconds",
  },
});
console.log(`created collection=${db01_collection01}`);

// db = db.getSiblingDB("admin");
// console.log(`switched to DB(admin)`);
