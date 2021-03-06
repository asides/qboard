require 'rails_helper'

describe QuestionSchema do
  let(:result) { subject.call(attributes) }

  context "title is specified" do
    let(:attributes) { { title: "Test Project", body: "Body Test Project" } }

    it "is valid" do
      expect(result).to be_success
    end
  end

  context "title is not specified" do
    let(:attributes) { { } }

    it "is invalid" do
      expect(result).to be_failure
      expect(result.errors[:body]).to eq(["is missing"])
    end
  end
end