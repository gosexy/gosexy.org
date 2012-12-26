# db.Item

Items are rows or documents, correct denomination depends on the database.
For SQL database they are just ``map[string] interface{}`` with no nested values, while in a NoSQL database
values can have nested values like lists or other maps.

Either way, a ``db.Item`` can be treated as a ``map[string] interface{}``. Castings and
conversions could be tricky with `interfaces{}`, that's why this data type has a few methods that may help
with common conversions.

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

Point a variable to a collection using the `db.Database.Collection()` or `db.Database.ExistentCollection()` methods.

```go
// Collection could not exists, an error would be returned.
people, err := sess.Collection("people")

// Collection must exists, it will panic otherwise.
users := sess.ExistentCollection("users")
```

Finally, use `db.Collection.Find()` or `db.Collection.FindAll()` to fetch one or many items.

```go
// db.Collection.Find(...interface{}) *db.Item*
john := users.Find(db.Cond{"name": "john"})
if john != nil {
	fmt.Println("John was found.")
}

// db.Collection.FindAll(...interface{}) *[]db.Item*
smiths := users.Find(db.Cond{"last_name": "smith"})
for _, smith := range smiths {
	fmt.Printf("Hi, %s %s.\n", smith.GetString("name"), smith.GetString("last_name"))
}
```

## Methods

### db.Item.GetString(key string) *string*

Returns the string value of the element with the specified key.

### db.Item.GetDate(key string) *time.Time*

Returns the time value of the element with the specified key. May not recognize all time and date formats yet.

### db.Item.GetDuration(key string) *time.Duration*

Returns the duration value of the element with the specified key.

### db.Item.GetMap(key string) *sugar.Map*

Returns the map value of the element with the specified key.

### db.Item.GetList(key string) *sugar.List*

Returns the sugar.List value of the element with the specified key.

### db.Item.GetInt(key string) *int64*

Returns the integer value of the element with the specified key

### db.Item.GetFloat(key string) *float64*

Returns the float value of the element with the specified key

### db.Item.GetBool(key string) *bool*

Returns the boolean value of the element with the specified key
