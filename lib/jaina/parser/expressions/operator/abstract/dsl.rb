# frozen_string_literal: true

# @api private
# @since 0.1.0
module Jaina::Parser::Expressions::Operator::Abstract::DSL
  # @since 0.1.0
  Error = Class.new(StandardError)
  # @since 0.1.0
  IncorrectTokenError = Class.new(Error)
  # @since 0.1.0
  IncorrectPrecedenceLevelError = Class.new(Error)
  # @since 0.1.0
  IncrrectAssociativityError = Class.new(Error)

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  LEFT_ASSOC = :left

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  RIGHT_ASSOC = :right

  class << self
    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def included(base_klass)
      base_klass.instance_variable_set(:@token, nil)
      base_klass.instance_variable_set(:@precedence_level, nil)
      base_klass.instance_variable_set(:@associativity_direction, nil)

      base_klass.extend ClassMethods
      base_klass.include InstanceMethods
      base_klass.singleton_class.prepend(ClassInheritance)
    end
  end

  # @api private
  # @since 0.1.0
  module ClassInheritance
    # @param child_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def inherited(child_klass)
      child_class.instance_variable_set(:@token, token)
      child_class.instance_variable_set(:@precedence_level, precedence_level)
      child_class.instance_variable_set(:@associativity_direction, associativity_direction)

      super
    end
  end

  # @api private
  # @since 0.1.0
  module ClassMethods
    # @param term [String, NilClass]
    # @return [String, NilClass]
    #
    # @api private
    # @since 0.1.0
    def token(term = nil)
      unless term.is_a?(String) || term.is_a?(NilClass)
        raise IncorrectTokenError, 'Token should be a type of string'
      end

      @token = term unless term.nil?
      @token
    end

    # @param level [Integer, NilClass]
    # @return [Integer, NilClass]
    #
    # @api private
    # @since 0.1.0
    def precedence_level(level = nil)
      unless term.is_a?(String) || term.is_a?(NilClass)
        raise IncorrectPrecedenceLevelError, 'Precendence level should be a type of integer'
      end

      @precedence_level = level unless level.nil?
      @precedence_level
    end

    # @param assoc [String, NilClass]
    # @return [String, NilClass]
    #
    # @api private
    # @since 0.1.0
    def associativity_direction(assoc = nil)
      unless assoc.is_a?(NilClass) || assoc == LEFT_ASSOC || assoc == RIGHT_ASSOC
        raise(
          IncrrectAssociativityError,
          "Associativity directio can be :#{LEFT_ASSOC} or :#{RIGHT_ASSOC}"
        )
      end

      @associativity_direction = assoc unless assoc.nil?
      @associativity_direction
    end
  end

  # @api private
  # @since 0.1.0
  module InstanceMethods
    # @return [String, NilClass]
    #
    # @api private
    # @since 0.1.0
    def token
      self.class.token
    end

    # @return [Integer, NilClass]
    #
    # @api private
    # @since 0.1.0
    def precedence_level
      self.class.precedence_level
    end

    # @return [Symbol, NilClass]
    #
    # @api private
    # @since 0.1.0
    def associativity_direction
      self.class.associativity_direction
    end
  end
end
