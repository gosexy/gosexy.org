# Get started with a real world example

Try to use the [Go](http://golang.org)'s ``encoding/json`` package to output some JSON to *stdout*.

    package main

    import (
      "encoding/json"
      "fmt"
    )

    func main() {

      s, _ := json.Marshal(
        map[string]interface{} {
          "Hello": "World",
          "NestedValues": map[string]interface{} {
            "Integers": []int{ 1, 2, 3 },
            "Boolean": true,
          },
        },
      )

      fmt.Printf("%v\n", string(s))
    }

Notice the ``map[string] interface{}`` declaration that precedes every block of values, it seems long and unnecessary. You could use an
editor macro to avoid typing it every time, but it would still feel *bulky*.

Using the trivial datatype package of gosexy, ``github.com/gosexy/sugar``, you can shorten the code a bit and make it more expressive and
easier to understand at the same time without reducing clarity.

Try it out. First, get the package.

    % go get github.com/gosexy/sugar

Write the same code, but using ``github.com/gosexy/sugar``.

    package main

    import (
      "github.com/gosexy/sugar"
      "encoding/json"
      "fmt"
    )

    func main() {

      s, _ := json.Marshal(
        sugar.Tuple {
          "Hello": "World",
          "NestedValues": sugar.Tuple {
            "Integers": sugar.List { 1, 2, 3 },
            "Boolean": true,
          },
        },
      )

      fmt.Printf("%v\n", string(s))
    }

In the above code, we replaced every ocurrence of ``map[string]interface{}`` with ``sugar.Tuple`` and ``[]interface{}``
with ``sugar.List``, that is, the trivial *tuple* and trivial *list* types.

This is a simple example of things that work very well with [Go](http://golang.org) but can be made more readable with
a small change.

## Making database/sql sexier

This is one of the [goals](http://golang.org/src/pkg/database/sql/doc.txt) of the ``database/sql`` package:

> Provide a generic database API for a variety of SQL or SQL-like
> databases.  There currently exist Go libraries for SQLite, MySQL,
> and Postgres, but all with a very different feel, and often
> a non-Go-like feel.

But

* Every driver implements different connection strings.
* Not all databases are SQL-capable databases.
* The driver still depends on the database it was designed for.

We ran into this problem and decided to do something about it using some great Go features like custom types. We created
an abstraction that one can use for all the operations more likely to be done with a database: *create*, *read*, *update* and *delete*
([CRUD](http://en.wikipedia.org/wiki/Create,_read,_update_and_delete)).

This is a code example in how to use Go custom types to achieve more clarity:

    // SQL: SELECT * FROM people WHERE name = 'John' AND last_name = 'Doe' AND (age = 15 OR age = 20);

    people.Find(
      db.Cond { "name": "John" },
      db.Cond { "last_name": "Doe" },
      db.Or {
        db.Cond { "age": 15 },
        db.Cond { "age": 20 },
      },
    )

The above code does not depend on the database you are connecting to, in fact if you change the database wrapper eveything would work
the same.

We created a proof of concept on four different databases: MongoDB, MySQL, PostgreSQL and SQLite. Each one of them very different to
the other. And we achieved our objective to a certain extent. The wrappers are not still 100% compatible but that's our final goal.

If you want to know more, please read our documentation on [gosexy/db](/db).
