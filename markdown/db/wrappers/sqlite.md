# SQLite3 wrapper

This driver is a wrapper of [sqlite3](https://github.com/mattn/go-sqlite3), a SQLite3 driver
by [Yasuhiro Matsumoto](http://mattn.kaoriya.net/).

In order to work with `gosexy/db` the original driver had to be
[forked][1] as the changes made to it are incompatible with some of [sqlite3][1]'s own features.

## Installation

### Driver pre-requisites

The sqlite3 driver uses cgo, it requires `pkg-config` and the sqlite3 header files in order to be installed.

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
% go get github.com/gosexy/db/sqlite
```

## Usage

Import the `gosexy/db` and `github.com/gosexy/db/sqlite` packages.

```go
import (
  "github.com/gosexy/db"
	# Note that we are importing to the blank namespace.
  _ "github.com/gosexy/db/sqlite"
)
```

### Connecting to a SQLite3 database

```go
sess, err := db.Open("mongo", db.DataSource{Database: "/path/to/sqlite3.db", ...})

if err != nil {
	panic(err)
}

defer sess.Close()
```

### Querying the database

You may check out the [gosexy/db documentation](/db).

[1]: https://github.com/xiam/gosqlite3
