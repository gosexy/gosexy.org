# gosexy/db

The `gosexy/db` package is an abstraction of wrappers for popular third party SQL and No-SQL
database drivers.

Our main goal is to provide a common, simplified and consistent layer for generic database tasks,
such as *deleting*, *updating*, *removing*, *counting* and *finding* rows without the need of writing SQL
statements by hand.

For any special task that is only useful for an specific database the underlying driver can still be used,
it is exposed as an `interface{}`.

## Installation

Use `go get` to download and install `gosexy/db`.

```sh
% go get github.com/gosexy/db
```

This package provides the basic structures and types but it cannot connect to any
database by itself, in order to connect to a database a *wrapper* is required.

## Database wrappers

Each wrapper has its own requeriments, please refer to the appropriate wrapper's page to read
installing instructions.

* [mongo](/db/wrappers/mongo)
* [mysql](/db/wrappers/mysql)
* [postgresql](/db/wrappers/postgresql)
* [sqlite](/db/wrappers/sqlite)

## Usage example

Here's an example on how to connect to a [PostgreSQL](http://postgresql.org) database.

Go to the [PostgreSQL driver](/db/wrappers/postgresql)'s page to read
instructions on how to install the wrapper.

### 1. Import the wrapper

Once the wrapper is installed, import it into your project.

```go
import (
  "github.com/gosexy/db"
  _ "github.com/gosexy/db/postgresql"
)
```

### 2. Set up the source

Store your database credentials in a variable.

```go
settings := db.DataSource{
  Host:     "localhost",
  Database: "test",
  User:     "myuser",
  Password: "mypass",
}
```

### 3. Connect to the source.

Use `db.Open()` to actually connect to the database using the variable you've just created, the
first argument must be the driver's name (`"postgresql"` in this case).

```go
// func db.Open(string, db.DataSource) -> (db.Database, error).
sess, err := db.Open("postgresql", settings)

if err != nil {
  panic(err)
}

// func db.Database.Close() -> error
defer sess.Close()
```

### 4. Query collections

Request a collection from the database using `db.Database.Collection()`, and send queries to the
collection to retrieve data.

```go
// func db.Database.Collection(string) -> (db.Collection, error)
people, _ := sess.Collection("people")

// func db.Collection.FindAll(...interface{}) -> []db.Item
items := people.FindAll(
  // Query condition
  db.Cond { "name": "Peter" },
)

// Looping over the results.
for _, item := range items {
  // func db.Item.GetString(string) -> string
  fmt.Printf("Last name: %s\n", item.GetString("last_name"))
}
```
## What's next?

Now that you are connected to a database you can use the [db.Database](/db/database) and
[db.Collection](/db/collection) methods to create queries and retrieve results.

## More code examples

* For MongoDB
  * [Example](https://github.com/gosexy/db/blob/master/_examples/mongo/main.go)
  * [Test file](https://github.com/gosexy/db/blob/master/mongo/mongo_test.go).
* For MySQL
  * [Example](https://github.com/gosexy/db/blob/master/_examples/mysql/main.go)
  * [Test file](https://github.com/gosexy/db/blob/master/mysql/mysql_test.go).
* For PostgreSQL
  * [Example](https://github.com/gosexy/db/blob/master/_examples/postgresql/main.go)
  * [Test file](https://github.com/gosexy/db/blob/master/postgresql/postgresql_test.go).
* For SQLite
  * [Example](https://github.com/gosexy/db/blob/master/_examples/sqlite/main.go)
  * [Test file](https://github.com/gosexy/db/blob/master/sqlite/sqlite_test.go).

## Got bugs?

Please report bugs and suggestions to the [issues page](https://github.com/gosexy/db/issues).
