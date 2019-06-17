# frozen_string_literal: true

# @api private
# @since 0.1.0
class Jaina::Parser::Expression::Or < Jaina::Parser::Expression::NonTerminal
  precedence_level 2
  associativity_direction :left
  token 'OR'
end
