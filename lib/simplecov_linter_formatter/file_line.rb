module SimpleCovLinterFormatter
  class FileLine
    attr_reader :file_name

    def initialize(line)
      @line = line
      assign_attributes
    end

    def status
      @status.to_sym
    end

    def line_number
      @line_number.to_i
    end

    def line_number_idx
      line_number - 1
    end

    def column
      @column.to_i
    end

    def lines_count
      @lines_count.to_i
    end

    def percentage
      @percentage.to_f
    end

    def file_short_name
      @file_short_name ||= file_name.gsub(project_path, "")
    end

    def file_int_percentage
      @file_int_percentage ||= percentage.to_i
    end

    private

    def project_path
      root_path = ""
      return root_path unless Object.const_defined?('Rails')
      return root_path unless Rails.respond_to?(:root)

      Rails.root.to_s
    rescue NameError
      ""
    end

    def assign_attributes
      @file_name, @line_number, @column, status_lines_count = @line.split(
        SimpleCovLinterFormatter::LINE_SECTIONS_DIVIDER
      )
      @status, @lines_count, @percentage = status_lines_count.split(
        SimpleCovLinterFormatter::MSG_DIVIDER
      )
    end
  end
end
