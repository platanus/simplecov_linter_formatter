require "spec_helper"

describe SimpleCovLinterFormatter::ResultFormatter do
  let(:file1) { double }
  let(:file1_formatter_response) do
    [
      1
    ]
  end

  let(:file1_formatter) do
    instance_double(
      "SimpleCovLinterFormatter::SourceFileTextFormatter",
      format: file1_formatter_response
    )
  end

  let(:file2) { double }
  let(:file2_formatter_response) do
    [
      2
    ]
  end

  let(:file2_formatter) do
    instance_double(
      "SimpleCovLinterFormatter::SourceFileTextFormatter",
      format: file2_formatter_response
    )
  end

  let(:files) { [file1, file2] }

  let(:result) do
    double(
      files: files
    )
  end

  def format
    described_class.new(result).format
  end

  before do
    allow(SimpleCovLinterFormatter::SourceFileTextFormatter).to receive(:new)
      .and_return(file1_formatter, file2_formatter)
  end

  it { expect(format).to eq([1, 2]) }

  context "with nil file formatter result" do
    let(:file1_formatter_response) do
      nil
    end

    it { expect(format).to eq([2]) }
  end
end
