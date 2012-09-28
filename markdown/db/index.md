# gosexy/db

This package is an abstraction for wrappers of popular third party SQL and No-SQL database drivers.

The main goal of this abstraction is to provide a common, simplified and consistent layer for generic tasks,
such as *deleting*, *updating*, *removing*, *counting* and *finding* rows without the need of SQL statements.

For any special database-specific operation, the low-level driver is still exposed, as it could be retrieved
as an ``interface{}`` using a method in the ``db.Database`` structure.

## Installation

Use ``go get`` to download and install ``github.com/gosexy/db``.

    % go get github.com/gosexy/db

The ``github.com/gosexy/db`` package provides the basics for using wrappers but it cannot connect to any
database by itself, in order to connect to a database a wrapper is required.

Each low-level driver has it's own requeriments, please refer to the wrapper page to know how to install it.

## Database wrappers

* [mongo](/db/wrappers/mongo)
* [mysql](/db/wrappers/mysql)
* [postgresql](/db/wrappers/postgresql)
* [sqlite](/db/wrappers/sqlite)

## Usage example

Here's an example on how to connect to a MySQL database with the ``github.com/gosexy/db`` package.

### 1. Import the wrapper

After installing the wrapper, import it into your project's code.

```go
import "github.com/gosexy/db/mysql"
```

### 2. Set up the source

Use the ``db.Session`` method of your driver to create a database session.

```go
// returns a *db.Database object.
sess := mysql.Session(
  db.DataSource{
    Host:     "localhost",
    Database: "test",
    User:     "myuser",
    Password: "mypass",
  },
)
```

The ``db.DataSource`` type is a generic structure than stores database connection settings:

```go
// Connection and authentication data.
type DataSource struct {
  Host     string
  Port     int
  Database string
  User     string
  Password string
}
```

### 3. Request a connection.

Use your ``db.Database`` object (``sess``) to request the driver to connect to a database using its
``db.Database.Open()`` method.

```go
// Setting up database.
sess := mysql.Session(
  db.DataSource{
    Host:     "localhost",
    Database: "test",
    User:     "myuser",
    Password: "mypass",
  },
)

// Requesting the driver to connect to the database.
err := sess.Open()

// Don't forget to close the connection when it's not required anymore.
if err != nil {
  defer sess.Close()
}
```

### 4. Choosing a collection or a table

```go
people := sess.Collection("people")

items := people.FindAll(
  db.Cond { "name": "Peter" },
)

for _, item := range items {
  fmt.Printf("Peter's last name: %s\n", item.GetString("last_name"))
}
```

## Full code examples

Of course we have:

* [Example](https://github.com/gosexy/db/blob/master/mongo/examples/mongo.go) and [test file](https://github.com/gosexy/db/blob/master/mongo/mongo_test.go) for MongoDB.
* [Test file](https://github.com/gosexy/db/blob/master/mysql/mysql_test.go) for MySQL
* [Test file](https://github.com/gosexy/db/blob/master/postgresql/postgresql_test.go) for PostgreSQL
* [Test file](https://github.com/gosexy/db/blob/master/sqlite/sqlite_test.go) for SQLite3

Don't worry about SQL databases not having an example, just use the [MongoDB example](https://github.com/gosexy/db/blob/master/mongo/examples/mongo.go) and change the driver name.

## What's next?

Now that you are connected to a database you can use [Database](/db/database) or [Collection](/db/collection) methods.
