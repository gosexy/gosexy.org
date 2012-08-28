# PostgreSQL wrapper

This package is a wrapper of [pq](https://github.com/bmizerany/pq), a PostgreSQL driver
by [Blake Mizerany](http://blakemizerany.com).

In order to work with ``gosexy/db`` the original driver had to be
[forked][1] as the changes made to it are incompatible with some of [pq][1]'s
own features.

## Installing the wrapper

    % go get github.com/xiam/gosexy/db/postgresql

## Usage

    import (
      "github.com/xiam/gosexy/db"
      "github.com/xiam/gosexy/db/postgresql"
    )

## Connecting to a PostgreSQL database

    sess := postgresql.Session(db.DataSource{Host: "127.0.0.1"})

    err := sess.Open()

    if err == nil {
      defer sess.Close()
    }

## Making queries to the database

Check the [gosexy/db](/db) documentation to know how to make queries to the database.

[1]: https://github.com/xiam/gopostgresql
