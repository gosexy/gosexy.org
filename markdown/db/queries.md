# Querying the database

Queries are operations on [collections](/db/collection), the `github.com/gosexy/db` implements
many special datatypes that can be used to improve code expressiveness and query the database in a
way that feels natural to the Go language.

You can use these special types as arguments on `db.Collection` [methods](/db/collection) like
`db.Collection.Find()` or `db.Collection.FindAll()`.

## Types

### db.Cond

```go
// package db
type Cond map[string]interface{}
```

Represents conditions in an query. Conditions need operators and they may be incompatible between
databases. We recommend using operators depending on the database you're working with.

Operators are specified with an space after the field name, so, for the `mongo` driver you could
use ``"age $lt"`` or ``"age $gt"`` while in SQL you could use ``"age >="`` or ``"age <="`` as key
names.

```go
// Means the condition is that the `age` field must be equal to 18.
db.Cond { "age": 18 }

// `$lt` is an operator exclusive for the MongoDB database, if
// you're using MongoDB means that you want the `age` field to be
// lower than 18.
db.Cond { "age $lt": 18 } // Note the space between name and operator

// `>=` is a SQL operator, if you're using SQL means that you want
// the `age` field to be greater than or equal to 18.
db.Cond { "age >=": 18 } // Note the space between name and operator

// A full example
john := people.Find(
	db.Cond({"name": "john"})
)
```

You can use one or many `db.Cond` as arguments to:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Count()`
* `db.Collection.Remove()`
* `db.Collection.Update()`

### db.And

```go
// package db
type And []interface{}
```

Relates `db.Cond`, `db.Or` and other `db.And` types with a logical conjuction.

```go
// Explicitly relating two `db.Cond` with a conjuction.
peterParkers := people.FindAll(
	db.And (
		db.Cond { "name": "Peter" },
		db.Cond { "last_name": "Parker "},
	),
)
```

Please note that `db.And` is the default relation for multiple `db.Cond` that don't have
an explicit conjuction or disjunction.

```go
// This would be equivalent to the previous example, as
// `db.And` is the default relation.
peterParkers := people.FindAll(
	//db.And (
		db.Cond { "name": "Peter" },
		db.Cond { "last_name": "Parker "},
	//),
)
```

You can use one or many `db.And` as arguments to:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Count()`
* `db.Collection.Remove()`
* `db.Collection.Update()`

### db.Or

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

You can use one or many `db.Or` as arguments to:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Count()`
* `db.Collection.Remove()`
* `db.Collection.Update()`

### db.Fields

```go
// package db
type Fields []string
```

Specifies the names of fields to be returned in `db.Collection.Find()` or `db.Collection.FindAll()` statements.

```go
people.FindAll(
	db.Fields { "name", "last_name" },
	db.Cond { "name": "john" },
)
```

You can use `db.Fields` as argument to:

* `db.Collection.Find()`
* `db.Collection.FindAll()`


### db.Sort

```go
// package db
type Sort map[string]interface{}
```

Determines the order in which items in `db.Collection.Find()` or `db.Collection.FindAll()` statements would be returned.

```go
// If using MongoDB means: sort by age in descending order.
oldest := people.Find(
	db.Sort { "age": -1 },
)

// If using SQL means: sort by age in ascending order.
youngest := people.FindAll(
	db.Sort { "age": "ASC" },
)
```

You can use `db.Sort` as argument to:

* `db.Collection.Find()`
* `db.Collection.FindAll()`

It is illegal to specify more than on `db.Sort` in the same query.

### db.Limit

```go
// package db
type Limit uint
```

Defines the maximum number of results to be returned in `db.Collection.Find()` and `db.Collection.FindAll()` statements.

```go
people.FindAll(
	db.Limit(5),
)
```

You can use `db.Limit` as argument to:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Count()`

### db.Offset

```go
// package db
type Offset uint
```

Defines how many results will be skipped before returning the queried dataset in `db.Collection.Find()` and
`db.Collection.FindAll()` statements.

```go
db.Offset(15)
```

You can use `db.Offset` as argument to:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Count()`

### db.Set

```go
// package db
type Set map[string]interface{}
```

Determines new values for the fields on the matched item or items in update statements.

```go
people.Update(
	db.Set {
		"name": "New name",
	},
	db.Cond { "name": "Old name" },
)
```

You can use `db.Set` with `db.Collection.Update()`.


### db.Relate

```go
// package db
type Relate map[string] On
```

Specifies a one-to-one relation in `db.Collection.Find()` and `db.Collection.FindAll()` statements.
It consists of a name and a `db.On` expression.

You could use the same expressions you would use in a normal `db.Collection.Find()` and `db.Collection.FindAll()`
expressions, besides a `db.Collection`. You could also use other nested `db.Collection.Relate` and `db.Collection.RelateAll`
expressions. If no `db.Collection` is given, the relation name will be tried.

```go
childrenAndFather := people.FindAll(
	db.Relate {
		"father": db.On {
			db.ExistentCollection("people"),
			db.Cond { "gender": "man" },
			db.Cond { "id": "{parent_id}" },
		}
	}
)
```

You can use `db.Relate` as argument to:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Count()`

### db.RelateAll

```go
// package db
type RelateAll map[string]On
```

Like `db.Relate` but specifies a *one-to-many* relation in `db.Collection.Find()` and `db.Collection.FindAll()` expressions
instead of a *one-to-one*.

```go
people.FindAll(
	db.RelateAll {
		"children": On {
			db.Collection("people"),
			db.Cond { "age $lt": 12 },
			db.Cond { "parent_id": "{_id}" },
		},
	},
)
```

You can use `db.RelateAll` as argument to:

* `db.Collection.Find()`
* `db.Collection.FindAll()`
* `db.Collection.Count()`

### db.On

```go
// package db
type On []interface{}
```

Specifies relations with external collections, the specific relation with the parent expression can be determined with
the name of field on the external collection plus the name of the referred parent column between brackets.

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

You can use `db.On` only as value for `db.Relate` and `db.RelateAll` keys.

### db.Upsert

```go
// package db
type Upsert map[string]interface{}
```

Like `db.Set` but if no document is found a new one would be appended.

```go
people.Update(
	db.Upsert {
		"name": "New name",
	},
	db.Cond { "name": "Old name" },
)
```

You can use `db.Upsert` with `db.Collection.Update()`.

At this time only available for the [mongo](/db/drivers/mongo) driver.

### db.Modify

```go
// package db
type Modify map[string]interface{}
```

Determines how the matched item or items are going to change in an update statement.

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

You can use `db.Modify` as argument to:

* `db.Collection.Update()`

At this time it is only available for the [mongo](/db/drivers/mongo) driver.
