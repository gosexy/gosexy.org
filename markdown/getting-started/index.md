# Get started

An example on how [Go][1] can help us deliver better code.

## On database/sql drivers

This is one of the [goals](http://golang.org/src/pkg/database/sql/doc.txt) of
the `database/sql` package:

> Provide a generic database API for a variety of SQL or SQL-like
> databases.  There currently exist Go libraries for SQLite, MySQL,
> and Postgres, but all with a very different feel, and often
> a non-Go-like feel.

Except that:

* Every driver implements different syntax for connection strings.
* Even when using an abstraction like `database/sql`, the query syntax still
depends on the database it was designed for.
* What about NoSQL? Not all databases speak SQL.

I ran into this problem early when learning [Go][1], so I started to code and
the result was `gosexy/db`. The `gosexy/db` package uses some great [Go][1]
features like custom type definitions and provides a way to execute the most
common operations that you can do with a database: *create*, *read*, *update*
and *delete* ([CRUD][2]).

This snippet uses `gosexy/db` to query a SQL database:

```go
/*
  The SQL equivalent would be:

  SELECT *
    FROM people
  WHERE name = 'John' AND last_name = 'Doe' AND (age = 15 OR age = 20);

  The MongoDB equivalent would be:

  db.people.find({name: "John", "last_name": "Doe", $or: [
    { "age": 15 },
    { "age": 20 }
  ]});

*/

// And this is how you could do it with gosexy/db:

people.Find(
  db.Cond {
    "name": "John",
    "last_name": "Doe",
  },
  db.Or {
    db.Cond { "age": 15 },
    db.Cond { "age": 20 },
  },
)
```

If you think the above idea can help you writing a great project, please
continue to the [gosexy/db](/gosexy/db) docs.

Hope you liked this little introduction to [gosexy.org][3].

[1]: http://golang.org
[2]: http://en.wikipedia.org/wiki/Create,_read,_update_and_delete
[3]: http://gosexy.org
