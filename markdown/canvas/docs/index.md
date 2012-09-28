# gosexy/canvas documentation

This documentation is a copy of the same one you can read on the command line `go doc github.com/gosexy/canvas`.

```
PACKAGE

package canvas
    import "github.com/gosexy/canvas"


VARIABLES

var (
    STROKE_BUTT_CAP   = uint(C.ButtCap)
    STROKE_ROUND_CAP  = uint(C.RoundCap)
    STROKE_SQUARE_CAP = uint(C.SquareCap)

    STROKE_MITER_JOIN = uint(C.MiterJoin)
    STROKE_ROUND_JOIN = uint(C.RoundJoin)
    STROKE_BEVEL_JOIN = uint(C.BevelJoin)

    FILL_EVEN_ODD_RULE = uint(C.EvenOddRule)
    FILL_NON_ZERO_RULE = uint(C.NonZeroRule)

    RAD_TO_DEG = 180 / math.Pi
    DEG_TO_RAD = math.Pi / 180

    UNDEFINED_ORIENTATION    = uint(C.UndefinedOrientation)
    TOP_LEFT_ORIENTATION     = uint(C.TopLeftOrientation)
    TOP_RIGHT_ORIENTATION    = uint(C.TopRightOrientation)
    BOTTOM_RIGHT_ORIENTATION = uint(C.BottomRightOrientation)
    BOTTOM_LEFT_ORIENTATION  = uint(C.BottomLeftOrientation)
    LEFT_TOP_ORIENTATION     = uint(C.LeftTopOrientation)
    RIGHT_TOP_ORIENTATION    = uint(C.RightTopOrientation)
    RIGHT_BOTTOM_ORIENTATION = uint(C.RightBottomOrientation)
    LEFT_BOTTOM_ORIENTATION  = uint(C.LeftBottomOrientation)
)


TYPES

type Canvas struct {
    // contains filtered or unexported fields
}

func New() *Canvas
    Returns a new canvas object.

func (cv Canvas) AdaptiveBlur(sigma float64) bool
    Adaptively blurs the image by blurring less intensely near the edges and
    more intensely far from edges.

func (cv Canvas) AdaptiveResize(width uint, height uint) bool
    Adaptively changes the size of the canvas, returns true on success.

func (cv Canvas) AddNoise() bool
    Adds random noise to the canvas.

func (cv Canvas) AppendCanvas(source Canvas, x int, y int) bool
    Puts a canvas on top of the current one.

func (cv Canvas) AutoOrientate() bool
    Auto-orientates canvas based on its original image's EXIF metadata

func (cv Canvas) BackgroundColor() string
    Returns canvas' background color.

func (cv Canvas) Blank(width uint, height uint) bool
    Creates an empty canvas of the given dimensions.

func (cv Canvas) Blur(sigma float64) bool
    Convolves the canvas with a Gaussian function given its standard
    deviation.

func (cv Canvas) Chop(x int, y int, width uint, height uint) bool
    Removes a region of a canvas and collapses the canvas to occupy the
    removed portion.

func (cv Canvas) Circle(radius float64)
    Draws a circle over the current drawing surface.

func (cv Canvas) Crop(x int, y int, width uint, height uint) bool
    Extracts a region from the canvas.

func (cv Canvas) Destroy()
    Destroys canvas.

func (cv Canvas) Ellipse(a float64, b float64)
    Draws an ellipse centered at the current coordinate system's origin.

func (cv Canvas) FillColor() string
    Returns the fill color for enclosed areas on the current drawing
    surface.

func (cv Canvas) Flip() bool
    Creates a vertical mirror image by reflecting the pixels around the
    central x-axis.

func (cv Canvas) Flop() bool
    Creates a horizontal mirror image by reflecting the pixels around the
    central y-axis.

func (cv Canvas) Height() uint
    Returns canvas' height.

func (cv Canvas) Init()
    Initializes the canvas environment.

func (cv Canvas) Line(x float64, y float64)
    Draws a line starting on the current coordinate system origin and ending
    on the specified coordinates.

func (cv Canvas) Metadata() map[string]string
    Returns all metadata keys from the currently loaded image.

func (cv Canvas) Open(filename string) bool
    Opens an image file, returns true on success.

func (cv Canvas) PopDrawing() bool
    Destroys the current drawing surface and returns the latest surface that
    was pushed to the stack.

func (cv Canvas) PushDrawing() bool
    Clones the current drawing surface and stores it in a stack.

func (cv Canvas) Quality() uint
    Returns the compression quality of the canvas. Ranges from 1 (lowest) to
    100 (highest).

func (cv Canvas) Rectangle(x float64, y float64)
    Draws a rectangle over the current drawing surface.

func (cv Canvas) Resize(width uint, height uint) bool
    Changes the size of the canvas, returns true on success.

func (cv Canvas) Rotate(rad float64)
    Applies a rotation of a given angle (in radians) on the current
    coordinate system.

func (cv Canvas) RotateCanvas(rad float64)
    Rotates the whole canvas.

func (cv Canvas) Scale(x float64, y float64)
    Applies a scaling factor to the units of the current coordinate system.

func (cv Canvas) SetBackgroundColor(color string) bool
    Sets canvas' background color.

func (cv Canvas) SetBrightness(factor float64) bool
    Adjusts the canvas's brightness given a factor (-1.0 thru 1.0)

func (cv Canvas) SetFillColor(color string)
    Sets the fill color for enclosed areas on the current drawing surface.

func (cv Canvas) SetHue(factor float64) bool
    Adjusts the canvas's hue given a factor (-1.0 thru 1.0)

func (cv Canvas) SetMetadata(key string, value string)
    Associates a metadata key with its value.

func (cv Canvas) SetQuality(quality uint) bool
    Changes the compression quality of the canvas. Ranges from 1 (lowest) to
    100 (highest).

func (cv Canvas) SetSaturation(factor float64) bool
    Adjusts the canvas's saturation given a factor (-1.0 thru 1.0)

func (cv Canvas) SetStrokeAntialias(value bool)
    Sets antialiasing setting for the current drawing stroke.

func (cv Canvas) SetStrokeColor(color string)
    Sets the stroke color on the current drawing surface.

func (cv Canvas) SetStrokeLineCap(value uint)
    Sets the type of the line cap on the current drawing surface.

func (cv Canvas) SetStrokeLineJoin(value uint)
    Sets the type of the line join on the current drawing surface.

func (cv Canvas) SetStrokeOpacity(value float64)
    Sets the opacity of the stroke on the current drawing surface.

func (cv Canvas) SetStrokeWidth(value float64)
    Sets the width of the stroke on the current drawing surface.

func (cv Canvas) StrokeAntialias() bool
    Returns antialiasing setting for the current drawing stroke.

func (cv Canvas) StrokeColor() string
    Returns the stroke color on the current drawing surface.

func (cv Canvas) StrokeLineCap() uint
    Returns the type of the line cap on the current drawing surface.

func (cv Canvas) StrokeLineJoin() uint
    Returns the type of the line join on the current drawing surface.

func (cv Canvas) StrokeOpacity() float64
    Returns the opacity of the stroke on the current drawing surface.

func (cv Canvas) StrokeWidth() float64
    Returns the width of the stroke on the current drawing surface.

func (cv Canvas) Thumbnail(width uint, height uint) bool
    Creates a centered thumbnail of the canvas.

func (cv Canvas) Translate(x float64, y float64)
    Moves the current coordinate system origin to the specified coordinate.

func (cv Canvas) Update()
    Copies a drawing surface to the canvas.

func (cv Canvas) Width() uint
    Returns canvas' width.

func (cv Canvas) Write(filename string) bool
    Writes canvas to a file, returns true on success.


SUBDIRECTORIES

	examples

```
