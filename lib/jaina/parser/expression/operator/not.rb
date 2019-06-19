# frozen_string_literal: true

module Jaina::Parser::Expression::Operator
  # @api private
  # @since 0.1.0
  class Not < NonTerminal
    precedence_level 4
    associativity_direction :right
    token 'NOT'
    acts_as_unary_term
  end
end
