require "spec_helper"

describe SimpleCovLinterFormatter::TextResultExporter do
  let(:coverage_file_path) { "./tmp/coverage.linter.txt" }
  let(:lines_list) do
    %w{
      line1
      line2
    }
  end

  def coverage_file_content
    described_class.new(lines_list).export
    File.open(coverage_file_path).read
  end

  def delete_coverage_file
    FileUtils.rm(coverage_file_path)
  rescue Errno::ENOENT
    nil
  end

  before do
    delete_coverage_file
    allow(SimpleCov).to receive(:coverage_path).and_return("./tmp")
  end

  after { delete_coverage_file }

  it { expect(coverage_file_content).to eq("line1\nline2") }

  context "with different file name" do
    let(:coverage_file_path) { "./tmp/custom.txt" }

    before do
      SimpleCovLinterFormatter.txt_filename = "custom.txt"
    end

    it { expect(coverage_file_content).to eq("line1\nline2") }
  end
end
