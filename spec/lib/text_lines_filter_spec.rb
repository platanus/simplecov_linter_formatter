require "spec_helper"

describe SimpleCovLinterFormatter::TextLinesFilter do
  let(:lines) do
    %w{
      line1
      line2
    }
  end

  let(:filtered_lines) { "filtered_line1\nfiltered_line2" }

  let(:expected_result) do
    %w{
      filtered_line1
      filtered_line2
    }
  end

  before do
    allow_any_instance_of(described_class).to receive(:`).and_return(filtered_lines)
  end

  def filter
    described_class.new(lines).filter
  end

  it { expect(filter).to eq(expected_result) }

  it do
    expect_any_instance_of(described_class).to receive(:`)
      .with("echo \"line1\\nline2\" | reviewdog -efm=\"%f:%l:%c:%m\" -diff=\"git diff\"")
      .once

    filter
  end

  context "with no lines" do
    let(:lines) { [] }
    let(:expected_result) { [] }

    it { expect(filter).to eq(expected_result) }
  end
end
