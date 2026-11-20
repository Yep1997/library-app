require "rails_helper"

RSpec.describe "Database seeds" do
  def run_seeds = load Rails.root.join("db/seeds.rb")

  it "creates sample readers" do
    expect { run_seeds }.to change(Reader, :count).from(0)
  end

  it "can be run repeatedly without creating duplicates" do
    run_seeds

    expect { run_seeds }.not_to change(Reader, :count)
  end
end
