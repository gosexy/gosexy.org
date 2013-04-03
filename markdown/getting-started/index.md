# A few case examples

Some examples of few things that could get some benefit from Go devs
experimenting with the language syntax.

## JSON and maps

A simple case many of us ran into while learning [Go][1].

As you know, the `encoding/json` package is used to transform JSON objects into
[Go][1] maps or structs and vice versa.

Take a look at this example:

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

It's kind of simple really, note the `map[string] interface{}` declaration
that precedes every block of key-values, that's how we define and initialize
an map with string keys and any type of value, and it's long, we could use a
type like `type Map map[string] interface{}` to write just `Map` instead of
`map[string] interface{}`, that way the code would get reduced without losing
expresiveness.

```go
package main

import (
  "encoding/json"
  "fmt"
)

type Map map[string] interface{}

func main() {

  s, _ := json.Marshal(
    Map {
      "Hello": "World",
      "NestedValues": Map {
        "Integers": []int{ 1, 2, 3 },
        "Boolean": true,
      },
    },
  )

  fmt.Printf("%v\n", string(s))
}
```

That's how we convert from Go maps into a JSON encoded string. Now let's try
the other way around, creating a Go map starting with a JSON encoded string. We
could use the `Map` shortcut above. What if we wanted to use the
`NestedValues.Integers[1]` value? since we wrote the original struct we know
it must be an `int` of value `2` but, how to get to that nested value in Go?

This is how we can decode a JSON string into a Map to access a property value:

```go
package main

import (
  "encoding/json"
  "fmt"
)

type Map map[string] interface{}

func main() {

  buf := []byte(`{"Hello":"World","NestedValues":{"Boolean":true,"Integers":[1,2,3]}}`)

  dst := Map{}

  json.Unmarshal(buf, &dst)

  fmt.Printf("NestedValues.Integers[1] = %d\n", dst["NestedValues"].(map[string]interface{})["Integers"].([]interface{})[1].(float64))

  // We want an int, JSON says it's a float64.
  // NestedValues.Integers[1] = %!d(float64=2)
}
```

Since we defined the map values to be of any type (`interface{}`) we'll have to
do some type assertions in order to actually use the values, that's why we
append things like `.(map[string]interface{})` to `dst["NestedValues"]`.

That's a very precise way of accessing a map value, maybe too precise, and it
also requires the JSON to be always in the same format. Suppose that instead of
starting from a constant JSON string we pulled it from a web service, what if
the JSON changes? the hard type assertions may cause the program to panic and
die.

Let's take a closer look:

```go
dst["NestedValues"].(map[string]interface{})["Integers"].([]interface{})[1].(float64)
```

One of the downsides of being too specific here is that the resulting code is
prone to human errors.

Besides, remember we wanted an `int` but the JSON unmarshaler says that's a
`float64`, a cast is still missing and our code gets a little longer:

```go
int(dst["NestedValues"].(map[string]interface{})["Integers"].([]interface{})[1].(float64))
```

As you could see, dealing with and guessing JSON datatypes is not precisely
the most fun and healthy thing to do.

Services that output JSON can change anytime, we can't control them and we can't rely on
these values being always the same type.

I have to work with JSON services that may change suddenly over time and I don't
want to be too specific on nested values nor I want to write `struct{}`s for
every piece of data, it would take a lot of human time that we could spend in
other tasks.

To avoid being so verbose without losing expresiveness, you could use a package
like `gosexy/dig`:

```
go get -u menteslibres.net/gosexy/dig
```

This package is an on-going experiment that allows you to get map values (any
map type) in a simpler way.

An example:

```go
package main

import (
  "encoding/json"
  "menteslibres.net/gosexy/dig"
  "fmt"
)

type Map map[string] interface{}

func main() {

  buf := []byte(`{"Hello":"World","NestedValues":{"Boolean":true,"Integers":[1,2,3]}}`)

  dst := Map{}

  json.Unmarshal(buf, &dst)

  fmt.Printf("NestedValues.Integers[1] = %d\n", dig.Int64(&dst, "NestedValues", "Integers", 1))

  // 2
}
```

I love Go's precision but I think I could be a little lazy when dealing with
data interchange formats, such as JSON, YAML and so.

# On database/sql drivers

This is one of the [goals](http://golang.org/src/pkg/database/sql/doc.txt) of
the `database/sql` package:

> Provide a generic database API for a variety of SQL or SQL-like
> databases.  There currently exist Go libraries for SQLite, MySQL,
> and Postgres, but all with a very different feel, and often
> a non-Go-like feel.

Except that, in my own experience:

* Every driver implements different syntax for connection strings.
* Even when using an abstraction like `database/sql`, the query syntax still
depends on the database it was designed for.
* What about NoSQL? Not all databases speak SQL.

I ran into this problem early when learning [Go][1], so I started to code and
the result was `gosexy/db`. The `gosexy/db` package uses some great [Go][1]
features like custom type definitions and provides a way to execute the most
common operations that you can do with a database: *create*, *read*, *update*
and *delete* ([CRUD][2]).

I won't worry you with the details, I'll just present you a code example of a
query that uses `gosexy/db` and works the same with MySQL than with MongoDB,
PostgreSQL or SQLite3:

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

// And this is how you do it with gosexy/db:

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
