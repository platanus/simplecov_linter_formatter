module SimpleCovLinterFormatter
  class SourceFileFormatter
    FILE_COLUMN = 1

    def initialize(source_file)
      @source_file = source_file
    end

    def format
      lines.map do |line|
        build_line_text(line)
      end
    end

    private

    def build_line_text(line)
      [
        @source_file.filename,
        line.line_number,
        FILE_COLUMN,
        build_line_msg(line)
      ].map(&:to_s).join(SimpleCovLinterFormatter::LINE_SECTIONS_DIVIDER)
    end

    def build_line_msg(line)
      [
        line.status,
        lines_count,
        stats.percent
      ].map(&:to_s).join(SimpleCovLinterFormatter::MSG_DIVIDER)
    end

    def stats
      @stats ||= @source_file.coverage_statistics[:line]
    end

    def lines_count
      @lines_count ||= lines.count
    end

    def lines
      @lines ||= @source_file.lines
    end
  end
end
