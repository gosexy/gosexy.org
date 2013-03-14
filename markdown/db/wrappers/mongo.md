# MongoDB wrapper

This package is a wrapper of [mgo](http://labix.org/mgo), a MongoDB driver by
[Gustavo Niemeyer](http://labyx.org).

## Installation

### Driver pre-requisites

The [bazaar](http://bazaar.canonical.com/en/) version control system is required
to install `mgo`.

```sh
# OSX
brew install bzr

# Debian based
sudo aptitude install bzr

# ArchLinux
sudo pacman -S bzr
```

### Downloading and installing

```sh
go get github.com/gosexy/db/mongo
```

## Usage

Import the `gosexy/db` and `gosexy/db/mongo` packages.

```go
import (
  "github.com/gosexy/db"
	# Note that we are importing to the blank identifier.
  _ "github.com/gosexy/db/mongo"
)
```

### Connecting to a MongoDB database

```go
sess, err := db.Open("mongo", db.DataSource{Host: "127.0.0.1", ...})

if err != nil {
	panic(err)
}

defer sess.Close()
```

### Querying the database

Check out the [gosexy/db documentation](/db) for documentation in how to query
a collection.

