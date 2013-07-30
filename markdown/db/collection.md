# gosexy/db: db.Collection

Collections are sets of rows, sets could be either MongoDB *collections*
or MySQL/PostgreSQL/SQLite *tables*.

The `db.Collection` methods allows you to *insert*, *read*, *update* or *delete*
rows on any `db.Collection`.

You can query the database using `db.Collection.Query()` or with
`db.Collection.Find()`/`db.Collection.FindAll()`.

Please read the docs on [db.Item](/gosexy/db/item),
[db.Database](/gosexy/db/database) and [queries](/gosexy/db/queries).

```go
type Collection interface {
  /*
    Inserts an item into the collection. Accepts maps or
    structs only.
  */
  Append(...interface{}) ([]db.Id, error)

  /*
    Returns the number of rows that match the given
    conditions.
  */
  Count(...interface{}) (int, error)

  /*
    Returns a db.Item map of the first item that matches
    the given conditions.
  */
  Find(...interface{}) (db.Item, error)

  /*
    Returns a []db.Item slice of all the items that match
    the given conditions.

    Useful for small datasets.
  */
  FindAll(...interface{}) ([]db.Item, error)

  /*
    Finds a matching row and sets new values for the given
    fields.
  */
  Update(...interface{}) error

  /*
    Returns true if the collection exists.
  */
  Exists() bool

  /*
    Returns a db.Result that can be used for iterating
    over the rows.

    Useful for large datasets.
  */
  Query(...interface{}) (db.Result, error)

  /*
    Deletes all the rows that match the given conditions.
  */
  Remove(...interface{}) error

  /*
    Deletes all the rows in the collection.
  */
  Truncate() error

  /*
    Returns the name of the collection.
  */
  Name() string
}
```

## Examples

### Getting a collection

Use `db.Open` to connect to a database and retrieve a `db.Database` session.

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

Call the `db.Database.Collection()` method on your `db.Database` variable to
get a collection.

```go
// Collection may not exists, an error will be returned
// in that case.
people, err := sess.Collection("people")

// Collection must exists, it will panic otherwise.
users := sess.ExistentCollection("users")
```

### Counting the total number of rows in a collection

Get a `db.Collection` and use the `db.Collection.Count()` method on it.

```go
people := sess.ExistentCollection("people")

total, _ := people.Count()
```

### Count with conditions

Get a `db.Collection` and use the `db.Collection.Count()` method on it.

```go
people := sess.ExistentCollection("people")

total, _ := people.Count(db.Cond{
  "last_name": "Smith",
})
```

### Inserting a new element

Use the `db.Collection.Append()` method and pass a map of column -> values.

```go
people := sess.ExistentCollection("people")
ids, err := people.Append(db.Item{
  "name": "John",
  "last_name": "Connor",
})
```

...You can also add many items at once:

```go
people := sess.ExistentCollection("people")
ids, err := people.Append(db.Item{
  "name": "John",
  "last_name": "Connor",
}, db.Item {
  "name": "John",
  "last_name": "Lennon",
})
```

...And use structs instead of maps too.

```go
person := Person {
  Name: "John",
  LastName: "Connor",
}
people := sess.ExistentCollection("people")
ids, err := people.Append(person)
```

### Getting an specific item from the collection.

Pass a `db.Cond{}`, `db.And{}` or `db.Or{}` to the `db.Collection.Find()` method.

```go
people := sess.ExistentCollection("people")

john, err := people.Find(db.Cond{
  "name": "John",
  "last_name": "Connor",
})
```

### Getting matching items from the collection.

Pass a `db.Cond{}`, `db.And{}` or `db.Or` to `db.Collection.Find()` method,
you'll end up with an array of `db.Item{}` maps.

```go
people := sess.ExistentCollection("people")

connors, err := people.FindAll(db.Cond{
  "last_name": "Connor",
})

for _, connor := range connors {
  fmt.Printf("name: %s\n", connor["name"].(string))
}
```

### Iterating over a set of results.

Use the `db.Collection.Query()` to retrive a result pointer, you can iterate
the result pointer using `db.Result.Next()` until it returns `error`.

```go
type Person struct {
  Name string `field:"name"`,
  LastName string `field:"last_name"`,
}

people := sess.ExistentCollection("people")

res, err := people.Query(db.Cond{
  "last_name": "Connor",
})

for {
  person := Person{}
  err := res.Next(&person)

  if err == nil {
    fmt.Printf("name: %s\n", person.Name)
  } else if err == db.ErrNoMoreRows {
    // Expected out of rows error.
    break
  } else {
    panic("Got unexpected error: %s", err.Error())
  }
}
```

### Deleting matching rows

Use `db.Collection.Remove()` and pass some conditions to it.

```go
people := sess.ExistentCollection("people")
err := people.Remove(db.Cond{
  "name": "John",
  "last_name": "Connor",
})
```

### Updating matching rows

Use `db.Collection.Update()` and pass conditions and the desired operation,
tipically `db.Set{}`.

```go
people := sess.ExistentCollection("people")
err := people.Update(db.And{
  db.Cond{
    "last_name": "Connor",
  },
  db.Cond{
    "last_name": "Lennon",
  },
}, db.Set{
  "name": "Peter",
})
```

### Relations between collections

This is a feature that is unique to `db.Collection.Find()` and
`db.Collection.FindAll()`, you can define relations between collections and use
them to pull data from many collections at once.

```go
// Let `sess` be a db.Database.
people, _ := sess.Collection("people")

// Using relations with FindAll() would be the same as
// using relations with Find().

// This example uses FindAll().
people.FindAll(
  // `db.Relate` defines a one-to-one relation.
  //
  // This is a relation with the table `places`.
  db.Relate{
    // Defining a custom relation named `lives_in`.
    "lives_in": db.On{
      // Collection must exists.
      sess.ExistentCollection("places"),
      // Here `{place_code_id}` means the `place_code_id`
      // value of the corresponding item of the parent
      // collection.
      //
      // The parent collection here is `people`, so a SQL
      // equivalent would look like:
      // ...WHERE place.code_id = people.place_code_id...
      db.Cond{"code_id": "{place_code_id}"},
    },
  },
  // `db.RelateAll` defines a one-to-many relation.
  db.RelateAll{
    // Defining a custom relation named `has_children`.
    "has_children": db.On{
      // Collection must exists.
      sess.ExistentCollection("children"),
      // Here `{id}` means the `id` value of the
      // corresponding item of the parent collection.
      //
      // The parent collection here is `people`, so an SQL
      // equivalent would look like:
      // ...WHERE children.parent_id = people.id...
      db.Cond{"parent_id": "{id}"},
    },
    // Defining a custom relation with name `has_visited`.
    "has_visited": db.On{
      // Collection must exists.
      sess.ExistentCollection("visits"),
      // Here `{id}` means the `id` value of the
      // corresponding item of the parent collection.
      //
      // The parent collection here is `people`, so an SQL
      // equivalent would look like:
      // ...WHERE visits.person_id = people.id...
      db.Cond{"person_id": "{id}"},
      // A nested one-to-one relation, please realize that
      // relations can be defined only against the
      // immediate parent collection.
      db.Relate{
        // Defining a custom relation with name `place`.
        "place": db.On{
          // Collection must exists.
          sess.ExistentCollection("places"),
          // Here `{place_id}` means the `place_id` value
          // of the corresponding item of the parent
          // collection.
          //
          // The parent collection here is `visits`, so a
          // SQL equivalent would look like:
          // ...WHERE places.id = visits.place_id...
          db.Cond{"id": "{place_id}"},
        },
      },
    },
  },
)
```

## Reference

### Methods

#### db.Collection.Query(...interface{}) *(db.Result, error)*

Executes a query and results a `db.Result`, accepts the same parameters as
`db.Collection.FindAll()`.

Please refer to the documentation on [db.Result](/gosexy/db/result) to know how to
iterate over results.

```go
// The `sess` variable is a db.Database object.
// http://gosexy.org/db/database
people, _ := sess.Collection("people")

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
  var item db.Item
  err := results.Next(&item)
  if err != nil {
    // Will result an error when no more rows are left.
    break
  }
  fmt.Printf("Name: %s\n", person["name"])
}
```

Using `db.Collection.Query` is the recommended way for fetching very large
datasets.

#### db.Collection.Append(...interface{}) *([]db.Id, error)*

Appends one or more items to the collection, a valid item could be either a map
or an struct.

Returns a list of IDs, each one of them corresponding to one of the given items.

```go
// The `sess` variable is a db.Database object.
// http://gosexy.org/db/database
people, _ := sess.Collection("people")

// This example inserts two items into the people
// collection.
ids, err := people.Append(
  db.Item { "name": "Peter" },
  db.Item { "name": "John" },
)
```

#### db.Collection.Count(...interface{}) *(int, error)*

Returns the number of rows matching the provided conditions.

```go
// The `sess` variable is a db.Database object.
// http://gosexy.org/db/database
people, _ := sess.Collection("people")

// Returns the total number of rows in the `people`
// collection that have a column named `name` with
// value `Peter`.
total, err := people.Count(db.Cond { "name": "Peter" })

if err == nil {
  fmt.Printf("Found %d rows.\n", total)
}
```

#### db.Collection.Find(...interface{}) *(db.Item, error)*

Return the first item on the `db.Collection` that matches all the provided
conditions. You can provide as many conditions as you want, the order of the
conditions does not matter.

```go
// The `sess` variable is a db.Database object.
// http://gosexy.org/db/database
people, _ := sess.Collection("people")

// The SQL equivalent would be:
//   SELECT *
//     FROM people
//   WHERE name = "John" AND last_name = "Doe"
//      AND (age = 15 OR age = 20);
person, _ := people.Find(
  db.Cond { "name": "John" },
  db.Cond { "last_name": "Doe" },
  db.Or {
    db.Cond { "age": 15 },
    db.Cond { "age": 20 },
  },
)

if person != nil {
  fmt.Printf("John's middle name is: %s\n", person["middle_name"])
}
```

#### db.Collection.FindAll(...interface{}) *([]db.Item, error)*

Returns an slice of all the items on the collection that match the provided
conditions. See `db.Collection.Find()`.

There are some parameters that only make sense for `db.Collection.FindAll()`
but can't be used with `db.Collection.Find()`, like `db.Limit(n)`.

Not recommended for fetching very large datasets.

```go
// The `sess` variable is a db.Database object.
// http://gosexy.org/db/database
people, _ := sess.Collection("people")

// The SQL equivalent would be:
//   SELECT *
//     FROM people
//   WHERE last_name = "Smith"
//   LIMIT 10;
results, _ := people.Find(
  db.Cond { "last_name": "Smith" },
  db.Limit(10),
)

// Looping over `results` (type `[]db.Item`).
for _, person := range results {
  # Each `person` is a `db.Item`
  fmt.Printf("Name: %s\n", person["name"])
}
```

#### db.Collection.Update(...interface{}) *error*

Modifies all the items in the collection that match all the provided
conditions.

You can define the modification type by setting `db.Set`, `db.Modify` or
`db.Upsert`.

At the time of this writing `db.Modify` and `db.Upsert` are only available for
the `mongo` wrapper.

```go
// The `sess` variable is a db.Database object.
// http://gosexy.org/db/database
people, _ := sess.Collection("people")

// The SQL equivalent would be:
//   UPDATE people
//     SET name = 'Joseph'
//   WHERE name = 'José';
people.Update(
  db.Cond { "name": "José" },
  db.Set { "name": "Joseph"},
)

// This is an operation that is currently accepted
// by the `mongo` driver only.
// Modify row according to a formula.
people.Update(
  db.Cond { "times $gt": "10" },
  db.Modify { "$inc": { "times": 1 } },
)

// This is an operation that is currently accepted
// by the `mongo` driver only.
// Insert if no match.
people.Update(
  db.Cond { "name": "Roberto" },
  db.Upsert { "name": "Robert"},
)
```

#### db.Collection.Exists() *bool*

Returns `true` if the collection exists, `false` otherwise.

#### db.Collection.Remove(...interface{}) *error*

Deletes all the items of the collection that match the provided
conditions.

```go
// The `sess` variable is a db.Database object.
// http://gosexy.org/db/database
people, _ := sess.Collection("people")

// The SQL equivalent would be:
//   DELETE FROM people
//   WHERE name = 'Peter' AND last_name = 'Parker';
people.Remove(
  db.Cond { "name": "Peter" },
  db.Cond { "last_name": "Parker" },
)
```

#### db.Collection.Truncate() *error*

Deletes all items of the collection.

```go
# The `sess` variable is a db.Database object.
// http://gosexy.org/db/database
people, _ := sess.Collection("people")

// The SQL equivalent would be:
// TRUNCATE TABLE people;
people.Truncate()
```

#### db.Collection.Name() *string*

Returns the name of the collection.

