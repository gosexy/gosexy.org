# db.Collection

Collections are sets of rows or documents, so they could be either MongoDB collections or a MySQL/PostgreSQL/SQLite tables.

You can *create*, *read*, *update* or *delete* rows on any ``db.Collection``.

When you request data from a Collection with ``db.Collection.Find()`` or ``db.Collection.FindAll()``, a special object
with structure ``db.Item`` is returned.

Please read the docs on [db.Item](/db/item), [db.Database](/db/database) and [how to make queries](/db/queries) too.

```go
type Collection interface {
  Append(...interface{}) ([]db.Id, error)

  Count(...interface{}) (int, error)

  Find(...interface{}) Item
  FindAll(...interface{}) []Item

  Update(...interface{}) error

  Remove(...interface{}) error

  Truncate() error
}
```

## db.Collection.Append(...interface{}) *([]db.Id, error)*

Appends one or more items to the collection. Receives one or more ``db.Item`` objects as arguments.

```go
people.Append(
  db.Item { "name": "Peter" },
  db.Item { "name": "John" },
)
```

The first returned argument is an array of IDs (`[]db.Id`) corresponding to each one of the inserted items.

## db.Collection.Count(...interface{}) *(int, error)*

Returns the number of total items matching the provided conditions.

```go
total := people.Count(db.Cond { "name": "Peter" })
```

## db.Collection.Find(...interface{}) *db.Item*

Return the first ``db.Item`` of the ``db.Collection`` that matches all the provided conditions. Ordering of the conditions
does not matter, but you must know that they are evaluated from left to right and from top to bottom.

```go
// ...WHERE name = "John" AND last_name = "Doe" AND (age = 15 OR age = 20)
people.Find(
  db.Cond { "name": "John" },
  db.Cond { "last_name": "Doe" },
  db.Or {
    db.Cond { "age": 15 },
    db.Cond { "age": 20 },
  },
)
```

Here's how you could use relations in your definition:

```go
people.FindAll(
  // One-to-one relation with the table "places".
  db.Relate{
    "lives_in": db.On{
      session.Collection("places"),
      // Relates rows of the table "places" where place.code_id = collection.place_code_id.
      db.Cond{"code_id": "{place_code_id}"},
    },
  },
  db.RelateAll{
    // One-to-many relation with the table "children".
    "has_children": db.On{
      session.Collection("children"),
      // Relates rows of the table "children" where children.parent_id = collection.id
      db.Cond{"parent_id": "{id}"},
    },
    // One-to-many relation with the table "visits".
    "has_visited": db.On{
      session.Collection("visits"),
      // Relates rows of the table "visits" where visits.person_id = collection.id
      db.Cond{"person_id": "{id}"},
      // A nested relation
      db.Relate{
        // Relates rows of the table "places" with the "visits" table.
        "place": db.On{
          session.Collection("places"),
          // Cond places.id = visits.place_id
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
