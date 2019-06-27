# frozen_string_literal: true

module Jaina::Parser::Expression
  class Registry
    # @api private
    # @since 0.1.0
    module AccessInterfaceMixin
      class << self
        # @param base_klass [Class]
        # @return [void]
        def included(base_klass)
          base_klass.instance_variable_set(:@__expression_registry__, Registry.new)
          base_klass.extend(ClassMethods)
        end
      end

      # @api private
      # @since 0.1.0
      module ClassMethods
        # @return [Array<String>]
        #
        # @api private
        # @since 0.1.0
        def expressions
          @__expression_registry__.expressions
        end

        # @param extension_token [String]
        # @return [Class{Jaina::Parser::Expressions::Operator::Abstract}]
        #
        # @api private
        # @since 0.1.0
        def [](extension_token)
          @__expression_registry__[extension_token]
        end
        alias_method :fetch, :[]

        # @param expression [Class{Jaina::Parser::Expressions::Operator::Abstract}]
        # @return [void]
        #
        # @api private
        # @since 0.1.0
        def register(expression)
          @__expression_registry__.register(expression)
        end

        # @param expression [Class{Jaina::Parser::Expressions::Operator::Abstract}]
        # @return [void]
        #
        # @api private
        # @since 0.5.0
        def redefine(expression)
          @__expression_registry__.redefine(expression)
        end
      end
    end
  end
end
