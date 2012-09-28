# gosexy/checksum

This documentation is a copy of the same one you can read on the command line `go doc github.com/gosexy/checksum`.


## Package

```go
package checksum
    import "github.com/gosexy/checksum"
```

## Functions

### func File
```go
func File(file string, method crypto.Hash) string
```
Computes and returns a checksum of the contents of the given file, a
hashing method is required.

### func String
```go
func String(s string, method crypto.Hash) string
```
Computes and return a hash of the given string, a hashing method is
required.
