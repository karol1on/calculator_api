require 'sinatra'
require './calculator'

ALLOWED_EXPR = %r{^[0-9.+\-*/()\s\^]+$}

get '/calculator' do
  content_type :json
  expression = params['expression']

  if expression.nil? || !expression.match?(ALLOWED_EXPR)
    status 400
    return { error: 'Invalid or missing expression' }.to_json
  end

  result = Calculator.new(expression).evaluate

  { expression: expression, result: result }.to_json
rescue Exception => e
  status 400
  { error: "Error evaluating expression: #{e.message}" }.to_json
end
