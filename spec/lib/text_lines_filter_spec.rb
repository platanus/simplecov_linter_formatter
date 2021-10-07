require "spec_helper"

describe SimpleCovLinterFormatter::TextLinesFilter do
  let(:lines) do
    %w{
      Gemfile
      Gemfile.lock
      app/controllers/home_controller.rb
      app/models/organization.rb
      app/models/team_member.rb
      app/models/team_responsibility.rb
      app/models/user.rb
      config/sidekiq.yml
      spec/models/organization_spec.rb
      spec/models/team_member_spec.rb
      spec/models/user_spec.rb
      spec/rails_helper.rb
      spec/simplecov_config.rb
      app/jobs/my_job.rb
      spec/jobs/
    }
  end

  let(:diff_result) do
    <<~DOC
      M Gemfile
      M Gemfile.lock
      D app/controllers/home_controller.rb
      M app/models/user.rb
      M config/sidekiq.yml
      M spec/models/user_spec.rb
      M spec/rails_helper.rb
      ?? app/jobs/my_job.rb
      ?? spec/jobs/
    DOC
  end

  let(:expected_result) do
    %w{
      Gemfile
      Gemfile.lock
      app/controllers/home_controller.rb
      app/models/user.rb
      config/sidekiq.yml
      spec/models/user_spec.rb
      spec/rails_helper.rb
      app/jobs/my_job.rb
    }
  end

  before do
    allow_any_instance_of(described_class).to receive(:`).and_return(diff_result)
  end

  def filter
    described_class.new(lines).filter
  end

  it { expect(filter).to eq(expected_result) }

  it do
    expect_any_instance_of(described_class).to receive(:`)
      .with("git status --porcelain")
      .once

    filter
  end

  context "with no lines" do
    let(:lines) { [] }
    let(:expected_result) { [] }

    it { expect(filter).to eq(expected_result) }
  end
end
