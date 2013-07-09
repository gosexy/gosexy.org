# Database wrappers

*Wrappers* are packages that wrap the functions of a *database driver*.

A *database driver* does the low level communication with a database server.

## Available drivers on gosexy/db

* **[mongo](/gosexy/db/wrappers/mongo)** for [MongoDB](http://mongodb.org), wraps
  [mgo](http://labix.org/mgo) by [Gustavo Niemeyer](http://labyx.org).
* **[mysql](/gosexy/db/wrappers/mysql)** for [MySQL](http://mysql.org), wraps
  [Go-MySQL-Driver](https://github.com/Go-SQL-Driver/MySQL) by
  [Julien Schmidt](http://www.julienschmidt.com/).
* **[postgresql](/gosexy/db/wrappers/postgresql)** for
  [PostgreSQL](http://postgresql.org), wraps
  [pq](https://github.com/bmizerany/pq) by
  [Blake Mizarany](http://blakemizerany.com/) with
  [few modifications](https://github.com/xiam/gopostgresql).
* **[sqlite](/gosexy/db/wrappers/sqlite)** for [SQLite3](http://sqlite.org), wraps
  [sqlite3](https://github.com/mattn/go-sqlite3) by
  [Yasuhiro Matsumoto](http://mattn.kaoriya.net/) with
  [few modifications](https://github.com/xiam/gosqlite3).

