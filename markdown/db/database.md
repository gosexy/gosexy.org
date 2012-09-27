# db.Database

The ``db.Database`` type is an interface that has methods for common tasks on databases.

```go
type Database interface {
  Driver() interface{}

  Open() error
  Close() error

  Collection(string) Collection
  Collections() []string

  Use(string) error
  Drop() error
}
```

## db.Database.Driver() *interface{}*

Returns the current wrapper's low-level driver as an ``interface{}``, so for any special query you can still request the driver
to do it. For example, if you're using the ``github.com/gosexy/db/mongo`` wrapper this method will return a
``*mgo.Session`` object, as the wrapper uses [mgo](http://labix.org/mgo) as it's low-level driver.

## db.Database.Open() *error*

Requests a connection to the database. Returns *error* if something goes wrong.

## db.Database.Close() *error*

Disconnects from the database session. Returns *error* if something goes wrong.

## db.Database.Collection(name string) *db.Collection*

Returns a ``db.Collection``, collections are sets of rows or documents, so this could be either a MongoDB collection or a
MySQL/PostgreSQL/SQLite table.

You may want to read [db.Collection](/db/collection) methods to know how to *create*, *read*, *update* or *delete* rows on
any given a collection.

## db.Database.Collections() *[]string*

Returns the names of all the collections in the current database.

## db.Database.Use(name string) *error*

Makes the database session change its database source. Returns *error* if it fails.

## db.Database.Drop() *error*

Erases the entire database and all the collections. Returns *error* if it fails.

