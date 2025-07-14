require 'spec_helper'

describe 'Calculator API' do
  include Rack::Test::Methods

  def app = Sinatra::Application

  it 'returns correct result' do
    get '/calculator', expression: '2137/(2.5+3-8)*9'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('2137/(2.5+3-8)*9')
    expect(json['result']).to eq(-7693.2)
  end

  it 'returns error for invalid characters' do
    get '/calculator', expression: '2+3; system(\'ls\')'
    expect(last_response.status).to eq(400)
    json = JSON.parse(last_response.body)
    expect(json['error']).to eq('Invalid or missing expression')
  end

  it 'returns error for missing expression' do
    get '/calculator'
    expect(last_response.status).to eq(400)
    json = JSON.parse(last_response.body)
    expect(json['error']).to eq('Invalid or missing expression')
  end

  it 'returns error for malformed expression' do
    get '/calculator', expression: '2++2'
    expect(last_response.status).to eq(400)
    json = JSON.parse(last_response.body)
    expect(json['error']).to eq('Error evaluating expression: Invalid expression: not enough operands')
  end

  it 'calculates basic power correctly' do
    get '/calculator', expression: '2 ^ 3'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('2 ^ 3')
    expect(json['result']).to eq(8.0)
  end

  it 'calculates power with negative exponent' do
    get '/calculator', expression: '2 ^ -2'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('2 ^ -2')
    expect(json['result']).to eq(0.25)
  end

  it 'respects right-associativity of power operator' do
    get '/calculator', expression: '2 ^ 3 ^ 2'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('2 ^ 3 ^ 2')
    expect(json['result']).to eq(512.0)
  end

  it 'respects precedence: power higher than multiplication' do
    get '/calculator', expression: '2 * 3 ^ 2'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('2 * 3 ^ 2')
    expect(json['result']).to eq(18.0)
  end

  it 'uses parentheses to override precedence' do
    get '/calculator', expression: '(2 + 3) ^ 2'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('(2 + 3) ^ 2')
    expect(json['result']).to eq(25.0)
  end

  it 'calculates power of negative base with parentheses' do
    get '/calculator', expression: '(-2) ^ 3'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('(-2) ^ 3')
    expect(json['result']).to eq(-8.0)
  end

  it 'combines power with complex expressions' do
    get '/calculator', expression: '2 ^ 2 + 3 ^ 2'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('2 ^ 2 + 3 ^ 2')
    expect(json['result']).to eq(13.0)
  end

  it 'calculates square root correctly' do
    get '/calculator', expression: 'sqrt 16'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('sqrt 16')
    expect(json['result']).to eq(4.0)
  end

  it 'calculates square root with parentheses' do
    get '/calculator', expression: 'sqrt(25)'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('sqrt(25)')
    expect(json['result']).to eq(5.0)
  end

  it 'calculates absolute value of negative number' do
    get '/calculator', expression: 'abs -5'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('abs -5')
    expect(json['result']).to eq(5.0)
  end

  it 'calculates sin of zero' do
    get '/calculator', expression: 'sin 0'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('sin 0')
    expect(json['result']).to eq(0.0)
  end

  it 'calculates cos of zero' do
    get '/calculator', expression: 'cos 0'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('cos 0')
    expect(json['result']).to eq(1.0)
  end

  it 'calculates tangent of zero' do
    get '/calculator', expression: 'tan 0'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('tan 0')
    expect(json['result']).to eq(0.0)
  end

  it 'calculates natural logarithm' do
    get '/calculator', expression: 'log 1'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('log 1')
    expect(json['result']).to eq(0.0)
  end

  it 'combines square root with addition' do
    get '/calculator', expression: 'sqrt 16 + 2'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('sqrt 16 + 2')
    expect(json['result']).to eq(6.0)
  end

  it 'calculates square root of expression' do
    get '/calculator', expression: 'sqrt(16 + 9)'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('sqrt(16 + 9)')
    expect(json['result']).to eq(5.0)
  end

  it 'combines multiple unary operators' do
    get '/calculator', expression: 'abs(sin 0 - cos 0)'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('abs(sin 0 - cos 0)')
    expect(json['result']).to eq(1.0)
  end

  it 'calculates logarithm of square root' do
    get '/calculator', expression: 'log(sqrt 16)'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('log(sqrt 16)')
    expect(json['result']).to be_within(0.0001).of(1.3862943611198906)
  end

  it 'returns error for square root of negative number' do
    get '/calculator', expression: 'sqrt -1'
    expect(last_response.status).to eq(400)
    json = JSON.parse(last_response.body)
    expect(json['error']).to match(/Error evaluating expression:.*sqrt/)
  end

  it 'returns error for logarithm of zero' do
    get '/calculator', expression: 'log 0'
    expect(last_response.status).to eq(400)
    json = JSON.parse(last_response.body)
    expect(json['error']).to match(/Error evaluating expression:.*Infinity/)
  end

  it 'returns error for unknown function' do
    get '/calculator', expression: 'unknown 5'
    expect(last_response.status).to eq(400)
    json = JSON.parse(last_response.body)
    expect(json['error']).to eq('Error evaluating expression: Unknown function: unknown')
  end

  it 'respects precedence: unary operators before binary operators' do
    get '/calculator', expression: 'sqrt 9 + 1'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('sqrt 9 + 1')
    expect(json['result']).to eq(4.0)
  end

  it 'respects precedence: multiplication and unary operators' do
    get '/calculator', expression: '2 * sqrt 4'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('2 * sqrt 4')
    expect(json['result']).to eq(4.0)
  end

  it 'uses parentheses to override precedence' do
    get '/calculator', expression: 'sqrt(4 + 5)'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json['expression']).to eq('sqrt(4 + 5)')
    expect(json['result']).to eq(3.0)
  end
end
