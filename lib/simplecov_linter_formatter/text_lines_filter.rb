module SimpleCovLinterFormatter
  class TextLinesFilter
    def initialize(text_lines)
      @text_lines = text_lines
    end

    def filter
      file_content = filter_result
      format_result(file_content)
    end

    private

    def filter_result
      return "" if text_content == ""

      `echo "#{text_content}" | reviewdog -efm="%f:%l:%c:%m" -diff="git diff"`
    end

    def text_content
      @text_content ||= @text_lines.join('\n')
    end

    def format_result(file_content)
      file_content.to_s.split("\n")
    end
  end
end
