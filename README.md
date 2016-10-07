#MathParser

A simple ruby tool which parses a math expression
down to either a number or operation tree.

### Usage

`cd path/to/MathParser`  
`ruby src/MathParser.rb`

Enter math expressions to see the result.  Number
operations will be evaluated down to a numeric result.
Any text entered will be treated as a variable, and
an operation (object) will be created.  Multiple
operations will be chained together into a binary
tree.

### How it works

##### Example (numbers only)

The user starts the tool and enters a math expression

`((4 * 6) - 3)`

MathParser uses regex to split the input into an array of tokens

`['(', '(', '4', '*', '6', ')', '-', '3', ')']`

These tokens are then run through an implementation of Dijkstra's
Shunting Yard algorithm to convert the expression from infix
notation to postfix notation (also referred to as reverse polish
notation).

`Infix: ((4*6)-3)`  
`Postfix: 46*3-`  

The postfix expression is then simple to evaluate using a stack.

`Postfix: 46*3-`  
`Result: 21`  

##### Example (with variables)

The user starts the tool and enters a math expression with variables

`((x * (2 ^ 3)) + y)`

Again, regex is used to split the input into tokens

`['(', '(', 'x', '*', '(', '2', '^', '3', ')', ')', '+', 'y']`

Input is converted from infix to postfix

`Infix: ((x*(2^3))+y)`  
`Postfix: x23^*y+`

When we try to evaluate the operations containing variables, we simply
create an instance of the Operation object containing the two values
and their operator.  The following is a JSON representation of the result
of this example.

Result:  
`{  
  value1: {  
    value1: 'x',  
    operator: '*',  
    value2: 8  
  },  
  operator: '+',  
  value2: 'y'  
}`

Note that both the result and its value1 are Operation instances.  This
is a very simple example but the resulting tree of Operations could be
arbitrarily large.
