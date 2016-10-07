#
# Utility functions
#

# Extension of Array with custom functions
class Array
    def clean
        for i in (0..self.length)
            if self[i] == nil || (self[i] =~ /^\s*$/) == 0
                self.delete_at(i)
                i -= 1
            end
        end
        return self
    end
end

def processInput(input)
    if input == 'q' || input == 'quit' || input == 'exit'
        puts 'Goodbye!'
        exit
    end

    tokens = getTokensFromInput(input)
    postfixTokens = infixToPostfix(tokens)
    if !postfixTokens.nil?
        result = postfixToOperation(postfixTokens)
        if result.class == Operation
            return result.toString()
        else
            return result
        end
    else
        return nil
    end
end

def getTokensFromInput(input)
    return input.gsub(/\s+/, '').split(/(\+|\-|\*|\/|\^|\%|\(|\)|\s){1}/).clean()
end

def isNumber(item)
    return (item.class != Operation and
    item.class == Fixnum ||
    item.class == Integer ||
    item.class == Float ||
    item.to_f.to_s == item ||
    item.to_i.to_s == item)
end

# Implementation of Shunting Yard to convert infix expression to postfix
def infixToPostfix(tokens)
    operators = ['-', '+', '/', '%', '*', '^']
    parentheses = ['(', ')'];
    output = []
    stack = []

    while tokens.length > 0

        # Read a token
        token = tokens.shift

        if (!operators.include? token) && (!parentheses.include? token)
            # Add numbers to the output queue
            output.push(token)
        elsif operators.include? token
            # Add operators to the stack, popping any higher
            # precedence operators from the stack first
            while operators.include? stack.last and
                operators.index(stack.last) > operators.index(token)
                output.push(stack.pop())
            end
            stack.push(token)
        else
            if token == '('
                # Add left parentheses to the stack
                stack.push(token)
            else
                # Pop operators from stack to output queue until left parenthesis
                while stack.last != '('
                    output.push(stack.pop())
                end
                if !stack.empty? && stack.last == '('
                    # Drop the parentheses
                    stack.pop()
                else
                    return puts 'Mismatched parentheses!'
                end
            end
        end
    end

    # All tokens have been read, pop stack to output queue
    while !stack.empty?
        if operators.include? stack.last
            output.push(stack.pop())
        else
            # Parentheses in stack at this point means mismatch
            return puts 'Mismatched parentheses!'
        end
    end

    return output
end

# Convert postfixTokens to either Operation or number
def postfixToOperation(postfixTokens)
    operators = ['-', '+', '/', '%', '*', '^']
    stack = []

    while !postfixTokens.empty?
        token = postfixTokens.shift
        if !operators.include? token
            # Push numbers and symbols to the stack
            stack.push(token)
        else
            if stack.length > 1
                operator = token
                token2 = stack.pop()
                token1 = stack.pop()
                stack.push(evaluateOperation(token1, operator, token2))
            else
                return puts "postfixToOperation: Not enough tokens in stack while evaluating expression"
            end
        end
    end

    if stack.length == 1
        return stack.pop()
    elsif stack.length > 1
        return puts "postfixToOperation: Multiple items left in stack after evaluation"
    else
        return puts "postfixToOperation: No items left in stack after evaluation"
    end
end

def evaluateOperationNums(num1, operator, num2)
    if operator == '+'
        return (Float(num1) + Float(num2))
    elsif operator == '-'
        return (Float(num1) - Float(num2))
    elsif operator == '*'
        return (Float(num1) * Float(num2))
    elsif operator == '/'
        return (Float(num1) / Float(num2))
    elsif operator == '%'
        return (Float(num1) % Float(num2))
    elsif operator == '^'
        return (Float(num1) ** Float(num2))
    else
        return puts "Invalid arithmetic operator #{operator}"
    end
end

# Evaluate two tokens and an operator to either a number or an Operation
def evaluateOperation(token1, operator, token2)
    if token1.class == String and token1[0] == '.'
        token1.prepend('0')
    end
    if token2.class == String and token2[0] == '.'
        token2.prepend('0')
    end
    if isNumber(token1) && isNumber(token2)
        # Both are numbers, evaluate to number
        return evaluateOperationNums(token1, operator, token2)
    else
        # One or both is/are symbols, evaluate to Operation
        if isNumber(token1)
            # token2 is a symbol
            return Operation.new(Float(token1), operator, token2)
        elsif isNumber(token2)
            # token1 is a symbol
            return Operation.new(token1, operator, Float(token2))
        else
            # Both tokens are symbols
            return Operation.new(token1, operator, token2)
        end
    end
end
