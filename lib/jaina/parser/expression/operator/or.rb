# frozen_string_literal: true

module Jaina::Parser::Expression::Operator
  # @api private
  # @since 0.1.0
  class Or < NonTerminal
    precedence_level 2
    associativity_direction :left
    token 'OR'
    acts_as_binary_term
  end
end
