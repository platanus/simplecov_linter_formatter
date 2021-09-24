require "spec_helper"

describe SimpleCov::Formatter::LinterFormatter do
  let(:command_name) { "RSpec" }
  let(:simplecov_result) { double(command_name: command_name) }
  let(:text_lines) { double }
  let(:filtered_text_lines) { double }
  let(:hash_result) { double }

  let(:result_formatter) { double(format: text_lines) }
  let(:text_lines_formatter) { double(format: hash_result) }
  let(:json_result_exporter) { double(export: true) }
  let(:text_lines_filter) { double(filter: filtered_text_lines) }

  def format
    described_class.new.format(simplecov_result)
  end

  before do
    allow(SimpleCovLinterFormatter::ResultFormatter)
      .to receive(:new).and_return(result_formatter)

    allow(SimpleCovLinterFormatter::TextLinesFormatter)
      .to receive(:new).and_return(text_lines_formatter)

    allow(SimpleCovLinterFormatter::JsonResultExporter)
      .to receive(:new).and_return(json_result_exporter)

    allow(SimpleCovLinterFormatter::TextLinesFilter)
      .to receive(:new).and_return(text_lines_filter)
  end

  it { expect(format).to eq(nil) }

  it do
    format

    expect(SimpleCovLinterFormatter::ResultFormatter).to have_received(:new)
      .with(simplecov_result).once

    expect(SimpleCovLinterFormatter::TextLinesFormatter).to have_received(:new)
      .with(command_name, text_lines).once

    expect(SimpleCovLinterFormatter::JsonResultExporter).to have_received(:new)
      .with(hash_result).once

    expect(SimpleCovLinterFormatter::TextLinesFilter).not_to have_received(:new)
  end

  it do
    format
    expect(result_formatter).to have_received(:format).with(no_args).once
    expect(text_lines_formatter).to have_received(:format).with(no_args).once
    expect(json_result_exporter).to have_received(:export).with(no_args).once
    expect(text_lines_filter).not_to have_received(:filter)
  end

  context "with :own_changes scope" do
    before do
      SimpleCovLinterFormatter.scope = :own_changes
    end

    it do
      format

      expect(SimpleCovLinterFormatter::ResultFormatter).to have_received(:new)
        .with(simplecov_result).once

      expect(SimpleCovLinterFormatter::TextLinesFilter).to have_received(:new)
        .with(text_lines).once

      expect(SimpleCovLinterFormatter::TextLinesFormatter).to have_received(:new)
        .with(command_name, filtered_text_lines).once

      expect(SimpleCovLinterFormatter::JsonResultExporter).to have_received(:new)
        .with(hash_result).once
    end

    it do
      format
      expect(result_formatter).to have_received(:format).with(no_args).once
      expect(text_lines_formatter).to have_received(:format).with(no_args).once
      expect(json_result_exporter).to have_received(:export).with(no_args).once
      expect(text_lines_filter).to have_received(:filter).with(no_args).once
    end
  end
end
