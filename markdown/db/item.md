# db.Item

Items are rows or documents, correct nomenclature depends on the database.

For SQL databases they are just ``map[string] interface{}`` with no nested
values, NoSQL databases can have nested values like slices or other maps.

Either way, a `db.Item` can be treated as a `map[string] interface{}`.

```go
type Item map[string]interface{}
```

## Creating a db.Item object

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

Point a variable to a collection using the `db.Database.Collection()` or
`db.Database.ExistentCollection()` methods.

```go
// Collection could not exists, an error would be returned.
people, err := sess.Collection("people")

// Collection must exists, it will panic otherwise.
users := sess.ExistentCollection("users")
```

Finally, use `db.Collection.Find()` or `db.Collection.FindAll()` to fetch one or many items.

```go
// db.Collection.Find(...interface{}) *(db.Item, error)*
john, _ := users.Find(db.Cond{"name": "john"})
if john != nil {
	fmt.Println("John was found.")
}

// db.Collection.FindAll(...interface{}) *([]db.Item, error)*
smiths, _ := users.Find(db.Cond{"last_name": "smith"})

for _, smith := range smiths {
	fmt.Printf("Hi, %s %s.\n", smith["name"], smith["last_name"])
}
```

## Tips and tricks

Castings and conversions could be tricky with `interface{}`s, these packages
may be useful.

* [menteslibres.net/gosexy/dig][1] For quick access to nested values.
* [menteslibres.net/gosexy/to][2] For adventurous value conversions.

[1]: http://menteslibres.net/gosexy/dig
[2]: http://menteslibres.net/gosexy/to
