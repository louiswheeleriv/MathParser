MathParser

A simple ruby tool which parses a math expression
down to either a number or operation tree.

Usage:

cd path/to/MathParser
ruby src/MathParser.rb

Enter math expressions to see the result.  Number
operations will be evaluated down to a numeric result.
Any text entered will be treated as a variable, and
an operation (object) will be created.  Multiple
operations will be chained together into a binary
tree.
