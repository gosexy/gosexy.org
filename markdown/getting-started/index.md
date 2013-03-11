# A real world example

A simple case many of us ran into while learning [Go][1].

The `encoding/json` package is used to transform JSON objects into [Go][1] maps
or structs and vice versa.

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

It's kind of simple really, the note the `map[string] interface{}` declaration
that precedes every block of key-values, that's how we define and initialize
an standard map. We can use a type like `type Map map[string] interface{}`
to write just `Map` instead of `map[string] interface{}` the code would get
reduced without losing expresiveness.

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

Now, that was easy but now try the other way around, from JSON into Go, using
the `Map` shortcut, let's try to access the `NestedValues.Integers[1]` value,
since we wrote the original struct we know it must be an `int` of value `2`.

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

  // NestedValues.Integers[1] = %!d(float64=2)
}
```

That's a very precise way of accessing a map value, but maybe too precise and
verbose, what if the JSON changes? what will happen with all these
`interface{}`s? will your program panic and die? what have happened if they
were not three levels but seven?

Now looks closely:

```go
dst["NestedValues"].(map[string]interface{})["Integers"].([]interface{})[1].(float64)
```

One of the downsides of being too specific with a simple thing like a nested
JSON value is that the resulting code is too long and prone to human errors.

Besides, remember we wanted an `int` but the JSON unmarshaler says that's a
`float64`, so a cast is still missing:

```go
int(dst["NestedValues"].(map[string]interface{})["Integers"].([]interface{})[1].(float64))
```

As you could see, dealing with and guessing JSON datatypes is just not
precisely the most fun and healthy thing to do.

I have to work with JSON services that may change suddenly over time and I don't
want to be too specific on nested values nor I want to write `struct{}`s for
every piece of data, it would take a lot of human time that we could spend in
other tasks.

To avoid being so verbose without losing expresiveness, you could use a package
like `gosexy/dig`:

```
go get -u github.com/gosexy/dig
```

An example:

```go
package main

import (
  "encoding/json"
  "github.com/gosexy/dig"
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

It's not that I don't like Go's precision but I think I could be a little
lazy when dealing with data interchange formats, such as JSON.

## Another issue: database/sql drivers

This is one of the [goals](http://golang.org/src/pkg/database/sql/doc.txt) of
the `database/sql` package:

> Provide a generic database API for a variety of SQL or SQL-like
> databases.  There currently exist Go libraries for SQLite, MySQL,
> and Postgres, but all with a very different feel, and often
> a non-Go-like feel.

Except that, in my own experience:

* Every driver implements different syntax for connection strings. I need to
check the manual everytime.
* What about NoSQL? Not all databases speak SQL.
* Even when using an abstraction like `database/sql`, the query syntax still
depends on the database it was designed for.

I ran into this problem early when learning [Go][1], so I started to code and
the result was `gosexy/db`. The `gosexy/db` package uses some great [Go][1]
features like custom type definitions and provides a way to execute the most
common operations that you can do with a database: *create*, *read*, *update*
and *delete* ([CRUD][2]).

I won't worry you with the details but here's a code example that works
the same  with MySQL than with MongoDB, PostgreSQL or SQLite3:

```go
/*
  The SQL equivalent would be:
  SELECT *
    FROM people
  WHERE name = 'John' AND last_name = 'Doe' AND (age = 15 OR age = 20);
*/
people.Find(
  db.Cond { "name": "John" },
  db.Cond { "last_name": "Doe" },
  db.Or {
    db.Cond { "age": 15 },
    db.Cond { "age": 20 },
  },
)
```

But that was just a tiny bit of `gosexy/db`, if you think the above idea can
help you writing a wonderful project continue to the [gosexy/db docs](/db).

Hope you liked this little introduction to [gosexy.org][3].

[1]: http://golang.org
[2]: http://en.wikipedia.org/wiki/Create,_read,_update_and_delete
[3]: http://gosexy.org
