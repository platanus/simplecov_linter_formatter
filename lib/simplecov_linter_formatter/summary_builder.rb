module SimpleCovLinterFormatter
  class SummaryBuilder
    PERCENT_TEXT_SIZE = 3

    def initialize(lines)
      @lines = lines
      @largest_file_name = 0
      @largest_percentage = 0
    end

    def build
      body = build_body
      return body if body == ""

      "#{build_title}\n#{body}#{divider}"
    end

    private

    def build_title
      "SimpleCov Report - #{build_coverage_title}:\n#{divider}"
    end

    def divider
      '-' * report_width
    end

    def report_width
      @largest_file_name + @largest_percentage + PERCENT_TEXT_SIZE
    end

    def build_coverage_title
      if SimpleCovLinterFormatter.cover_all?
        return "Total Coverage"
      end

      "Own Changes"
    end

    def build_body
      result = ""

      files.each do |file|
        result += "#{build_line_output(file)}\n"
      end

      result
    end

    def files
      unique_files = []
      added_files = {}

      @lines.each do |line|
        file = SimpleCovLinterFormatter::FileLine.new(line)
        next if added_files[file.file_short_name]

        unique_files << file
        added_files[file.file_short_name] = true
        file_size = file.file_short_name.size
        file_percentage = file.file_int_percentage.to_s.size
        @largest_file_name = file_size if file_size > @largest_file_name
        @largest_percentage = file_percentage if file_percentage > @largest_percentage
      end

      sort_files(unique_files)
    end

    def sort_files(files)
      sorting_strategy = if SimpleCovLinterFormatter.summary_coverage_sorting?
                           Proc.new { |file| [file.percentage, file.file_short_name] }
                         else
                           Proc.new { |file| file.file_short_name }
                         end
      files.sort_by { |file| sorting_strategy.call(file) }
    end

    def build_line_output(file)
      file_name = adjusted_file_name(file)
      covered_size = @largest_file_name * file.percentage / 100.0
      covered_text = colorize_text(
        covered_size.zero? ? "" : file_name[0..(covered_size - 1)],
        :summary_covered_bg_color
      )
      not_covered_text = colorize_text(
        file_name[covered_size..-1],
        :summary_not_covered_bg_color
      )
      "#{build_percentage_output(file)} #{covered_text}#{not_covered_text}"
    end

    def colorize_text(text, bg_option)
      text = Rainbow(text).color(SimpleCovLinterFormatter.summary_text_color)
      return text unless SimpleCovLinterFormatter.summary_enabled_bg

      text.bg(SimpleCovLinterFormatter.send(bg_option))
    end

    def build_percentage_output(file)
      percentage_size = file.file_int_percentage.to_s.size
      diff = @largest_percentage - percentage_size
      Rainbow("#{' ' * diff}#{file.file_int_percentage} %").send(
        get_percetage_color(file.file_int_percentage)
      )
    end

    def get_percetage_color(percentage)
      case percentage
      when 100
        :green
      when 0
        :red
      else
        :yellow
      end
    end

    def adjusted_file_name(file)
      diff = @largest_file_name - file.file_short_name.size
      file.file_short_name + (" " * diff)
    end

    def covered_size(file)
      @largest_file_name * file.percentage / 100.0
    end
  end
end
