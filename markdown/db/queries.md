# Querying the database

Queries are operations on [collections](/db/collection), the ``github.com/gosexy/db`` implements
many special datatypes that can be used to improve code expressiveness and query the database in a
way that is exclusive to the Go language.

Most of these custom types are only useful when passed to a ``db.Collection`` object.

## db.Cond

```go
type Cond map[string]interface{}
```

Represents conditions and operators in an expression.

```go
db.Cond { "age": 18 } // Means the condition is to have the "age" field equal to 18.

db.Cond { "age $lt": 18 } // $lt is a MongoDB operator, if you're using MongoDB, means that you want the "age" field to be lower than 18.

db.Cond { "age >=": 18 } // >= is a SQL operator, if you're using SQL, means that you want the "age" field to be mayor or equal to 18.
```

Operators are specified with an space after the field name, so, for MongoDB you can use ``"age $lt"`` or ``"age $gt"`` whereas in SQL you would use
``"age >="`` or ``"age <="`` as key names.

You can use ``db.Cond`` with ``db.Collection.Find()``, ``db.Collection.FindAll()``, ``db.Collection.Count()``, ``db.Collection.Remove()`` and
``db.Collection.Update()``.

## db.And

```go
type And []interface{}
```

Relates ``db.Cond``, ``db.And`` and ``db.Or`` types.

For example, if you want to relate two conditions under an AND operation:

```go
db.And (
  db.Cond { "name": "Peter" },
  db.Cond { "last_name": "Parker "},
)
```

You can use ``db.And`` with ``db.Collection.Find()``, ``db.Collection.FindAll()``, ``db.Collection.Count()``, ``db.Collection.Remove()`` and
``db.Collection.Update()``.

## db.Or

```go
type And []interface{}
```

Relates ``db.Cond``, ``db.And`` and ``db.Or`` types.

For example, if you want to relate two conditions under an OR operation:

```go
db.Or (
  db.Cond { "name": "Peter" },
  db.Cond { "last_name": "Parker "},
)
```

You can use ``db.Or`` with ``db.Collection.Find()``, ``db.Collection.FindAll()``, ``db.Collection.Count()``, ``db.Collection.Remove()`` and
``db.Collection.Update()``.

## db.Sort

```go
type Sort map[string]interface{}
```

Determines the order in which items in ``db.Collection.Find()`` or ``db.Collection.FindAll()`` statements will be returned.

```go
db.Sort { "age": -1 } // If using MongoDB means: sort by age in descending order.

db.Sort { "age": "ASC" } // If using SQL means: sort by age in ascending order.
```

You can use ``db.Sort`` with ``db.Collection.Find()`` and ``db.Collection.FindAll()``.

## db.Modify

```go
type Modify map[string]interface{}
```

Determines how the matched item or items are going to change in an update statement.

```go
db.Modify {
  "$inc": {
    "counter": 1
  }
}
```

You can use ``db.Modify`` with ``db.Collection.Update()`` (at this time only available for the [mongo](/db/drivers/mongo) driver).

## db.On

```go
type On []interface{}
```

Specifies relations with external collections, the specific relation with the parent expression can be determined with
the name of field on the external collection plus the name of the referred parent column between brackets.

```go
db.On {
  db.Collection("external"),
  Cond { "external_key": "{parent_value}" },  Relation exists where the "external_key" field is equal to the parent's "parent_value".
}
```

You can use ``db.On`` with ``db.Collection.Find()``, ``db.Collection.FindAll()`` and ``db.Collection.Count()``.

# db.Relate

```go
type Relate map[string]On
```

Specifies a one-to-one relation in ``db.Collection.Find()`` and ``db.Collection.FindAll()`` statements. It consists of a name and a ``db.On`` expression.

You can use the same expressions you would use in a normal ``db.Collection.Find()`` and ``db.Collection.FindAll()`` expressions besides a ``db.Collection``,
you can also use other nested ``db.Collection.Relate`` and ``db.Collection.RelateAll`` expressions. If no ``db.Collection`` is given, the one with the
relation name will be used.

```go
db.Relate {
  "father": On {
    db.Collection("people"),
    db.Cond { "gender": "man" },
    db.Cond { "id": "{parent_id}" },
  }
}
```

You can use ``db.Relate`` with ``db.Collection.Find()``, ``db.Collection.FindAll()`` and ``db.Collection.Count()``.

## db.RelateAll

```go
type RelateAll map[string]On
```

Specifies a one-to-many relation in ``db.Collection.Find()`` and ``db.Collection.FindAll()`` expressions. It consists of a name and a ``db.On`` expression.

You can use the same expressions you would use in a normal ``db.Collection.Find()`` and ``db.Collection.FindAll()`` expressions besides a ``db.Collection``,
you can also use other nested ``db.Collection.Relate`` and ``db.Collection.RelateAll`` expressions. If no ``db.Collection`` is given, the one with the
relation name will be used.

```go
db.RelateAll {
  "children": On {
    db.Collection("people"),
    db.Cond { "age $lt": 12 },
    db.Cond { "parent_id": "{_id}" },
  }
}
```

You can use ``db.RelateAll`` with ``db.Collection.Find()``, ``db.Collection.FindAll()`` and ``db.Collection.Count()``.

## db.Limit

```go
type Limit uint
```

Sets the limit of results to be returned in ``db.Collection.Find()`` and ``db.Collection.FindAll()`` statements.

```go
db.Limit(5)

```

## db.Offset

```go
type Offset uint
```

Sets how many results will be skipped before returning the queried datased in ``db.Collection.Find()`` and ``db.Collection.FindAll()`` statements.

```go
db.Offset(15)
```

## db.Set

```go
type Set map[string]interface{}
```

Determines new values for the fields on the matched item or items in update statements.

```go
db.Set {
  "name": "New Name"
}
```

You can use ``db.Set`` with ``db.Collection.Update()``.

## db.Upsert

```go
type Upsert map[string]interface{}
```

Determines new values for the fields on the matched item or items in ``db.Collection.Update()`` and ``db.Collection.UpdateAll()`` expressions.

If no item is found, a new one is created.

```go
db.Upsert {
  "name": "New Name"
}
```

You can use ``db.Upsert`` with ``db.Collection.Update()`` (at this time only available for the [mongo](/db/drivers/mongo) driver).

## db.Fields

```go
type Fields []string
```

Specifies the names of fields to be returned in a find statement.

You can use ``db.Fields`` with ``db.Collection.Find()`` and ``db.Collection.FindAll()``.
