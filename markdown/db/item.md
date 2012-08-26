# db.Item

Items are rows or documents, it depends on the database, in MySQL they are on the form ``map[string] interface{}``, that is
maps with string keys and variable-type values but they cannot have nested values, in MongoDB values can be arrays,
so in MongoDB a field can nest a whole structure.

Either way, a ``db.Item`` object must be treated as a ``map[string] interface{}`` and you should cast it to another type to use
it, for example if you expect the key named ``"name"`` to be a string, you may explicitly convert it to string like this:

    fmt.Sprintf("%s", item["name"].(string))

Items do not have methods on their own.
