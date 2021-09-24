require 'simplecov_linter_formatter/version'
require 'simplecov_linter_formatter/formatters/result_formatter'
require 'simplecov_linter_formatter/formatters/source_file_formatter'
require 'simplecov_linter_formatter/formatters/text_lines_formatter'
require 'simplecov_linter_formatter/exporters/text_result_exporter'
require 'simplecov_linter_formatter/exporters/json_result_exporter'
require 'simplecov_linter_formatter/text_lines_filter'

module SimpleCovLinterFormatter
  SCOPES = [:all, :own_changes]

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

  def self.cover_all?
    scope == :all
  end

  def self.scope=(value)
    if !SCOPES.include?(value)
      raise "Invalid scope. Must be one of: #{SCOPES.map(&:to_s).join(", ")}"
    end

    @scope = value
  end

  def self.scope
    @scope || :all
  end
end

module SimpleCov
  module Formatter
    class LinterFormatter
      def format(simplecov_result)
        text_lines = get_text_lines(simplecov_result)
        hash_result = format_text_lines(simplecov_result.command_name, text_lines)
        export_to_json(hash_result)
        nil
      end

      private

      def get_text_lines(simplecov_result)
        text_lines = format_result(simplecov_result)
        return text_lines if SimpleCovLinterFormatter.cover_all?

        export_text_lines(text_lines)
        filter_text_lines
      end

      def export_text_lines(text_lines)
        SimpleCovLinterFormatter::TextResultExporter.new(text_lines).export
      end

      def filter_text_lines
        SimpleCovLinterFormatter::TextLinesFilter.new.filter
      end

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
