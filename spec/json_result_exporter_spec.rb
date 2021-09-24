require "spec_helper"

describe SimpleCovLinterFormatter::JsonResultExporter do
  let(:coverage_file_path) { "./tmp/coverage.linter.json" }
  let(:result_hash) do
    {
      odio: "la casa de papel"
    }
  end

  def file_content
    described_class.new(result_hash).export
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

  it { expect(file_content).to eq("{\n  \"odio\": \"la casa de papel\"\n}") }
end
