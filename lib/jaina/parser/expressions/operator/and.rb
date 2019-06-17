# frozen_string_literal: true

# @api private
# @since 0.1.0
class Jaina::Parser::Expressions::And < Jaina::Parser::Expressions::NonTerminal
  precedence_level 3
  associativty_direction :left
  token 'AND'
end
