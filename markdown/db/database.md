# gosexy/db: db.Database

The `db.Database` type defines methods for common tasks on databases such as
changing database, using another database or getting a table/collection.

```go
type Database interface {
  /*
    Returns an interface{} to the underlying driver
    the wrapper uses.
  */
  Driver() interface{}

  /*
    Closes the currently active connection to the
    database, if any.
  */
  Close() error

  /*
    Returns a db.Collection struct by name. Returns an
    error if the collection does not exists.
  */
  Collection(tableName string) (Collection, error)

  /*
    Returns a db.Collection struct, panics if the
    collection does not exists.
  */
  ExistentCollection(tableName string) Collection
  /*
    Returns the names of all the collections within the
    active database.
  */
  Collections() []string

  /*
    Changes the active database.
  */
  Use(databaseName string) error

  /*
    Starts a transaction block.
  */
  Begin() error

  /*
    Ends a transaction block.
  */
  End() error

  /*
    Drops the active database.
  */
  Drop() error

  /*
    Sets the connection data.
  */
  Setup(db.DataSource) error

  /*
    Returns the name of the active database.
  */
  Name() string
}
```

## Examples

### Connecting to a database

Use `db.Open` to connect to a database and retrieve a `db.Database` session.

```go
// Database settings
settings := db.DataSource{
  Host:     "localhost",
  Database: "test",
  User:     "myuser",
  Password: "mypass",
}

// func db.Open(driverName string, settings db.DataSource)
// --> (db.Database, error).
sess, err := db.Open("postgresql", settings)

if err != nil {
  panic(err)
}

// func db.Database.Close()
// --> (error)
defer sess.Close()
```

### Listing tables/collections

Iterating over all tables/collections on a database:

```go
// func db.Database.Collections()
// --> []string{}
collections := sess.Collection()
for _, name := range collections {
  fmt.Printf("Table name: %s\n", name)
}
```

### Getting specific tables/collections

Refering to an existing table

```go
// func db.Database.ExistentCollection(name string)
// --> db.Database.Collection
col := sess.ExistentCollection("users")
col.Append(item)
```

### Database name

Getting the name of the current database

```go
// func db.Database.Name()
// --> string
dbname := sess.Name()
```

### Changing database

Connecting to another db with the same credentials.

```go
// func db.Database.Use(dbName string)
// --> error
err := sess.Use("games")
```

### Transactions

Delimiting a transaction block

```go
col := sess.ExistentCollection("users")

// func db.Database.Begin()
// --> error
sess.Begin()
col.Append(item1)
col.Append(item2)
col.Append(item3)
// func db.Database.End()
// --> error
sess.End()
```

## Reference

### Methods

#### db.Database.Driver() *interface{}*

Returns the current wrapper's underlying driver as an `interface{}`, you can
use it for any special driver-specific request. For example, if you're using the
`github.com/gosexy/db/mongo` wrapper, this method will return a
`*mgo.Session` pointer, as the wrapper uses the [mgo](http://labix.org/v2/mgo)
driver.

#### db.Database.Close() *error*

Closes the connection to the database session.

#### db.Database.Collection(name string) *(db.Collection, error)*

Collections are sets of rows or documents, so this value could be either a
MongoDB collection or a MySQL/PostgreSQL/SQLite table. Returned `error` is not
`nil` if the table does not exists.

#### db.Database.ExistentCollection(name string) *(db.Collection)*

Tries to return a `db.Collection` that must exist, panics if such collection
does not exists.

#### db.Database.Collections() *[]string*

Returns the names of all collections in the current database.

#### db.Database.Use(name string) *error*

Changes the source database during connection. Returns *error* if the operation
fails.

#### db.Database.Begin() *error*

Precedes the beginning of a transaction.

#### db.Database.End() *error*

Marks the end of the current transaction.

#### db.Database.Drop() *error*

Deletes the entire database and all its collections. Returns *error* if it
fails.

#### db.Database.Name() *string*

Returns the active database name.
