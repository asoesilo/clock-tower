require 'spec_helper'

describe Task do
  it "has a valid factory" do
    expect(build(:task)).to be_valid
  end
end
