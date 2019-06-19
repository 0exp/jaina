# Jaina  &middot; [![Gem Version](https://badge.fury.io/rb/jaina.svg)](https://badge.fury.io/rb/jaina) [![Build Status](https://travis-ci.org/0exp/jaina.svg?branch=master)](https://travis-ci.org/0exp/jaina) [![Coverage Status](https://coveralls.io/repos/github/0exp/jaina/badge.svg?branch=master)](https://coveralls.io/github/0exp/jaina?branch=master)

Simple programming language builder inspired by interpreter pattern.

## Installation

```ruby
gem 'jaina'
```

```shell
$ bundle install
# --- or ---
$ gem install 'jaina'
```

```ruby
require 'jaina'
```

## Usage

- [Registered operators](#registered-operators)
- [Register your own operator](#register-your-own-operator)
- [Register your own operand](#register-your-own-operand)
- [Context API](#context-api)
- [Parse your code (build AST)](#parse-your-code-build-ast)
- [Evaluate your code](#evaluate-your-code)
- [List registered operands and operators](#list-registered-operands-and-operators)

---

### Registered operators

- `AND`
- `OR`
- `NOT`
- `(`, `)` (grouping operators)

---

### Register your own operator

```ruby
class But < Jaina::NonTerminalExpr
  token 'BUT' # use it in your program :)
  associativity_direction :left # associativity (left or right)
  acts_as_vinary_term # binar or unary
  precedence_level 4 # for example: AND > OR, NOT > AND, and etc...
end

Jaina.register_expression(But)
```

---

### Register your own operand

```ruby
class A < Jaina::TerminalExpr
  token 'A'

  # NOTE: context is a custom data holder that passed from expression to expression
  def evaluate(context)
    # your custom evaluation code
  end
end

Jaina.register_expression(A)
```

---

### Context API

```ruby
class A < Jaina::TerminalExpr
  # ... some code

  def evaluate(context)
    ... your code ...
    # ... context ???
    ... your code ...
  end
end

# NOTE: context api

context.keys # => []
context.set(:a, 1) # => 1
context.get(:a) # => 1
context.keys # => [:a]
context.get(:b) # => Jaina::Parser::AST::Contex::UndefinedContextKeyError
```

---

### Parse your code (build AST)

```ruby
Jaina.parse('A AND B AND (C OR D) OR A AND (C OR E)')
# => #<Jaina::Parser::AST:0x00007fd6f424a2e8>
```

---

### Evaluate your code

```ruby
ast = Jaina.parse('A AND B AND (C OR D) OR A AND (C OR E)')
ast.evaluate

# --- or ---
Jaina.evaluate('A AND B AND (C OR D) OR A AND (C OR E)')
```

---

### List and fetch registered operands and operators

```ruby
A = Class.new(Jaina::TerminalExpr) { token 'A' }
B = Class.new(Jaina::TerminalExpr) { token 'B' }
C = Class.new(Jaina::TerminalExpr) { token 'C' }

Jaina.register_expression(A)
Jaina.register_expression(B)
Jaina.register_expression(C)

Jaina.expressions
# => ["AND", "OR", "NOT", "(", ")", "A", "B", "C"]

Jaina.fetch_expression("AND") # => Jaina::Parser::Expression::Operator::And
Jaina.fetch_expression("A") # => A

Jaina.fetch_expression("KEK")
# => raises Jaina::Parser::Expression::Registry::UnregisteredExpressionError
```

---

## Contributing

- Fork it ( https://github.com/0exp/jaina/fork )
- Create your feature branch (`git checkout -b feature/my-new-feature`)
- Commit your changes (`git commit -am 'Add some feature'`)
- Push to the branch (`git push origin feature/my-new-feature`)
- Create new Pull Request

## License

Released under MIT License.

## Authors

[Rustam Ibragimov](https://github.com/0exp)
