# frozen_string_literal: true

module Jaina::Parser::Expression::Operator
  # @api private
  # @since 0.1.0
  class And < NonTerminal
    precedence_level 3
    associativity_direction :left
    token 'AND'
    acts_as_binary_term
  end
end
