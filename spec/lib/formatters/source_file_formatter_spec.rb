require "spec_helper"

describe SimpleCovLinterFormatter::SourceFileFormatter do
  let(:line1) do
    instance_double(
      "SimpleCov::SourceFile::Line",
      status: "covered",
      line_number: 1
    )
  end

  let(:line2) do
    instance_double(
      "SimpleCov::SourceFile::Line",
      status: "never",
      line_number: 2
    )
  end

  let(:line3) do
    instance_double(
      "SimpleCov::SourceFile::Line",
      status: "missed",
      line_number: 5
    )
  end

  let(:lines) do
    [
      line1,
      line2,
      line3
    ]
  end

  let(:source_file) do
    instance_double(
      "SimpleCov::SourceFile",
      filename: "file.rb",
      lines: lines
    )
  end

  def format
    described_class.new(source_file).format
  end

  let(:expected_lines) do
    [
      "file.rb:1:1:covered-3",
      "file.rb:2:1:never-3",
      "file.rb:5:1:missed-3"
    ]
  end

  it { expect(format).to eq(expected_lines) }
end
