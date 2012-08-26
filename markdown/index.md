# Isn't Go sexy enough?

Well, yes. [Go][1] is already a sexy programming language with many rich features, we are not really adding anything to the
language, we are just trying to make [Go][1] code easier to understand, code and hack. We love [Go][1].

## How to make it even sexier?

That's the challenge, our best example of a sexier way of doing things is our [database abstraction](/db) layer. We chose
not to use ``db/sql`` as interface because it depends on the drivers' way of doing stuff. In a normal scenario, the driver'
developer decided the format of the connection string and how the results would be returned, and in the end we had to
learn how the things worked on the specific database driver we are using and if we want to change it much code would not work.

And, what if we want to switch our code from a SQL database to a NO-SQL one? There is nothing like a ``db/sql`` driver for a
No-SQL database. What if the driver didn't work as expected and we want to change it? chances are some code had to be hacked to
work with the new driver.

We prefer having only one way of accesing all databases for common tasks such as finding, updating, deleting and modifying rows.
And we managed to create an abstraction that works with SQL and with No-SQL databases with the same rules.

That's just an example. We are commited to find sexier ways of doing stuff with [Go][1] :-).

[1]: http://golang.org
