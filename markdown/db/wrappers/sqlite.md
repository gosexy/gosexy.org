# SQLite3 wrapper

This driver is a wrapper of [sqlite3](https://github.com/mattn/go-sqlite3), a SQLite3 driver
by [Yasuhiro Matsumoto](http://mattn.kaoriya.net/).

In order to work with ``gosexy/db`` the original driver had to be
[forked][1] as the changes made to it are incompatible with some of [sqlite3][1]'s own features.

## Driver requeriments

The sqlite3 driver uses cgo, and it requires ``pkg-config`` and the sqlite3 header files in order to be installed.

If you're using ``brew`` and OSX, you can install them like this

```sh
% brew install pkg-config
% brew install sqlite3
```

On ArchLinux you could use

```sh
% sudo pacman -S pkg-config
% sudo pacman -S sqlite3
```

And on Debian based distros

```sh
% sudo aptitude install pkg-config
% sudo aptitude install libsqlite3-dev
```

## Installing the wrapper

```sh
% go get github.com/gosexy/db/sqlite
```

## Usage

```go
import (
  "github.com/gosexy/db"
  "github.com/gosexy/db/sqlite"
)
```

## Connecting to a SQLite3 database

```go
sess := sqlite.Session(db.DataSource{Database: "/path/to/sqlite3.db"})

err := sess.Open()

if err == nil {
  defer sess.Close()
}
```

## Making queries to the database

Check the [gosexy/db](/db) documentation to know how to make queries to the database.

[1]: https://github.com/xiam/gosqlite3
