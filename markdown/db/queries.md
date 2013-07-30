# gosexy/db: Querying the database

Queries are operations on [collections](/gosexy/db/collection)

The `gosexy/db` package implements some custom datatypes that can be passed as
arguments on `db.Collection` methods like `db.Collection.Query()`,
`db.Collection.Find()` or `db.Collection.FindAll()` to represent logical
statements such as OR, AND, = or any combination of them, delimiters such as
OFFSET, LIMIT and order comparisons such ad ORDER BY.

## Usage examples

### Simple condition

```go
// SQL: WHERE foo = 'bar'
people.Find(
  db.Cond{
    "foo": "bar",
  }
)
```

### Conjunction


```go
// SQL: WHERE foo = 'bar' AND baz = 1
people.Find(
  db.Cond{
    "foo": "bar",
    "baz": 1,
  }
)

// SQL: WHERE foo = 'bar' AND baz = 1 (another way)
people.Find(
  db.And {
    db.Cond{ "foo": "bar" },
    db.Cond{ "baz": 1 },
  },
)
```

### Disjunction

```go
// SQL: WHERE foo = 'bar' OR foo = 'baz'
people.Find(
  db.Or{
    db.Cond {"foo": "bar"},
    db.Cond {"foo": "baz"},
  }
)
```

### Slightly more complicated example.

```go
// SQL: WHERE name = 'john'
// AND (last_name = 'connor' OR last_name = 'lennon')
people.Find(
  db.And{
    db.Cond{
      "name": "john",
    },
    db.Or{
      db.Cond {"last_name": "connor"},
      db.Cond {"last_name": "lennon"},
    }
  }
)
```

### Numerical comparisons

```go
// SQL: WHERE page_views >= 26
people.Find(
  db.Cond{
    "page_views >=": 26,
  },
)

// SQL: WHERE page_views < 26
people.Find(
  db.Cond{
    "page_views <": 26,
  },
)
```

## Reference

### Argument types

#### db.Cond

```go
// package db
type Cond map[string]interface{}
```

This type was created to represent conditions in a query. Conditions have
operators and these operators may be incompatible between databases. While
there is certain level of compatibility between operators we recommend
using operators depending on the database you're working on.

Operators are specified with a space after the field name, so, for the `mongo`
driver you could use `"age $lt"` (field "age", space, "$lt") or `"age $gt"`
while in SQL you could use `"age >="` or `"age <="`.

```go
// Means the condition is the `age` being equal to 18.
db.Cond { "age": 18 }

// `$lt` is an operator exclusive for the MongoDB database, if
// you're using MongoDB means that you want the `age` field to be
// lower than 18.
db.Cond { "age $lt": 18 } // Note the space between name and operator

// `>=` is a SQL operator, if you're using SQL means that you want
// the `age` field to be greater than or equal to 18.
db.Cond { "age >=": 18 } // Note the space between name and operator

// A full example
john, _ := people.Find(
  db.Cond({"name": "john"}),
  db.Cond({"last_name": "connor"}),
)
```

By default `db.Cond` values are associative.

You can use one or many `db.Cond` values as arguments for:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Count()`
* `db.Collection.Remove()`
* `db.Collection.Update()`
* `db.Collection.Query()`

#### db.And

```go
// package db
type And []interface{}
```

Relates `db.Cond`, `db.Or` and other `db.And` types with a logical conjuction.

```go
// Explicitly relating two `db.Cond` with a conjuction.
peterParkers, _ := people.FindAll(
  db.Cond {"age": 18 },
  db.And (
    db.Cond { "name": "Peter" },
    db.Cond { "last_name": "Parker "},
  ),
)
```

`db.And` is the default relation for multiple `db.Cond` values that don't have
an explicit conjuction or disjunction.

```go
peterParkers, _ := people.FindAll(
  db.Cond {"age": 18 },
  db.Cond { "name": "Peter" },
  db.Cond { "last_name": "Parker "},
)
```

You can use one or many `db.And` values as arguments for:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Count()`
* `db.Collection.Remove()`
* `db.Collection.Update()`
* `db.Collection.Query()`

#### db.Or

```go
// package db
type Or []interface{}
```

Relates `db.Cond`, `db.And` and other `db.Or` types under a logical disjunction.

```go
// Relating two `db.Cond` under OR.
people.Find(
  db.Or (
    db.Cond { "hero_name": "Spiderman" },
    db.Cond { "hero_name": "Superman" },
  )
)
```

You can use one or many `db.Or` as arguments for:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Count()`
* `db.Collection.Remove()`
* `db.Collection.Update()`
* `db.Collection.Query()`

#### db.Fields

```go
// package db
type Fields []string
```

Specifies the names of fields to be returned in `db.Collection.Find()` or
`db.Collection.FindAll()` statements.

```go
people.FindAll(
  db.Fields { "name", "last_name" },
  db.Cond { "name": "john" },
)
```

You can use one `db.Fields` value as argument for:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Query()`

#### db.Sort

```go
// package db
type Sort map[string]interface{}
```

Determines the order in which items in `db.Collection.Query()`,
`db.Collection.Find()` or `db.Collection.FindAll()` statements would be
returned.

```go
// Sort by age in descending order.
olderFirst, _ := people.Find(
  db.Sort { "age": -1 },
)

// Sort by age in ascending order.
youngerFirst, _ := people.FindAll(
  db.Sort { "age": "ASC" },
)
```

You can use one `db.Sort` value as an argument for:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Query()`

#### db.Limit

```go
// package db
type Limit uint
```

Defines the maximum number of results to be returned in `db.Collection.Find()`
and `db.Collection.FindAll()` statements.

```go
people.FindAll(
  db.Limit(5),
)
```

You can use one `db.Limit` as argument for:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Count()`
* `db.Collection.Query()`

#### db.Offset

```go
// package db
type Offset uint
```

Defines how many results will be skipped before returning the queried dataset in
`db.Collection.Query()`, `db.Collection.Find()` and `db.Collection.FindAll()`
statements.

```go
db.Offset(15)
```

You can use one `db.Offset` value as argument for:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Count()`
* `db.Collection.Query()`

#### db.Set

```go
// package db
type Set map[string]interface{}
```

Determines new values for the matched items on update statements.

```go
people.Update(
  db.Set {
    "name": "New name",
  },
  db.Cond { "name": "Old name" },
)
```

You can use `db.Set` with `db.Collection.Update()`.

#### db.Relate

```go
// package db
type Relate map[string] db.On
```

Specifies a named one-to-one relation in `db.Collection.Query()`,
`db.Collection.Find()` and `db.Collection.FindAll()` statements.

You can easily construct a `db.On` value using the same expressions you'd
use in any `db.Collection.Find()` call with an additional value of type
`db.Collection`.

The keys of the map define the name of the relation.

```go
childrenAndFather := people.FindAll(
  db.Relate {
    "father": db.On {
      // The external collection.
      db.ExistentCollection("people"),
      db.Cond { "gender": "man" },
      db.Cond { "id": "{parent_id}" },
    }
  }
)
```

You can use `db.Relate` as argument for:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Count()`
* `db.Collection.Query()`

#### db.RelateAll

```go
// package db
type RelateAll map[string]On
```

Like `db.Relate` but specifies a *one-to-many* relationship.

You can easily construct a `db.On` value using the same expressions you'd
use in any `db.Collection.FindAll()` call with an additional value of type
`db.Collection`.

The keys of the map define the name of the relation.

```go
people.FindAll(
  db.RelateAll {
    "children": db.On {
      db.Collection("people"),
      db.Cond { "age $lt": 12 },
      db.Cond { "parent_id": "{_id}" },
    },
  },
)
```

You can use `db.RelateAll` as argument for:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Count()`
* `db.Collection.Query()`

#### db.On

```go
// package db
type On []interface{}
```

Defines relations with external collections using conditional statements.

```go
people.Find(
  db.Relate {
    "relationName": db.On {
      // Collection must exists.
      db.ExistentCollection("externalCollection"),
      // Relation exists where the "external_column" field is equal to
      // the parent's "parent_value".
      Cond { "external_column": "{parent_column}" },
    },
  },
)
```

You can use `db.On` only as value for `db.Relate` and `db.RelateAll` maps.

#### db.Upsert

```go
// package db
type Upsert map[string]interface{}
```

Like `db.Set` but if no item is found a new one is inserted.

```go
people.Update(
  db.Upsert {
    "name": "New name",
  },
  db.Cond { "name": "Old name" },
)
```

You can use `db.Upsert` with `db.Collection.Update()`.

At this time only available for the [mongo](/gosexy/db/wrappers/mongo) driver.

#### db.Modify

```go
// package db
type Modify map[string]interface{}
```

Determines how the matched items are going to change in an update statement.

```go
coolLanguages.Update(
  // how?
  db.Modify {
    "$inc": {
      "counter": 1,
    },
  },
  // where?
  db.Cond({"name": "golang"}),
)
```

You can use `db.Modify` as argument for:

* `db.Collection.Update()`

At this time it is only available for the [mongo](/gosexy/db/wrappers/mongo) driver.
