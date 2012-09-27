# db.Item

Items are rows or documents, it depends on the database, in MySQL they are on the form ``map[string] interface{}``, that is
maps with string keys and variable-type values but they cannot have nested values, in MongoDB values can be arrays,
so in MongoDB a field can nest a whole structure.

Either way, a ``db.Item`` object can be treated as a ``map[string] interface{}`` but castings and conversions may be tricky,
so this type has a few methods that may help working with them

```go
type Item map[string]interface{}
```

## db.Item.GetString(key string) *string*

Returns the string value of the element with the specified key.

## db.Item.GetDate(key string) *time.Time*

Returns the time value of the element with the specified key.

## db.Item.GetDuration(key string) *time.Duration*

Returns the duration value of the element with the specified key.

## db.Item.GetTuple(key string) *sugar.Tuple*

Returns the map value of the element with the specified key.

## db.Item.GetList(key string) *sugar.List*

Returns the sugar.List value of the element with the specified key.

## db.Item.GetInt(key string) *int64*

Returns the integer value of the element with the specified key

## db.Item.GetFloat(key string) *float64*

Returns the float value of the element with the specified key

## db.Item.GetBool(key string) *bool*

Returns the boolean value of the element with the specified key
