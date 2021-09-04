# frozen_string_literal: true

module BrainfuckRuby
  class Error < StandardError; end

  # Internal interpreter error
  class InternalError < BrainfuckRuby::Error
    def initialize(message = "Something went wrong")
      super(message)
    end
  end

  # Cursor is negative or past the end of the file
  class CursorOutOfBoundsError < BrainfuckRuby::Error
    def initialize(message = "Cursor position out of bounds")
      super(message)
    end
  end

  # Cursor is negative
  class CursorBeforeBeginningOfFileError < BrainfuckRuby::CursorOutOfBoundsError
    def initialize(message = "Cursor position cannot go below zero")
      super(message)
    end
  end

  # Cursor is past the end of the file
  class CursorAfterEndOfFileError < BrainfuckRuby::CursorOutOfBoundsError
    def initialize(message = "Cursor position cannot go past the end of the program")
      super(message)
    end
  end

  # Syntax error in the brainfuck code
  class SyntaxError < BrainfuckRuby::Error
    def initialize(message = "Invalid brainfuck syntax")
      super(message)
    end
  end

  # A bracket doesn't have a corresponding bracket to close the group
  class UnmatchedBracketError < BrainfuckRuby::SyntaxError
    def initialize(message = "Bracket has no partner", line: nil, column: nil, snippet: nil)
      position = "(line: #{line || 'unknown'}, column: #{column || 'unknown'})"
      snippet_lines = snippet && "\n#{snippet}"
      super("#{message} #{position}#{snippet_lines}")
    end
  end

  # Open bracket without a matching closing bracket
  class UnmatchedOpenBracketError < BrainfuckRuby::UnmatchedBracketError
    def initialize(message = "Opening bracket has no corresponding closing bracket", line: nil, column: nil, snippet: nil)
      super(message, line: line, column: column, snippet: snippet)
    end
  end

  # Close bracket without a matching opening bracket
  class UnmatchedClosingBracketError < BrainfuckRuby::UnmatchedBracketError
    def initialize(message = "Closing bracket has no corresponding opening bracket", line: nil, column: nil, snippet: nil)
      super(message, line: line, column: column, snippet: snippet)
    end
  end
end
