require_relative 'MathParserUtils'
require_relative 'Operation'

prompt = '> '
print prompt
while input = gets.chomp
    puts "result: #{processInput(input)}"
    print prompt
end
