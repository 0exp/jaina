# frozen_string_literal: true

# @api private
# @since 0.1.0
class Jaina::Parser::Expression::Not < Jaina::Parser::Expression::NonTerminal
  precedence_level 4
  associativity_direction :right
  token 'NOT'
end
