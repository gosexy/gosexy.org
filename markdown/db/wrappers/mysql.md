# MySQL wrapper

This driver is a wrapper of [go-mysql-driver](http://code.google.com/p/go-mysql-driver/), a MySQL
driver by [Julien Schmidt](http://www.julienschmidt.com/).

## Driver requirements

The [mercurial](http://mercurial.selenic.com/) version control system is required to install
``go-mysql-driver``.

If you're using ``brew`` and OSX, you can install it like this

    % brew install hg

On ArchLinux you could use

    % sudo pacman -S mercurial

And on Debian based distros

    % sudo aptitude install mercurial

## Installing the wrapper

    % go get github.com/xiam/gosexy/db/mysql

## Usage

    import (
      "github.com/xiam/gosexy/db"
      "github.com/xiam/gosexy/db/mysql"
    )

## Connecting to a MySQL database

    sess := mysql.Session(db.DataSource{Host: "127.0.0.1"})

    err := sess.Open()

    if err == nil {
      defer sess.Close()
    }

## Making queries to the database

Check the [gosexy/db](/db) documentation to know how to make queries to the database.

