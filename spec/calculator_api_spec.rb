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
end
