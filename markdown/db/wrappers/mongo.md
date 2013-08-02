# MongoDB wrapper

This package is a wrapper of [mgo](http://labix.org/mgo), a MongoDB driver by
[Gustavo Niemeyer](http://labyx.org).

## Usage example

### 1. Get the wrapper

Package pre-requisites:

The [bazaar](http://bazaar.canonical.com/en/) version control system is required
to install `mgo`.

```sh
# OSX
brew install bzr

# Debian based distro.
sudo aptitude install bzr

# ArchLinux
sudo pacman -S bzr
```

Installing the package.

```sh
go get -u menteslibres.net/gosexy/db
go get -u menteslibres.net/gosexy/db/mongo
```

### 1. Import the wrapper

Import both the `gosexy/db` and the `gosexy/db/mongo` packages. The driver
package must be imported to the
[blank identifier](http://golang.org/doc/effective_go.html#blank) as we are not
going to use any of its methods directly.

```go
import (
  "menteslibres.net/gosexy/db"
  // Note the underscore at the beginning
  _ "menteslibres.net/gosexy/db/mongo"
)
```

### 3. Define how to connect to the database

Use a `db.DataSource` variable to store the database settings.

```go
var settings = db.DataSource{
  Host:     "localhost",
  Database: "test",
}
```

### 3. Connect to the source.

Use `db.Open()` to request a connection to the database and
`db.Database.Close()` to close it.

```go
// func db.Open(driverName string, settings db.DataSource)
// --> (db.Database, error)
sess, err := db.Open("mongo", settings)

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

For a few more code examples on MongoDB and `gosexy/db` see:

* [Example](https://github.com/gosexy/db/blob/master/_examples/mongo/main.go)
* [Test file](https://github.com/gosexy/db/blob/master/mongo/mongo_test.go)
