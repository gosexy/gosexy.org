# gosexy/db

The `gosexy/db` package is a database abstraction and a collection of wrappers
for popular third party SQL and No-SQL database drivers.

The main goal of this project is to provide a common, simplified and consistent
layer for executing generic database tasks such as *deleting*, *updating*,
*removing*, *counting* and *finding* rows without the need of writing repetitive
SQL statements by hand.

## Base installation

Use `go get` to download and install the `gosexy/db` *base* library.

```sh
go get -u menteslibres.net/gosexy/db
```

In order to query a database a *wrapper* is required.

## Available wrappers

See the wrapper's page for installation instructions and usage examples.

* Instructions for [MongoDB](/gosexy/db/wrappers/mongo)
* Instructions for [MySQL](/gosexy/db/wrappers/mysql)
* Instructions for [PostgreSQL](/gosexy/db/wrappers/postgresql)
* Instructions for [SQLite](/gosexy/db/wrappers/sqlite)

## Development

Want to get involved? we're [hacking on github](http://github.com/gosexy/db).

## Got bugs?

Please report bugs and suggestions to our
[issues page](https://github.com/gosexy/db/issues).
