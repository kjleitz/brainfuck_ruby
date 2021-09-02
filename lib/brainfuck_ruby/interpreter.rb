# frozen_string_literal: true

module BrainfuckRuby
  # Interprets brainfuck code. Initialize with a string containing some
  # brainfuck, and then call `#execute!` on the instance to execute that code.
  class Interpreter
    attr_reader :options, :cell_values, :code, :cursor
    attr_accessor :current_cell, :nesting

    def initialize(brainfuck_code)
      @code = brainfuck_code
      reset!
    end

    def reset!
      @cell_values = Hash.new(0)
      @current_cell = 0
      @cursor = 0
      @nesting = 0
    end

    def execute!
      loop do
        instruction = current_instruction
        break if instruction.nil?

        handle_instruction!(instruction)
        next_instruction!
      end

      reset!
      nil
    end

    def handle_instruction!(instruction)
      case instruction
      when ">" then right!
      when "<" then left!
      when "+" then increment!
      when "-" then decrement!
      when "[" then goto_closing_brace! if current_cell_value.zero?
      when "]" then goto_opening_brace! if current_cell_value.positive?
      when "." then print!
      when "," then read!
      end
    end

    def cursor=(value)
      raise "Cursor position cannot go below zero" if value.negative?

      @cursor = value
    end

    def current_instruction
      code[cursor]
    end

    def current_cell_value
      cell_values[current_cell]
    end

    def current_cell_value=(value)
      cell_values[current_cell] = value % 256
    end

    def current_cell_character
      current_cell_value.chr
    end

    def next_instruction!
      self.cursor += 1
    end

    def right!
      self.current_cell += 1
    end

    def left!
      self.current_cell -= 1
    end

    def increment!
      self.current_cell_value += 1
    end

    def decrement!
      self.current_cell_value -= 1
    end

    def goto_closing_brace!
      goto_matching_brace_to_the :right
    end

    def goto_opening_brace!
      goto_matching_brace_to_the :left
    end

    def print!
      print(current_cell_character)
    end

    def read!
      input = gets.chomp
      self.current_cell_value = numeric?(input) ? input.to_i : input.ord
    end

    def numeric?(value)
      !!Float(value) rescue false
    end

    private

    # `direction` should be `:right` or `:left`
    def goto_matching_brace_to_the(direction)
      cursor_modifier = { right: 1, left: -1 }[direction]
      nesting = 0

      loop do
        case current_instruction
        when "[" then nesting += 1
        when "]" then nesting -= 1
        end

        break if nesting.zero?

        self.cursor += cursor_modifier
      end
    end
  end
end
