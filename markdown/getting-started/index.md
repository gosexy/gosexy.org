# Get started with a real world example

I want to share a simple case that I run into while learning Go.

Let's try to use the [Go][1]'s ``encoding/json`` package to output some JSON to *stdout*.

```go
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
```

Notice the ``map[string] interface{}`` declaration that precedes every block of value, it looks looong. You could use an
editor macro to avoid typing it every time, but it would still feel *bulky*.

Using the trivial datatype package of gosexy, ``github.com/gosexy/sugar``, you can shorten the code a bit and make it more expressive and
easier to understand at the same time without reducing clarity.

Try it out. First, get the package.

    % go get github.com/gosexy/sugar

Write the same code, but using ``github.com/gosexy/sugar``.

```go
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
```

In the above code, we replaced every ocurrence of ``map[string]interface{}`` with ``sugar.Tuple`` and ``[]interface{}``
with ``sugar.List``, that is, the trivial *tuple* and trivial *list* types contained in ``github.com/gosexy/sugar``.

This is a really simple example of things that already work very well with [Go][1] but can be made more readable with
a small change.

## Making database/sql sexier

This is one of the [goals](http://golang.org/src/pkg/database/sql/doc.txt) of the ``database/sql`` package:

> Provide a generic database API for a variety of SQL or SQL-like
> databases.  There currently exist Go libraries for SQLite, MySQL,
> and Postgres, but all with a very different feel, and often
> a non-Go-like feel.

Except that in our own experience:

* Every driver implements different connection strings.
* Not all databases are SQL-capable databases. What about NoSQL?.
* The query syntax still depends on the database it was designed for.

We ran into this problem and decided to do something about it using some great [Go][1] features like custom types. We created
an abstraction that one can use for all the operations more likely to be done with a database: *create*, *read*, *update* and *delete*
([CRUD](http://en.wikipedia.org/wiki/Create,_read,_update_and_delete)).

This is a code example in how to use [Go][1]'s custom types to achieve more clarity:

```go
// SQL: SELECT * FROM people WHERE name = 'John' AND last_name = 'Doe' AND (age = 15 OR age = 20);

people.Find(
  db.Cond { "name": "John" },
  db.Cond { "last_name": "Doe" },
  db.Or {
    db.Cond { "age": 15 },
    db.Cond { "age": 20 },
  },
)
```

The above code does not depend on the database you are connecting to, in fact if you change the database wrapper eveything would work
the same.

We created wrappers four databases: MongoDB, MySQL, PostgreSQL and SQLite. Each one of them very different to
the other. And we're working on making them better.

If you want to know more, please read our documentation on [gosexy/db](/db).

[1]: http://golang.org
