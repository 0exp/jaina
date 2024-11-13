# Jaina  &middot; [![Gem Version](https://badge.fury.io/rb/jaina.svg)](https://badge.fury.io/rb/jaina)

Simple programming language builder inspired by interpreter pattern.
You can build your own languages with custom operands and operators for any project purposes.

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
- [Custom operator/operand arguments](#custom-operatoroperand-arguments)
- [List registered operands and operators](#list-and-fetch-registered-operands-and-operators)
- [Full example](#full-example)

---

### Registered operators

- `AND`
- `OR`
- `NOT`
- `(`, `)` (grouping operators)

---

### Register your own operator

```ruby
# step 1: define new operator
class But < Jaina::NonTerminalExpr
  token 'BUT' # use it in your program :)
  associativity_direction :left # associativity (left or right)
  acts_as_binary_term # binar or unary
  precedence_level 4 # for example: AND > OR, NOT > AND, and etc...
end

# step 2: regsiter your operator
Jaina.register_expression(But)
```

---

### Register your own operand

```ruby
# step 1: define new operand
class A < Jaina::TerminalExpr
  token 'A'

  # NOTE: context is a custom data holder that passed from expression to expression
  def evaluate(context)
    # your custom evaluation code
  end
end

# step 2: regsiter your operand
Jaina.register_expression(A)

# step X: redefine existing operand (with the same token)
class NewA < Jaina::TerminalExpr
  token 'A'
end
Jaina.redefine_expression(NewA)
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
# NOTE: without arguments
Jaina.parse('A AND B AND (C OR D) OR A AND (C OR E)')
# => #<Jaina::Parser::AST:0x00007fd6f424a2e8>

# NOTE: with arguments
Jaina.parse('A[1,2] AND B[3,4]')
# => #<Jaina::Parser::AST:0x00007fd6f424a2e9>
```

---

### Evaluate your code

```ruby
ast = Jaina.parse('A AND B[5,test] AND (C OR D) OR A AND (C OR E)')
ast.evaluate

# --- or ---
Jaina.evaluate('A AND B[5,test] AND (C OR D) OR A AND (C OR E)')

# --- you can set initial context of your program ---
Jaina.evaluate('A AND B[5,test]', login: 'admin', logged_in: true)
```

---

### Custom operator/operand arguments

```ruby
# NOTE: use []
Jaina.parse('A[1,true] AND B[false,"false"]')

# NOTE:
#   all your arguments will be typecasted to
#   the concrete type inferred from the argument literal

Jaina.parse('A[1,true,false,"false"]') # 1, true, false "false"

# NOTE: access to the argument list
class A < Jaina::TerminalExpr
  token 'A'

  def evaluate(context)
    # A[1,true,false,"false"]

    arguments[0] # => 1
    arguments[1] # => true
    arguments[2] # => false
    arguments[3] # => "false"
  end
end
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

Jaina.fetch_expression("AND") # => Jaina::Parser::Expression::Unit::And
Jaina.fetch_expression("A") # => A

Jaina.fetch_expression("KEK")
# => raises Jaina::Parser::Expression::Registry::UnregisteredExpressionError
```

---

### Full example

```ruby
# step 1: create new operand
class AddNumber < Jaina::TerminalExpr
  token 'ADD'

  def evaluate(context)
    context.set(:current_value, context.get(:current_value) + 10)
  end
end

# step 2: create another new operand
class CheckNumber < Jaina::TerminalExpr
  token 'CHECK'

  def evaluate(context)
    context.get(:current_value) < 0
  end
end

# step 4: and another new :)
class InitState < Jaina::TerminalExpr
  token 'INIT'

  def evaluate(context)
    initial_value = arguments[0] || 0

    context.set(:current_value, initial_value)
  end
end

# step 5: register new oeprands
Jaina.register_expression(AddNumber)
Jaina.register_expression(CheckNumber)
Jaina.register_expression(InitState)

# step 6: run your program

# NOTE: with initial context
Jaina.evaluate('CHECK AND ADD', current_value: -1) # => 9
Jaina.evaluate('CHECK AND ADD', current_value: 2) # => false

# NOTE: without initial context
Jaina.evaluate('INIT AND ADD') # => 10
Jaina.evaluate('INIT AND (CHECK OR ADD)') # => 10

# NOTE: with arguments
Jaina.evaluate('INIT[100] AND ADD') => # 112
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
