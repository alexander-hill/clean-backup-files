# Clean up after editors! #
When editing a file named `foo`, Emacs will leave behind a `foo~` backup file; or, if you’ve thought better of the edit and left without saving the buffer, you get `#foo#`.

Sometimes these files are nice to have! Most of the time they’re just annoying, so this tool recursively cleans them out of a directory.

Oh, this tool special-cases the `.git` directory, since I never want that cleaned up, *but* it does recurse into other hidden directories. Also if you have a loop caused by symbolic links it’ll keep chasing its tail until it blows the stack, so don’t do that.
