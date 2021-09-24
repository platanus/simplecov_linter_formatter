require 'simplecov_linter_formatter/version'
require 'simplecov_linter_formatter/formatters/result_formatter'
require 'simplecov_linter_formatter/formatters/source_file_formatter'
require 'simplecov_linter_formatter/formatters/text_lines_formatter'
require 'simplecov_linter_formatter/exporters/text_result_exporter'
require 'simplecov_linter_formatter/exporters/json_result_exporter'

module SimpleCovLinterFormatter
  def self.json_filename=(value)
    @json_filename = value
  end

  def self.json_filename
    @json_filename || 'coverage.linter.json'
  end

  def self.txt_filename=(value)
    @txt_filename = value
  end

  def self.txt_filename
    @txt_filename || 'coverage.linter.txt'
  end
end

module SimpleCov
  module Formatter
    class LinterFormatter
      def format(simplecov_result)
        text_lines = format_result(simplecov_result)
        hash_result = format_text_lines(simplecov_result.command_name, text_lines)
        export_to_json(hash_result)
        nil
      end

      private

      def format_result(simplecov_result)
        SimpleCovLinterFormatter::ResultFormatter.new(simplecov_result).format
      end

      def format_text_lines(command_name, text_lines)
        SimpleCovLinterFormatter::TextLinesFormatter.new(command_name, text_lines).format
      end

      def export_to_json(hash_result)
        SimpleCovLinterFormatter::JsonResultExporter.new(hash_result).export
      end
    end
  end
end
