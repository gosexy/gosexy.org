# Querying the database

Queries are operations on [collections](/db/collection), the ``github.com/gosexy/db`` implements
many special datatypes that can be used to improve code expressiveness and query the database in a
way that is exclusive to the Go language.

## db.Cond

    type Cond map[string]interface{}

Represents conditions and operators in an expression.

    db.Cond { "age": 18 } // Means the condition is to have the "age" field equal to 18.

    db.Cond { "age $lt": 18 } // $lt is a MongoDB operator, if you're using MongoDB, means that you want the "age" field to be lower than 18.

    db.Cond { "age >=": 18 } // >= is a SQL operator, if you're using SQL, means that you want the "age" field to be mayor or equal to 18.

Operators are specified with an space after the field name, so, for MongoDB you can use ``"age $lt"`` or ``"age $gt"`` whereas in SQL you could use
``"age >="`` or ``"age <="``.

## db.And

    type And []interface{}

Relates ``db.Cond``, ``db.And`` and ``db.Or`` types.

For example, if you want to relate two conditions under an AND operation:

    db.And (
      db.Cond { "name": "Peter" },
      db.Cond { "last_name": "Parker "},
    )

## db.Or

    type And []interface{}

Relates ``db.Cond``, ``db.And`` and ``db.Or`` types.

For example, if you want to relate two conditions under an OR operation:

    db.Or (
      db.Cond { "name": "Peter" },
      db.Cond { "last_name": "Parker "},
    )

## db.Sort

    type Sort map[string]interface{}

Determines the order in which items in ``db.Collection.Find()`` or ``db.Collection.FindAll()`` expressions will be returned.

    db.Sort { "age": -1 } // If using MongoDB means: sort by age in descending order.

    db.Sort { "age": "ASC" } // If using SQL means: sort by age in ascending order.

## db.Modify

    type Modify map[string]interface{}

Determines how the matched item or items are going to change in ``db.Collection.Update()`` and ``db.Collection.UpdateAll()`` expressions.

    db.Modify {
      "$inc": {
        "counter": 1
      }
    }


## db.On

    type On []interface{}

Specifies relations with external collections, the specific relation with the parent expression can be determined with
the name of field on the external collection plus the name of the referred parent column between brackets, however this can be only
used along with Cond keytypes.

    db.On {
      db.Collection("external"),
      Cond { "external_key": "{parent_value}" },  Relation exists where the "external_key" field is equal to the parent's "parent_value".
    }

# db.Relate

    type Relate map[string]On

Specifies a one-to-one relation in ``db.Collection.Find()`` and ``db.Collection.FindAll()`` expressions. It consists of a name and a ``db.On`` expression.

You can use the same expressions you would use in a normal ``db.Collection.Find()`` and ``db.Collection.FindAll()`` expressions besides a ``db.Collection``,
you can also use other nested ``db.Collection.Relate`` and ``db.Collection.RelateAll`` expressions. If no ``db.Collection`` is given, the one with the
relation name will be used.

    db.Relate {
      "father": On {
        db.Collection("people"),
        db.Cond { "gender": "man" },
        db.Cond { "id": "{parent_id}" },
      }
    }

## db.RelateAll

    type RelateAll map[string]On

Specifies a one-to-many relation in ``db.Collection.Find()`` and ``db.Collection.FindAll()`` expressions. It consists of a name and a ``db.On`` expression.

You can use the same expressions you would use in a normal ``db.Collection.Find()`` and ``db.Collection.FindAll()`` expressions besides a ``db.Collection``,
you can also use other nested ``db.Collection.Relate`` and ``db.Collection.RelateAll`` expressions. If no ``db.Collection`` is given, the one with the
relation name will be used.

    db.RelateAll {
      "children": On {
        db.Collection("people"),
        db.Cond { "age $lt": 12 },
        db.Cond { "parent_id": "{_id}" },
      }
    }

## db.Limit

    type Limit uint

Sets the limit of results to be returned in ``db.Collection.Find()`` and ``db.Collection.FindAll()`` statements.

## db.Offset

    type Offset uint

Sets how many results will be skipped before returning the queried datased in ``db.Collection.Find()`` and ``db.Collection.FindAll()`` statements.

## db.Set

    type Set map[string]interface{}

Determines new values for the fields on the matched item or items in ``db.Collection.Update()`` and ``db.Collection.UpdateAll()`` expressions.

    db.Set {
      "name": "New Name"
    }

## db.Upsert

    type Upsert map[string]interface{}

Determines new values for the fields on the matched item or items in ``db.Collection.Update()`` and ``db.Collection.UpdateAll()`` expressions.

If no item is found a new one is created.

    db.Upsert {
      "name": "New Name"
    }

## db.Fields
    type Fields []string

Specifies the names of fields to be returned in a statement.
