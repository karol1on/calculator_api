# Calculator API

A simple REST API for evaluating mathematical expressions, built with Ruby and Sinatra.

## Features

- **Safe Expression Evaluation**: Uses the Shunting Yard algorithm to safely parse and evaluate mathematical expressions
- **Security**: Only allows basic mathematical operations and numbers - no code injection risks
- **Support for Operations**: Addition (`+`), subtraction (`-`), multiplication (`*`), division (`/`)
- **Parentheses Support**: Properly handles nested parentheses with correct operator precedence
- **JSON Response**: Returns results in JSON format
- **Error Handling**: Comprehensive error handling for invalid expressions

## Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   bundle install
   ```

## Usage

### Starting the Server

```bash
ruby calculator_api.rb
```

The server will start on `http://127.0.0.1:4567`.

### API Endpoints

#### GET /calculator

Evaluates a mathematical expression passed as a query parameter.

**Parameters:**

- `expression` (required): The mathematical expression to evaluate

**Example Requests:**

```bash
# Basic arithmetic
curl -X GET 'http://127.0.0.1:4567/calculator?expression=2%2B3*4'

# Complex expression with parentheses
curl -X GET 'http://127.0.0.1:4567/calculator?expression=2137/(2.5%2B3-8)*9'

# Decimal numbers
curl -X GET 'http://127.0.0.1:4567/calculator?expression=15.5*2.2'

# Nested parentheses
curl -X GET 'http://127.0.0.1:4567/calculator?expression=(10%2B5)*(8-3)/2'
```

**Note:** In URL query parameters, the `+` character needs to be URL-encoded as `%2B`.

**Success Response:**

```json
{
  "expression": "2+3*4",
  "result": 14.0
}
```

**Error Response:**

```json
{
  "error": "Invalid or missing expression"
}
```

## Testing

Run the test suite:

```bash
rspec
```

## Dependencies

- **Ruby**
- **Sinatra**: Web framework
- **RSpec**: Testing framework (development)
- **Rack::Test**: HTTP testing (development)
