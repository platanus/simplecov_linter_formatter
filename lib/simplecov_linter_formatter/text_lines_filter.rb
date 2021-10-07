module SimpleCovLinterFormatter
  class TextLinesFilter
    def initialize(text_lines)
      @text_lines = text_lines
    end

    def filter
      return [] unless @text_lines.any?

      status_files = status_to_lines(`git status --porcelain`)
      regexp = /#{status_files.join('|')}/
      @text_lines.grep(regexp)
    end

    private

    def status_to_lines(status)
      status.split("\n").map do |change|
        file = change.split(" ").last
        file.end_with?("/") ? nil : file
      end.compact
    end

    def silence_stream(stream)
      old_stream = stream.dup
      stream.reopen(File::NULL)
      stream.sync = true
      yield
    ensure
      stream.reopen(old_stream)
      old_stream.close
    end
  end
end
