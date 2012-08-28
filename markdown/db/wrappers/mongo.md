# MongoDB wrapper

This package is a wrapper of [mgo](http://labix.org/mgo), a MongoDB driver by [Gustavo Niemeyer](http://labyx.org).

## Driver requirements

The [bazaar](http://bazaar.canonical.com/en/) version control system is required
to install ``mgo``.

If you're using ``brew`` and OSX, you can install it like this:

    % brew install bzr

On ArchLinux you could use

    % sudo pacman -S bzr

And on Debian based distros

    % sudo aptitude install bzr

## Installing the wrapper

    $ go get github.com/xiam/gosexy/db/mongo

## Usage

    import (
      "github.com/gosexy/db"
      "github.com/gosexy/db/mongo"
    )

## Connecting to a MongoDB database

    sess := mongo.Session(db.DataSource{Host: "127.0.0.1"})

    err := sess.Open()

    if err == nil {
      defer sess.Close()
    }

## Making queries to the database

Check the [gosexy/db](/db) documentation to know how to make queries to the database.

