class Calculator
  OPERATORS = {
    '+' => { precedence: 1, func: ->(a, b) { a + b } },
    '-' => { precedence: 1, func: ->(a, b) { a - b } },
    '*' => { precedence: 2, func: ->(a, b) { a * b } },
    '/' => { precedence: 2, func: ->(a, b) { a / b } }
  }

  attr_reader :expression

  def initialize(expression)
    @expression = expression
  end

  def evaluate
    return 0 if expression.nil? || expression.strip.empty?

    tokens = tokenize
    queue = shunting_yard(tokens)
    evaluate_postfix(queue)
  end

  private

  def tokenize
    tokens = []
    i = 0

    while i < expression.length
      char = expression[i]

      case char
      when ' '
        i += 1
      when '0'..'9'
        num = ''
        while i < expression.length && (expression[i].between?('0', '9') || expression[i] == '.')
          num += expression[i]
          i += 1
        end

        tokens << { type: :number, value: num.to_f }
      when '+', '-', '*', '/'
        tokens << { type: :operator, value: char }
        i += 1
      when '('
        tokens << { type: :left_paren, value: char }
        i += 1
      when ')'
        tokens << { type: :right_paren, value: char }
        i += 1
      else
        raise "Invalid character: #{char}"
      end
    end

    tokens
  end

  def shunting_yard(tokens)
    queue = []
    operator_stack = []

    tokens.each do |token|
      case token[:type]
      when :number
        queue << token
      when :operator
        queue << operator_stack.pop while should_pop_operator?(operator_stack, token)
        operator_stack << token

      when :left_paren
        operator_stack << token

      when :right_paren
        queue << operator_stack.pop while !operator_stack.empty? && operator_stack.last[:type] != :left_paren
        raise 'Mismatched parentheses: missing opening parenthesis' if operator_stack.empty?

        operator_stack.pop
      end
    end

    until operator_stack.empty?
      raise 'Mismatched parentheses: missing closing parenthesis' if operator_stack.last[:type] == :left_paren

      queue << operator_stack.pop
    end
    queue
  end

  def should_pop_operator?(operator_stack, current_token)
    return false if operator_stack.empty?
    return false if operator_stack.last[:type] != :operator

    stack_precedence = OPERATORS[operator_stack.last[:value]][:precedence]
    current_precedence = OPERATORS[current_token[:value]][:precedence]

    stack_precedence > current_precedence || stack_precedence == current_precedence
  end

  def evaluate_postfix(postfix)
    stack = []

    postfix.each do |token|
      case token[:type]
      when :number
        stack << token[:value]

      when :operator
        raise 'Invalid expression: not enough operands' if stack.length < 2

        b = stack.pop
        a = stack.pop

        result = OPERATORS[token[:value]][:func].call(a, b)
        stack << result
      end
    end

    raise 'Invalid expression: too many operands' if stack.length != 1

    stack.first
  end
end
