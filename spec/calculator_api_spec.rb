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
end
