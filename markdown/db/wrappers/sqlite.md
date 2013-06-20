# SQLite3 wrapper

This package is a wrapper of [sqlite3](https://github.com/mattn/go-sqlite3), a
SQLite3 driver by [Yasuhiro Matsumoto](http://mattn.kaoriya.net/).

In order to work with `gosexy/db` the original driver had to be
[forked][1], the changes we made to it were incompatible with some of
[sqlite3][1]'s own features.

## Installation

### Driver pre-requisites

The sqlite3 driver uses cgo, it requires `pkg-config` and the sqlite3 header
files in order to be installed.

```sh
# OSX
% brew install pkg-config
% brew install sqlite3

# ArchLinux
% sudo pacman -S pkg-config
% sudo pacman -S sqlite3

# SQLite3
% sudo aptitude install pkg-config
% sudo aptitude install libsqlite3-dev
```

### Getting the wrapper

```sh
go get menteslibres.net/gosexy/db/sqlite
```

## Usage

Import the `gosexy/db` and `gosexy/db/sqlite` packages.

```go
import (
  "menteslibres.net/gosexy/db"
	# Note that we are importing to the blank identifier.
  _ "menteslibres.net/gosexy/db/sqlite"
)
```

### Connecting to a SQLite3 database

```go
sess, err := db.Open("sqlite", db.DataSource{Database: "/path/to/sqlite3.db", ...})

if err != nil {
	panic(err)
}

defer sess.Close()
```

### Querying the database

Check out the [gosexy/db documentation](/gosexy/db) for documentation in how to query
a collection.

[1]: https://github.com/xiam/gosqlite3
