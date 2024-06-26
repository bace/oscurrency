require File.dirname(__FILE__) + '/../spec_helper'

describe Topic do

  before(:each) do
    @person = people(:quentin)
    @topic = forums(:one).topics.build(:name => "A topic")
    @topic.person = @person
  end

  it "should be valid" do
    expect(@topic).to be_valid
  end

  it "should require a name" do
    topic = Topic.new
    expect(topic).to_not be_valid
    expect(topic.errors[:name]).to_not be_empty
  end

  it "should have many posts" do
    expect(@topic.posts.load.to_a).to be_a_kind_of(Array)
  end

  it "should belong to a person" do
    quentin = people(:quentin)
    topic = Topic.new
    topic.person = quentin
    expect(topic.person).to eq(quentin)
  end

  describe "associations" do

    before(:each) do
      @topic.save!
    end

    it "should have an activity" do
      expect(Activity.find_by(item_id: @topic.id)).to_not be_nil
    end
  end
end
