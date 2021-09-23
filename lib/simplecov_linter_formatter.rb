require "simplecov_linter_formatter/version"
require 'simplecov_linter_formatter/source_file_text_formatter'
require 'simplecov_linter_formatter/text_result_exporter'

module SimpleCovLinterFormatter
  FILENAME = 'coverage.linter.txt'

  class Error < StandardError; end
end
