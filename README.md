# Calculator API

A simple REST API for evaluating mathematical expressions, built with Ruby and Sinatra.

## Features

- **Safe Expression Evaluation**: This API uses the Shunting Yard algorithm to safely parse and evaluate complex mathematical expressions with proper operator precedence.
- **Security**: Allows basic mathematical operations and functions - no code injection risks
- **Binary Operations**: Addition (`+`), subtraction (`-`), multiplication (`*`), division (`/`), exponentiation (`^`)
- **Unary Functions**: Square root (`sqrt`), trigonometric functions (`sin`, `cos`, `tan`), natural logarithm (`log`), absolute value (`abs`)
- **Parentheses Support**: Properly handles nested parentheses with correct operator precedence
- **JSON Response**: Returns results in JSON format
- **Comprehensive Error Handling**: Detailed error messages for invalid expressions and mathematical errors

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

# Exponentiation
curl -X GET 'http://127.0.0.1:4567/calculator?expression=2^3^2'

# Square root
curl -X GET 'http://127.0.0.1:4567/calculator?expression=sqrt(16)'

# Trigonometric functions
curl -X GET 'http://127.0.0.1:4567/calculator?expression=sin(0)'

# Absolute value
curl -X GET 'http://127.0.0.1:4567/calculator?expression=abs(-5)'

# Natural logarithm
curl -X GET 'http://127.0.0.1:4567/calculator?expression=log(1)'

# Combined operations
curl -X GET 'http://127.0.0.1:4567/calculator?expression=sqrt(16)%2B2*3'

# Negative numbers
curl -X GET 'http://127.0.0.1:4567/calculator?expression=(-2)^3'
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
