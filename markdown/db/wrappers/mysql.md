# MySQL wrapper

This driver is a wrapper of [Go-SQL-Driver/MySQL](https://github.com/Go-SQL-Driver/MySQL),
a MySQL driver by [Julien Schmidt](http://www.julienschmidt.com/).

## Installation

### Getting the wrapper

```sh
% go get github.com/gosexy/db/mysql
```

## Usage

Import the `gosexy/db` and `github.com/gosexy/db/mysql` packages.

```go
import (
  "github.com/gosexy/db"
	# Note that we are importing to the blank namespace.
  _ "github.com/gosexy/db/mysql"
)
```

### Connecting to a MySQL database

```go
sess, err := db.Open("mysql", db.DataSource{Host: "127.0.0.1", ...})

if err != nil {
	panic(err)
}

defer sess.Close()
```

### Querying the database

You may check out the [gosexy/db documentation](/db).

