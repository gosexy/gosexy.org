# db.Result

A `db.Result` provides methods for accessing results of a `gosexy/db` query.

`db.Result` methods are capable of copying a result into a map or a struct
pointer.

```go
// Result methods.
type Result interface {
  /*
    Fetches all the results of the query into the given
    pointer.

    Accepts a pointer to slice of maps or structs.
  */
  All(interface{}) error

  /*
    Fetches the first result of the query into the given
    pointer and discards the rest.

    Accepts a pointer to map or struct.
  */
  One(interface{}) error

  /*
    Fetches the next result of the query into the given
    pointer. Returns error if there are no more results.

    Warning: If you're only using part of these results
    you must manually Close() the result.

    Accepts a pointer to map or struct.
  */
  Next(interface{}) error

  /*
    Closes the result.
  */
  Close() error
}
```

## Creating a db.Result{} value

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

// The SQL equivalent would be:
//   SELECT *
//     FROM people
//   WHERE last_name = "Smith"
//   LIMIT 10;
results, _ := people.Query(
  db.Cond { "name": "John" },
)

// Iterating over results.
for {
  item := struct{Name string}{}

  err := results.Next(&item)

  if err == nil {
    // If there is no error we can use person.
    fmt.Printf("Name: %s\n", person.Name)
  } else if err == db.ErrNoMoreRows {
    // This error means we have read all rows.
    break
  } else {
    // Another kind of error needs proper management.
    panic(err.Error())
  }
}

// Remember to close the result set.
results.Close()
```

### db.Result.All(interface{}) *error*

Dumps the whole result set into an slice.

Panics if the argument is not a pointer to an slice of maps/structs.

You can only use this function one time per result set.

```go
people, _ := sess.Collection("people")

results, _ := people.Query(
  db.Cond { "name": "John" },
)

items := []db.Item{}

results.All(&items)

for _, item := range items {
  fmt.Printf("Name: %s\n", item["name"])
}
```

### db.Result.One(interface{}) *error*

Copies the first item of the result set into the given argument.

Panics if the argument is not a pointer to map/struct.

You can only use this function one time per result set.

```go
people, _ := sess.Collection("people")

results, _ := people.Query(
  db.Cond { "name": "John" },
)

item := db.Item{}

results.One(&item)

fmt.Printf("Name: %s\n", item["name"])
```

### db.Result.Next(interface{}) *error*

Copies the next item of the result set into the given argument.

Panics if the argument is not a pointer to map/struct.

Returns error when there are no more rows for reading.

Use db.Result.Close() after reading the result set.

```go
people, _ := sess.Collection("people")

results, _ := people.Query(
  db.Cond { "name": "John" },
)

for {
  item := db.Item{}

  err := results.Next(&item)

  if err == nil {
    fmt.Printf("Name: %s\n", item["name"])
  } else if err == db.ErrNoMoreRows {
    // No more rows.
    break
  } else {
    panic(err.Error())
  }
}

// Remember to close the result set.
results.Close()
```

### db.Result.Close() *error*

Closes the result set so no more results could be returned.
