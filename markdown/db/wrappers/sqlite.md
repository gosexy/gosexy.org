# SQLite3 wrapper

This package is a wrapper of [sqlite3](https://github.com/mattn/go-sqlite3), a
SQLite3 driver by [Yasuhiro Matsumoto](http://mattn.kaoriya.net/).


## Usage example

### 1. Get the wrapper

Package pre-requisites:

```sh
# OSX
brew install pkg-config
brew install sqlite3

# ArchLinux.
sudo pacman -S pkg-config
sudo pacman -S sqlite3

# Debian based distro.
sudo aptitude install pkg-config
sudo aptitude install libsqlite3-dev
```

Installing the package

```sh
go get -u menteslibres.net/gosexy/db
go get -u menteslibres.net/gosexy/db/sqlite
```

### 1. Import the wrapper

Import both the `gosexy/db` and the `gosexy/db/sqlite` packages. The driver
package must be imported to the
[blank identifier](http://golang.org/doc/effective_go.html#blank) as we are not
going to use any of its methods directly.

```go
import (
  "menteslibres.net/gosexy/db"
  // Note the underscore at the beginning
  _ "menteslibres.net/gosexy/db/sqlite"
)
```

### 3. Define how to connect to the database

Use a `db.DataSource` variable to store the database settings.

```go
var settings = db.DataSource{
  Host:     "localhost",
  Database: "/home/foo/database.db",
  User:     "myuser",
  Password: "mypass",
}
```

### 3. Connect to the source.

Use `db.Open()` to request a connection to the database and
`db.Database.Close()` to close it.

```go
// func db.Open(driverName string, settings db.DataSource)
// --> (db.Database, error)
sess, err := db.Open("sqlite", settings)

if err != nil {
  panic(err)
}

defer sess.Close()
```

### 4. Query collections

You can refer to a specific table with `db.Database.Collection()`, use the
returned `db.Collection` value to query the collection.

```go
// func db.Database.Collection(tableName string)
// --> (db.Collection, error)
people, _ := sess.Collection("people")

// func db.Collection.FindAll(...interface{})
// --> ([]db.Item, error)
items, err := people.FindAll(
  // Query condition
  db.Cond { "name": "Peter" },
)

if err != nil {
  panic(err.Error())
}

// Looping over the results.
for _, item := range items {
  fmt.Printf("Last name: %s\n", item["last_name"])
}
```

### 5. What's next?

Congratulations!

Now that you know how to connecto to a database with `gosexy/db` you can use
all the [db.Database](/gosexy/db/database) and
[db.Collection](/gosexy/db/collection) methods.

For a few more code examples on SQLite3 and `gosexy/db` see:

* [Example](https://github.com/gosexy/db/blob/master/_examples/sqlite/main.go)
* [Test file](https://github.com/gosexy/db/blob/master/sqlite/sqlite_test.go)

## Wrapper author's note

In order to work with `gosexy/db` the original driver had to be
[forked][1], the changes we made to it were incompatible with some of
[sqlite3][2]'s own features.

[1]: https://github.com/xiam/gopostgresql
[2]: https://github.com/mattn/go-sqlite3
