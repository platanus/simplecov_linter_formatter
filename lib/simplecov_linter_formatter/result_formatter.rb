module SimpleCovLinterFormatter
  class ResultFormatter
    def initialize(result)
      @result = result
    end

    def format
      formatted_result = []

      @result.files.each do |source_file|
        messages = format_source_file(source_file)
        formatted_result += messages if messages
      end

      formatted_result
    end

    private

    def format_source_file(source_file)
      source_file_formatter = SourceFileTextFormatter.new(source_file)
      source_file_formatter.format
    end
  end
end
