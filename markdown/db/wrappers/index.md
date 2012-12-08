# Database wrappers

*Wrappers* are packages that wrap the functions of a *database driver*.

A *database driver* does the low level communication with a database server.

## Available drivers on gosexy/db

* **[mongo](/db/wrappers/mongo)** for [MongoDB](http://mongodb.org), based on [mgo](http://labix.org/mgo) by [Gustavo Niemeyer](http://labyx.org).
* **[mysql](/db/wrappers/mysql)** for [MySQL](http://mysql.org), based on [go-mysql-driver](http://code.google.com/p/go-mysql-driver/) by [Julien Schmidt](http://www.julienschmidt.com/).
* **[postgresql](/db/wrappers/postgresql)** for [PostgreSQL](http://postgresql.org), based on [pq](https://github.com/bmizerany/pq) by [Blake Mizarany](http://blakemizerany.com/) with [few modifications](https://github.com/xiam/gopostgresql).
* **[sqlite](/db/wrappers/sqlite)** for [SQLite3](http://sqlite.org), based on [sqlite3](https://github.com/mattn/go-sqlite3) by [Yasuhiro Matsumoto](http://mattn.kaoriya.net/) with [few modifications](https://github.com/xiam/gosqlite3).

