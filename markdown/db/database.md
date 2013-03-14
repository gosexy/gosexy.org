# db.Database

The ``db.Database`` type is an interface that defines methods for common tasks
on databases.

```go
type Database interface {
  /*
    Returns an interface{} to the underlying driver the wrapper
    uses. Useful for custom SQL queries.
  */
  Driver() interface{}

  /*
    Closes the currently active connection to the database, if
    any.
  */
  Close() error

  /*
    Returns a db.Collection struct by name. Returns an error if
    the collection does not exists.
  */
  Collection(string) (Collection, error)

  /*
    Returns a db.Collection struct, panics if the collection
    does not exists.
  */
  ExistentCollection(string) Collection
  /*
    Returns the names of all the collections in the active
    database.
  */
  Collections() []string

  /*
    Changes the active database.
  */
  Use(string) error
  /*
    Drops the active database.
  */
  Drop() error

  /*
    Sets the connection data.
  */
  Setup(DataSource) error

  /*
    Returns the name of the active database.
  */
  Name() string
}
```

## Setting up a db.Database object

Use `db.Open` to create and retrieve a `db.Database`.

```go
// Database settings
settings := db.DataSource{
  Host:     "localhost",
  Database: "test",
  User:     "myuser",
  Password: "mypass",
}

// func db.Open(string, db.DataSource) -> (db.Database, error).
sess, err := db.Open("postgresql", settings)

if err != nil {
  panic(err)
}

// func db.Database.Close() -> error
defer sess.Close()
```

## Methods

### db.Database.Driver() *interface{}*

Returns the current wrapper's underlying driver as an `interface{}`, so you can
still use it for any special request. For example, if you're using the
`github.com/gosexy/db/mongo` wrapper this method will return a
`*mgo.Session` object, as the wrapper uses the [mgo](http://labix.org/v2/mgo)
while if you're using any `database/sql` driver you'll have a `*sql.DB`.

<!--
### db.Database.Open() *error*

Requests a connection to the database. Returns *error* if something goes wrong.
-->

### db.Database.Close() *error*

Closes the connection to the database session. Returns *error* if something goes
wrong.

### db.Database.Collection(name string) *(db.Collection, error)*

Returns a `db.Collection` and an `error`. Collections are sets of rows or
documents, so this value could be either a MongoDB collection or a
MySQL/PostgreSQL/SQLite table. `error` would be not `nil` if the table does not
exists.

### db.Database.ExistentCollection(name string) *(db.Collection)*

Tries to return a `db.Collection` that must exist, panics if such collection
does not exists.

### db.Database.Collections() *[]string*

Returns the names of all collections in the current database.

### db.Database.Use(name string) *error*

Changes the source database during connection. Returns *error* if the operation
fails.

### db.Database.Drop() *error*

Deletes the entire database and all its collections. Returns *error* if it
fails.

### db.Database.Name() *string*

Returns the active database name.
