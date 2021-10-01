module SimpleCovLinterFormatter
  class TextLinesFormatter
    def initialize(command_name, lines)
      @command_name = command_name
      @lines = lines
    end

    def format
      {
        @command_name.to_sym => {
          coverage: group_lines_by_file
        }
      }
    end

    private

    def group_lines_by_file
      result = {}

      @lines.each do |line|
        file = SimpleCovLinterFormatter::FileLine.new(line)
        result[file.file_name] ||= { lines: [nil] * file.lines_count }
        result[file.file_name][:lines][file.line_number_idx] = file.status == :missed ? 0 : nil
      end

      result
    end
  end
end
