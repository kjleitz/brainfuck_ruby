# frozen_string_literal: true

module BrainfuckRuby
  module Brainlove
    # Executes brainlove code by transpiling brainlove into brainfuck, then
    # executing that transpiled result using the brainfuck interpreter.
    class Interpreter
      attr_reader :code
      attr_accessor :transpiled

      def initialize(brainlove_code)
        @code = brainlove_code
        @transpiled = ""
      end

      def execute!
        self.transpiled = Transpiler.new(code).transpile! if transpiled.empty?
        BrainfuckRuby::Interpreter.new(transpiled).execute!
      end
    end
  end
end
