# frozen_string_literal: true

module BrainfuckRuby
  # Brainlove is just brainfuck with handy macros
  module Brainlove
    # Brainlove transpiles down to brainfuck. Initialize with a string
    # containing some brainlove, and then call `#transpile!` on the instance to
    # transpile that code into brainfuck.
    class Transpiler
      attr_reader :code, :cursor, :cursor_max
      attr_accessor :transpiled, :last_expanded_instruction

      def initialize(brainlove_code)
        @code = brainlove_code
        @cursor_max = code.length - 1
        reset!
      end

      def reset!
        @transpiled = ""
        @cursor = 0
        @last_expanded_instruction = ""
      end

      def transpile!
        reset!

        while cursor <= cursor_max
          handle_instruction!(current_instruction)
          cursor_to_next_instruction!
        end

        # flush_expansion!
        transpiled
      end

      def flush_expansion!
        transpiled << last_expanded_instruction
        self.last_expanded_instruction = ""
      end

      def handle_instruction!(instruction)
        case instruction
        when ">", "<", "+", "-", "[", "]", ".", ","
          # flush_expansion!
          self.last_expanded_instruction = instruction
          self.transpiled += instruction
        when /[0-9]/
          expanded = repeat(last_expanded_instruction, instruction)
          self.last_expanded_instruction += expanded
          self.transpiled += expanded
        end
      end

      def cursor=(value)
        raise CursorBeforeBeginningOfFileError if value.negative?

        @cursor = value
      end

      def current_instruction
        code[cursor]
      end

      def cursor_to_next_instruction!
        self.cursor += 1
      end

      def last_instruction
        transpiled[-1]
      end

      # Repeats according to instruction. Previous instruction (or expansion)
      # will already have been appended to the transpiled code, so it will do
      # n - 1 repeats according to the instruction. Instruction can be 0, 1, 2,
      # 3, 4, 5, 6, 7, 8, or 9. Zero (0) represents a repeat of ten (10), rather
      # than zero, so that will return the string repeated nine (9) times.
      #
      # e.g.,
      #
      #   repeat("hello", "3") #=> "hellohello" (two repeats; three total)
      #   repeat("hi", "5") #=> "hihihihi" (four repeats; five total)
      #   repeat("ha", "0") #=> "hahahahahahahahaha" (nine repeats; ten total)
      #
      def repeat(instruction_to_repeat, repeat_instruction)
        raw_count = repeat_instruction.to_i
        count = raw_count.zero? ? 10 : raw_count
        instruction_to_repeat * (count - 1)
      end

      private

      def blank?(value)
        value.nil? || (value.respond_to?(:empty?) && value.empty?)
      end

      def present?(value)
        !blank?(value)
      end

      def presence(value)
        value if present?(value)
      end
    end
  end
end
