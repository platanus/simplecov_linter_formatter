require 'rainbow'

require 'simplecov_linter_formatter/version'
require 'simplecov_linter_formatter/file_line'
require 'simplecov_linter_formatter/formatters/result_formatter'
require 'simplecov_linter_formatter/formatters/source_file_formatter'
require 'simplecov_linter_formatter/formatters/text_lines_formatter'
require 'simplecov_linter_formatter/exporters/json_result_exporter'
require 'simplecov_linter_formatter/text_lines_filter'
require 'simplecov_linter_formatter/summary_builder'

module SimpleCovLinterFormatter
  extend self

  SCOPES = [:all, :own_changes]
  SORTING_MODES = [:coverage, :alphabet]
  MSG_DIVIDER = "-"
  LINE_SECTIONS_DIVIDER = ":"

  attr_writer(
    :json_filename,
    :summary_covered_bg_color,
    :summary_not_covered_bg_color,
    :summary_text_color,
    :summary_enabled_bg,
    :summary_enabled
  )

  def json_filename
    @json_filename || 'coverage.linter.json'
  end

  def scope=(value)
    if !SCOPES.include?(value.to_sym)
      raise "Invalid scope. Must be one of: #{SCOPES.map(&:to_s).join(', ')}"
    end

    @scope = value
  end

  def scope
    (@scope || :all).to_sym
  end

  def cover_all?
    scope == :all
  end

  def summary_enabled
    !!@summary_enabled
  end

  def summary_files_sorting=(value)
    if !SORTING_MODES.include?(value.to_sym)
      raise "Invalid summary_files_sorting. Must be one of: #{SORTING_MODES.map(&:to_s).join(', ')}"
    end

    @summary_files_sorting = value
  end

  def summary_files_sorting
    (@summary_files_sorting || :coverage).to_sym
  end

  def summary_coverage_sorting?
    summary_files_sorting == :coverage
  end

  def summary_enabled_bg
    !!@summary_enabled_bg
  end

  def summary_covered_bg_color
    (@summary_covered_bg_color || :darkgreen).to_sym
  end

  def summary_not_covered_bg_color
    (@summary_not_covered_bg_color || :firebrick).to_sym
  end

  def summary_text_color
    (@summary_text_color || :white).to_sym
  end

  def setup
    yield self
  end
end

module SimpleCov
  module Formatter
    class LinterFormatter
      def format(simplecov_result)
        text_lines = get_text_lines(simplecov_result)
        show_coverage_summary(text_lines)
        hash_result = format_text_lines(simplecov_result.command_name, text_lines)
        export_to_json(hash_result)
        nil
      end

      private

      def get_text_lines(simplecov_result)
        text_lines = format_result(simplecov_result)
        return text_lines if SimpleCovLinterFormatter.cover_all?

        filter_text_lines(text_lines)
      end

      def show_coverage_summary(text_lines)
        return unless SimpleCovLinterFormatter.summary_enabled

        puts(SimpleCovLinterFormatter::SummaryBuilder.new(text_lines).build)
      end

      def filter_text_lines(text_lines)
        SimpleCovLinterFormatter::TextLinesFilter.new(text_lines).filter
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
