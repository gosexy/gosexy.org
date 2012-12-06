# db.Collection

Collections are sets of rows or documents, so they could be either MongoDB *collections* or
MySQL/PostgreSQL/SQLite *tables*.

The `db.Collection` methods allow you to *create*, *read*, *update* or *delete* rows on any
``db.Collection`` and you can setup relations between collections.

When you request data from a collection with `db.Collection.Find()` or `db.Collection.FindAll()`, a special object
with structure `db.Item` or `[]db.Item` is returned.

Please read the docs on [db.Item](/db/item), [db.Database](/db/database) and [how to make queries](/db/queries).

```go
type Collection interface {
  Append(...interface{}) ([]db.Id, error)

  Count(...interface{}) (int, error)

  Find(...interface{}) Item
  FindAll(...interface{}) []Item

  Update(...interface{}) error
	Exists() bool

  Remove(...interface{}) error

  Truncate() error
  Name() string
}
```

## db.Collection.Append(...interface{}) *([]db.Id, error)*

Appends one or more items to the collection. Receives one or more `db.Item` objects as arguments.

```go
# The `sess` variable is a db.Database object.
# http://gosexy.org/db/database
people, _ := sess.Collection("people")

# This example inserts two items into the people collection.
ids, err := people.Append(
  db.Item { "name": "Peter" },
  db.Item { "name": "John" },
)
```

This method returns `([]db.Id, error)`. The `[]db.Id` part of the result is a list of the
recently created IDs that correspond to each one of the appended items.

## db.Collection.Count(...interface{}) *(int, error)*

Returns the number of rows matching the provided conditions.

```go
# The `sess` variable is a db.Database object.
# http://gosexy.org/db/database
people, _ := sess.Collection("people")

# Gives the total number of rows in the `people` collection
# that have a column named `name` with value `Peter`.
total, err := people.Count(db.Cond { "name": "Peter" })

if err == nil {
  fmt.Printf("Found %d rows.\n", total)
}
```

## db.Collection.Find(...interface{}) *db.Item*

Return the first `db.Item` of the `db.Collection` that matches all the provided conditions. You can
provide as many conditions as you want, the order of the conditions does not matter but you must
realize that they are evaluated from left to right and from top to bottom.

```go
# The `sess` variable is a db.Database object.
# http://gosexy.org/db/database
people, _ := sess.Collection("people")

# The SQL equivalent would be:
#   SELECT *
#     FROM people
#   WHERE name = "John" AND last_name = "Doe" AND (age = 15 OR age = 20);
person := people.Find(
  db.Cond { "name": "John" },
  db.Cond { "last_name": "Doe" },
  db.Or {
    db.Cond { "age": 15 },
    db.Cond { "age": 20 },
  },
)

if person != nil {
  fmt.Printf("John's middle name is: %s\n", person.GetString("middle_name"))
}
```

### Using relations on Find()

This is a feature that is unique to `Find()` and `FindAll()`, you can define relations
between collections and use them to pull data from many collections at once.

```go
# The `sess` variable is a db.Database object.
# http://gosexy.org/db/database
people, _ := sess.Collection("people")

# Using relations in FindAll() would be the same as using relations
# in Find().
#
# This example uses FindAll().
people.FindAll(
  # `db.Relate` defines one-to-one relations.
  # This is a relation with the table `places`.
  db.Relate{
    # Defining a custom relation with name `lives_in`.
    "lives_in": db.On{
      # Collection must exists.
      sess.ExistentCollection("places"),
      # Here `{place_code_id}` means the `place_code_id` value
      # of the corresponding item of the parent collection.
      #
      # The parent collection here is `people`, so an SQL
      # equivalent would look like:
      # ...WHERE place.code_id = people.place_code_id...
      db.Cond{"code_id": "{place_code_id}"},
    },
  },
  # `db.RelateAll` defines one-to-many relations.
  db.RelateAll{
    # Defining a custom relation with name `has_children`.
    "has_children": db.On{
      # Collection must exists.
      sess.ExistentCollection("children"),
      # Here `{id}` means the `id` value of the corresponding
      # item of the parent collection.
      #
      # The parent collection here is `people`, so an SQL
      # equivalent would look like:
      # ...WHERE children.parent_id = people.id...
      db.Cond{"parent_id": "{id}"},
    },
    # Defining a custom relation with name `has_visited`.
    "has_visited": db.On{
      # Collection must exists.
      sess.ExistentCollection("visits"),
      # Here `{id}` means the `id` value of the corresponding
      # item of the parent collection.
      #
      # The parent collection here is `people`, so an SQL
      # equivalent would look like:
      # ...WHERE visits.person_id = people.id...
      db.Cond{"person_id": "{id}"},
      # A nested one-to-one relation, please realize that relations
      # can be defined only against the immediate parent collection.
      db.Relate{
        # Defining a custom relation with name `place`.
        "place": db.On{
          # Collection must exists.
          sess.ExistentCollection("places"),
          # Here `{place_id}` means the `place_id` value of the
          # corresponding item of the parent collection.
          #
          # The parent collection here is `visits`, so an SQL
          # equivalent would look like:
          # ...WHERE places.id = visits.place_id...
          db.Cond{"id": "{place_id}"},
        },
      },
    },
  },
)
```

## db.Collection.FindAll(...interface{}) *[]db.Item*

Returns all the items (``[]db.Item``) of the collection that match all the provided conditions. See ``db.Collection.Find()``.

Be aware that there are some parameters that you can pass to ``db.Collection.FindAll()`` but not to ``db.Collection.Find()``,
like ``db.Limit(n)``, as ``db.Collection.Find()`` has a fixed ``db.Limit(1)``.

```go
// Give me the the first 10 rows with last_name = "Smith"
people.Find(
  db.Cond { "last_name": "Smith" },
  db.Limit(10),
)
```

## db.Collection.Update(...interface{}) *error*

Updates all the items of the collection that match all the provided conditions.

You can specify the modification type by using ``db.Set``, ``db.Modify`` or ``db.Upsert``. At the time of this writing
``db.Modify`` and ``db.Upsert`` are only available for ``mongo.Session``.

```go
// Example of assigning field values with Set:
people.Update(
  db.Cond { "name": "José" },
  db.Set { "name": "Joseph"},
)

// Example of custom modification with db.Modify (for mongo.Session):
people.Update(
  db.Cond { "times <": "10" },
  db.Modify { "$inc": { "times": 1 } },
)

// Example of inserting if none matches with db.Upsert (for mongo.Session):
people.Update(
  db.Cond { "name": "Roberto" },
  db.Upsert { "name": "Robert"},
)
```

## db.Collection.Remove(...interface{}) *error*

Deletes all the items of the collection that match the provided conditions.

```go
people.Remove(
  db.Cond { "name": "Peter" },
  db.Cond { "last_name": "Parker" },
)
```

## db.Collection.Truncate() *error*

Deletes the whole collection.

```go
people.Truncate()
```
