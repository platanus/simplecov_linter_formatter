module SimpleCovLinterFormatter
  class TextResultExporter
    def initialize(list)
      @result = list
    end

    def export
      File.open(export_path, 'w') do |file|
        file << @result.join("\n")
      end
    end

    private

    def export_path
      File.join(SimpleCov.coverage_path, SimpleCovLinterFormatter::FILENAME)
    end
  end
end
