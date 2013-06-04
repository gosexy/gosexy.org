# MySQL wrapper

This package is a wrapper of
[go-sql-driver/mysql](https://github.com/go-sql-driver/mysql),
a MySQL driver by [Julien Schmidt](http://www.julienschmidt.com/).

## Installation

### Downloading and installing

```sh
go get menteslibres.net/gosexy/db/mysql
```

#### Using go1.0.x?

There is an special extra step required to work with Julien's driver and
**go1.0.x**.

If you're using **go1.1** the problem is already fixed.

After you've pulled the package with `go get`, `cd` to the driver's path and
checkout a special revision:

```
cd $GOPATH/src/github.com/go-sql-driver/mysql
git checkout a8a04cc28d45f986dbb9c4c2e76e805bf7b17787
go build && go install
```

Then build `gosexy/db/mysql` again:

```
cd $GOPATH/src/menteslibres.net/gosexy/db/mysql
go build && go install
```

Please see this
[issue](https://github.com/go-sql-driver/mysql/issues/48) to keep updated on
this topic.

## Usage

Import the `gosexy/db` and `gosexy/db/mysql` packages.

```go
import (
  "menteslibres.net/gosexy/db"
	# Note that we are importing to the blank identifier.
  _ "menteslibres.net/gosexy/db/mysql"
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

Check out the [gosexy/db documentation](/gosexy/db) for documentation in how to query
a collection.

