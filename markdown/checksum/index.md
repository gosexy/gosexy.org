# gosexy/checksum

Trivial wrapper around Go's crypto functions that puts a little sugar on
creating checksum hashes of strings or files.

## Installation

Use `go get` to download and install `gosexy/checksum`.

```sh
go get github.com/gosexy/checksum
```

## Sample usage

```go
package main

import (
  "crypto"
  "fmt"
  "github.com/gosexy/checksum"
)

func main() {
  // Creating a MD5 hash of a string.
  fmt.Printf(
    "MD5('pass') = %s\n",
    checksum.String("pass", crypto.MD5),
  )

  // Creating a SHA1 hash of a string.
  fmt.Printf(
    "SHA1('pass') = %s\n",
    checksum.String("pass", crypto.SHA1)
  )

  // Creating a SHA256 checksum of a file (as in sha256sum).
  fmt.Printf(
    "SHA256('./input/file.txt') = %s\n",
    checksum.File("input/file.txt", crypto.SHA256)
  )
}
```

## Documentation

Documentation is available at [godoc.org/github.com/gosexy/checksum][1].

[1]: http://godoc.org/github.com/gosexy/checksum
