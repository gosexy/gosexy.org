# gosexy/canvas

`gosexy/canvas` is an image processing library for [Go][4] that uses
[ImageMagick][6]'s MagickWand as backend. It relies on [cgo][5] and
the [source code][7] is available at github.

## Prerequisites

The ImageMagick's header files are required.

```sh
# OSX
brew install imagemagick

# Arch Linux
sudo pacman -S extra/imagemagick

# Debian
sudo aptitude install libmagickwand-dev
```

### Other Operative Systems

Please, follow the [install from source][1] tutorial.

## Installation

After installing ImageMagick's header files, pull `gosexy/canvas` from github:

```sh
go get -u github.com/gosexy/canvas
```

## Usage

```go
package main

import "github.com/gosexy/canvas"

func main() {
  cv := canvas.New()

  // Opening some image from disk.
  err := cv.Open("examples/input/example.png")

  if err == nil {

    // Photo auto orientation based on EXIF tags.
    cv.AutoOrientate()

    // Creating a squared thumbnail
    cv.Thumbnail(100, 100)

    // Saving the thumbnail to disk.
    cv.Write("examples/output/example-thumbnail.png")
  }
}
```

## Documentation

You can browse the docs online at [godoc.org/github.com/gosexy/canvas][2].

[1]: http://www.imagemagick.org/script/magick-wand.php
[2]: http://www.imagemagick.org/script/install-source.php
[3]: http://godoc.org/github.com/gosexy/canvas
[4]: http://www.golang.org
[5]: http://golang.org/cmd/cgo/
[6]: http://www.imagemagick.org
[7]: http://github.com/gosexy/canvas
