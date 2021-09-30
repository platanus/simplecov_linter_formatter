require "spec_helper"

describe SimpleCovLinterFormatter::SummaryBuilder do
  let(:lines) do
    %w{
      file-d.rb:20:1:covered-5-100.0
      file-b.rb:1:1:covered-4-100.0
      file-b.rb:2:1:covered-4-100.0
      file-b.rb:4:1:covered-4-100.0
      file-a.rb:1:1:missed-2-50.0
      file-a.rb:2:1:covered-2-50.0
      file-c.rb:20:1:missed-4-0.0
    }
  end

  let(:expected_summary) do
    <<~SUMMARY.chomp
      SimpleCov Report - Total Coverage:
      ---------------
      \e[31m  0 %\e[0m \e[37m\e[0m\e[37mfile-c.rb\e[0m
      \e[33m 50 %\e[0m \e[37mfile\e[0m\e[37m-a.rb\e[0m
      \e[32m100 %\e[0m \e[37mfile-b.rb\e[0m\e[37m\e[0m
      \e[32m100 %\e[0m \e[37mfile-d.rb\e[0m\e[37m\e[0m
      ---------------
    SUMMARY
  end

  def result
    summary = described_class.new(lines).build
    puts summary
    summary
  end

  it { expect(result).to eq(expected_summary) }

  context "with no lines" do
    let(:lines) do
      []
    end

    it { expect(result).to eq("") }
  end

  context "with alphabet sorting" do
    let(:expected_summary) do
      <<~SUMMARY.chomp
        SimpleCov Report - Total Coverage:
        ---------------
        \e[33m 50 %\e[0m \e[37mfile\e[0m\e[37m-a.rb\e[0m
        \e[32m100 %\e[0m \e[37mfile-b.rb\e[0m\e[37m\e[0m
        \e[31m  0 %\e[0m \e[37m\e[0m\e[37mfile-c.rb\e[0m
        \e[32m100 %\e[0m \e[37mfile-d.rb\e[0m\e[37m\e[0m
        ---------------
      SUMMARY
    end

    before do
      allow(SimpleCovLinterFormatter).to receive(:summary_files_sorting)
        .and_return(:alphabet)
    end

    it { expect(result).to eq(expected_summary) }
  end

  context "with own changes scope" do
    let(:expected_summary) do
      <<~SUMMARY.chomp
        SimpleCov Report - Own Changes:
        ---------------
        \e[31m  0 %\e[0m \e[37m\e[0m\e[37mfile-c.rb\e[0m
        \e[33m 50 %\e[0m \e[37mfile\e[0m\e[37m-a.rb\e[0m
        \e[32m100 %\e[0m \e[37mfile-b.rb\e[0m\e[37m\e[0m
        \e[32m100 %\e[0m \e[37mfile-d.rb\e[0m\e[37m\e[0m
        ---------------
      SUMMARY
    end

    before do
      allow(SimpleCovLinterFormatter).to receive(:scope)
        .and_return(:own_changes)
    end

    it { expect(result).to eq(expected_summary) }
  end

  context "with different text color" do
    let(:expected_summary) do
      <<~SUMMARY.chomp
        SimpleCov Report - Total Coverage:
        ---------------
        \e[31m  0 %\e[0m \e[35m\e[0m\e[35mfile-c.rb\e[0m
        \e[33m 50 %\e[0m \e[35mfile\e[0m\e[35m-a.rb\e[0m
        \e[32m100 %\e[0m \e[35mfile-b.rb\e[0m\e[35m\e[0m
        \e[32m100 %\e[0m \e[35mfile-d.rb\e[0m\e[35m\e[0m
        ---------------
      SUMMARY
    end

    before do
      allow(SimpleCovLinterFormatter).to receive(:summary_text_color)
        .and_return(:magenta)
    end

    it { expect(result).to eq(expected_summary) }
  end

  context "with enabled bg color" do
    let(:expected_summary) do
      <<~SUMMARY.chomp
        SimpleCov Report - Total Coverage:
        ---------------
        \e[31m  0 %\e[0m \e[37m\e[0m\e[48;5;28m\e[0m\e[37m\e[48;5;160mfile-c.rb\e[0m
        \e[33m 50 %\e[0m \e[37m\e[48;5;28mfile\e[0m\e[37m\e[48;5;160m-a.rb\e[0m
        \e[32m100 %\e[0m \e[37m\e[48;5;28mfile-b.rb\e[0m\e[37m\e[0m\e[48;5;160m\e[0m
        \e[32m100 %\e[0m \e[37m\e[48;5;28mfile-d.rb\e[0m\e[37m\e[0m\e[48;5;160m\e[0m
        ---------------
      SUMMARY
    end

    before do
      allow(SimpleCovLinterFormatter).to receive(:summary_enabled_bg)
        .and_return(true)
    end

    it { expect(result).to eq(expected_summary) }

    context "with different bg colors" do
      let(:expected_summary) do
        <<~SUMMARY.chomp
          SimpleCov Report - Total Coverage:
          ---------------
          \e[31m  0 %\e[0m \e[37m\e[0m\e[44m\e[0m\e[37m\e[48;5;201mfile-c.rb\e[0m
          \e[33m 50 %\e[0m \e[37m\e[44mfile\e[0m\e[37m\e[48;5;201m-a.rb\e[0m
          \e[32m100 %\e[0m \e[37m\e[44mfile-b.rb\e[0m\e[37m\e[0m\e[48;5;201m\e[0m
          \e[32m100 %\e[0m \e[37m\e[44mfile-d.rb\e[0m\e[37m\e[0m\e[48;5;201m\e[0m
          ---------------
        SUMMARY
      end

      before do
        allow(SimpleCovLinterFormatter).to receive(:summary_not_covered_bg_color)
          .and_return(:fuchsia)
        allow(SimpleCovLinterFormatter).to receive(:summary_covered_bg_color)
          .and_return(:blue)
      end

      it { expect(result).to eq(expected_summary) }
    end
  end
end
