# gosexy/db: db.Item

Items are *rows* or *documents*, correct nomenclature depends on the database.

A `db.Item` is just an alias for `map[string] interface{}`.

```go
type Item map[string]interface{}
```

## Examples

### Creating a db.Item{} object

Use `db.Open` to create and retrieve a `db.Database` variable `sess`.

```go
// Database settings
settings := db.DataSource{
  Host:     "localhost",
  Database: "test",
  User:     "myuser",
  Password: "mypass",
}

// func db.Open(string, db.DataSource)
// --> (db.Database, error).
sess, err := db.Open("postgresql", settings)

if err != nil {
  panic(err)
}

// func db.Database.Close()
// --> error
defer sess.Close()
```

Then use the `db.Database.Collection()` on `sess` to retrieve a `db.Collection`
pointer.

```go
// If the collection does not exists an error is returned.
people, err := sess.Collection("people")

// Collection must exists, it will panic otherwise.
users := sess.ExistentCollection("users")
```

Finally use `db.Collection.Find()` to get a `db.Item{}` map or
`db.Collection.FindAll()` to get an array of `db.Item{}`s.

```go
// db.Collection.Find(...interface{})
// --> (db.Item, error)
john, _ := users.Find(db.Cond{"name": "john"})
if john != nil {
	fmt.Println("John was found.")
}

// db.Collection.FindAll(...interface{})
// --> ([]db.Item, error)
smiths, _ := users.Find(db.Cond{"last_name": "smith"})

for _, smith := range smiths {
	fmt.Printf("Hi, %s %s.\n", smith["name"], smith["last_name"])
}
```

## Tips and tricks

Castings and conversions with `interface{}` could be very tricky, take a look
at those packages:

* [menteslibres.net/gosexy/dig][1] For quick access to nested values.
* [menteslibres.net/gosexy/to][2] For adventurous value conversions.

[1]: http://menteslibres.net/gosexy/dig
[2]: http://menteslibres.net/gosexy/to
