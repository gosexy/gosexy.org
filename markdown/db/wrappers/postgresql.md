# PostgreSQL wrapper

This package is a wrapper of [pq](https://github.com/bmizerany/pq), a PostgreSQL
driver by [Blake Mizerany](http://blakemizerany.com).

In order to work with `gosexy/db` the original driver had to be
[forked][1], the changes we made to it were incompatible with some of
[pq][1]'s own features.

## Downloading and installing

```sh
go get github.com/gosexy/db/postgresql
```

## Usage

Import the `gosexy/db` and `github.com/gosexy/db/postgresql` packages.

```go
import (
  "github.com/gosexy/db"
	# Note that we are importing to the blank namespace.
  _ "github.com/gosexy/db/postgresql"
)
```

### Connecting to a PostgreSQL database

```go
sess, err := db.Open("postgresql", db.DataSource{Host: "127.0.0.1", ...})

if err != nil {
	panic(err)
}

defer sess.Close()
```

### Querying the database

Check out the [gosexy/db documentation](/db) for documentation in how to query
a collection.

[1]: https://github.com/xiam/gopostgresql
