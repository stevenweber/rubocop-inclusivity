# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Inclusivity::Race, :config do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) do
    {
      "Offenses" => {
        "whitelist" => ["allowlist", "passlist", "permitlist"],
        "blacklist" => ["banlist", "blocklist", "denylist"]
      }
    }
  end

  it "checks variable assignments" do
    expect_no_offenses(<<~RUBY)
      banlist = 1
    RUBY

    expect_offense(<<~RUBY)
      blacklist = 1
      ^^^^^^^^^ `blacklist` may be insensitive. Consider alternatives: banlist, blocklist, denylist
    RUBY

    expect_correction(<<~RUBY)
      banlist = 1
    RUBY
  end

  it "checks constant assignments" do
    expect_no_offenses(<<~RUBY)
      BANLIST = ["foo", "bar"]
    RUBY

    expect_offense(<<~RUBY)
      BLACKLIST = ["foo", "bar"]
      ^^^^^^^^^ `BLACKLIST` may be insensitive. Consider alternatives: banlist, blocklist, denylist
    RUBY

    expect_correction(<<~RUBY)
      BANLIST = ["foo", "bar"]
    RUBY
  end
end
