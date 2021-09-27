module SimpleCovLinterFormatter
  class SourceFileFormatter
    FILE_COLUMN = 1

    def initialize(source_file)
      @source_file = source_file
    end

    def format
      lines.map do |line|
        build_message(line)
      end
    end

    private

    def build_message(line)
      [
        @source_file.filename,
        line.line_number,
        FILE_COLUMN,
        "#{line.status}-#{lines_count}"
      ].map(&:to_s).join(":")
    end

    def lines_count
      @lines_count ||= lines.count
    end

    def lines
      @lines ||= @source_file.lines
    end
  end
end
