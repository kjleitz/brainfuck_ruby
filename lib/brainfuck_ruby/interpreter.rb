# frozen_string_literal: true

module BrainfuckRuby
  # Interprets brainfuck code. Initialize with a string containing some
  # brainfuck, and then call `#execute!` on the instance to execute that code.
  class Interpreter
    attr_reader :options, :cell_values, :code, :cursor, :cursor_max
    attr_accessor :current_cell, :nesting

    def initialize(brainfuck_code)
      @code = brainfuck_code
      @cursor_max = code.length - 1
      reset!
    end

    def reset!
      @cell_values = Hash.new(0)
      @current_cell = 0
      @cursor = 0
      @nesting = 0
      nil
    end

    def execute!
      loop do
        handle_instruction!(current_instruction)
        cursor_to_next_instruction!
      end
    rescue CursorAfterEndOfFileError
      reset!
    end

    def handle_instruction!(instruction)
      case instruction
      when ">" then next_cell!
      when "<" then prev_cell!
      when "+" then increment_cell!
      when "-" then decrement_cell!
      when "[" then cursor_to_closing_bracket! if current_cell_value.zero?
      when "]" then cursor_to_opening_bracket! if current_cell_value.positive?
      when "." then print!
      when "," then read!
      end
    end

    def cursor=(value)
      raise CursorBeforeBeginningOfFileError if value.negative?
      raise CursorAfterEndOfFileError if value > cursor_max

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

    def next_cell!
      self.current_cell += 1
    end

    def prev_cell!
      self.current_cell -= 1
    end

    def increment_cell!
      self.current_cell_value += 1
    end

    def decrement_cell!
      self.current_cell_value -= 1
    end

    def cursor_to_next_instruction!
      self.cursor += 1
    end

    def cursor_to_closing_bracket!
      goto_matching_bracket_to_the :right
    end

    def cursor_to_opening_bracket!
      goto_matching_bracket_to_the :left
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
    def goto_matching_bracket_to_the(direction)
      cursor_modifier = { right: 1, left: -1 }[direction]
      initial_cursor = cursor
      nesting = 0

      loop do
        case current_instruction
        when "[" then nesting += 1
        when "]" then nesting -= 1
        end

        break if nesting.zero?

        begin
          self.cursor += cursor_modifier
        rescue CursorOutOfBoundsError
          raise_bracket_error_at initial_cursor
        end
      end
    end

    def raise_bracket_error_at(cursor_position)
      error_class = case code[cursor_position]
      when "[" then UnmatchedOpenBracketError
      when "]" then UnmatchedClosingBracketError
      # Shouldn't happen; this method should only ever be called when the cursor
      # position is at a bracket
      else raise InternalError, "Uh, that's not a bracket..."
      end

      interpreted_code = code.slice(0, cursor_position + 1)
      line = interpreted_code.count("\n") + 1
      interpreted_line = interpreted_code.slice(/[^\n]*\z/)
      column = interpreted_line.length

      # raise snippet_at(cursor_position)
      # raise error_class, snippet_at(cursor_position), line: line, column: column
      # raise error_class, line: line, column: column
      raise error_class, line: line, column: column, snippet: snippet_at(cursor_position)
    end

    def line_count_at(cursor_position)
      code.slice(0, cursor_position + 1).count("\n") + 1
    end

    def column_at(cursor_position)
      code.slice(0, cursor_position + 1).slice(/[^\n]*\z/).length
    end

    def snippet_at(cursor_position, context: 10)
      center = cursor_position + 1
      left = [center - context, 0].max
      right = context * 2
      snippet = "(...) #{code.slice(left, right)} (...)"
      pointer = "     #{' ' * context}^"
      "#{snippet}\n#{pointer}"
    end
  end
end
