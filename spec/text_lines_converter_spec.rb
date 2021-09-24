require "spec_helper"

describe SimpleCovLinterFormatter::TextLinesConverter do
  let(:lines) do
    [
      "file1.rb:1:1:missed-2",
      "file1.rb:2:1:never-2",
      "file2.rb:1:1:missed-4",
      "file2.rb:2:1:covered-4",
      "file2.rb:4:1:missed-4",
    ]
  end

  def result
    described_class.new(lines).convert[:RSpec][:coverage]
  end

  it { expect(result).to be_a(Hash) }
  it { expect(result.keys.count).to eq(2) }

  it { expect(result["file1.rb"]).to be_a(Hash) }
  it { expect(result["file1.rb"][:lines]).to eq([0, nil]) }

  it { expect(result["file2.rb"]).to be_a(Hash) }
  it { expect(result["file2.rb"][:lines]).to eq([0, nil, nil, 0]) }
end