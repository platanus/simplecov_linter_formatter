module SimpleCovLinterFormatter
  class TextLinesConverter
    def initialize(lines)
      @lines = lines
    end

    def convert
      {
        RSpec: {
          coverage: group_lines_by_file
        }
      }
    end

    def group_lines_by_file
      result = {}

      @lines.each do |line|
        file_name, line_number, column, status_lines_count = line.split(":")
        status, lines_count = status_lines_count.split("-")
        result[file_name] ||= { lines: [nil] * lines_count.to_i }
        result[file_name][:lines][line_number.to_i - 1] = status.to_sym == :missed ? 0 : nil
      end

      result
    end
  end
end
