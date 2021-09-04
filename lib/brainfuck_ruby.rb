# frozen_string_literal: true

require_relative "brainfuck_ruby/version"
require_relative "brainfuck_ruby/errors"
require_relative "brainfuck_ruby/interpreter"
require_relative "brainfuck_ruby/brainlove/transpiler"
require_relative "brainfuck_ruby/brainlove/interpreter"

module BrainfuckRuby
  class Error < StandardError; end
  # Your code goes here...
end
