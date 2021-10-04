module SimpleCovLinterFormatter
  class TextLinesFilter
    def initialize(text_lines)
      @text_lines = text_lines
    end

    def filter
      return [] if text_content == ""
      return filter_with_reviewdog if reviewdog?

      filter_with_git_status
    end

    private

    def reviewdog?
      silence_stream($stdout) { !!system("reviewdog --version") }
    end

    def filter_with_reviewdog
      `echo "#{text_content}" | reviewdog -efm="#{efm_param}" -diff="git diff"`.to_s.split("\n")
    end

    def efm_param
      %w{%f %l %c %m}.join(SimpleCovLinterFormatter::LINE_SECTIONS_DIVIDER)
    end

    def filter_with_git_status
      status_files = status_to_lines(`git status --porcelain`)
      regexp = /#{status_files.join('|')}/
      @text_lines.grep(regexp)
    end

    def status_to_lines(status)
      status.split("\n").map do |change|
        file = change.split(" ").last
        file.end_with?("/") ? nil : file
      end.compact
    end

    def text_content
      @text_content ||= @text_lines.join("\n")
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
