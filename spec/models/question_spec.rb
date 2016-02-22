require 'rails_helper'

RSpec.describe Question, type: :model do

  it {should have_many(:answers).dependent(:destroy)}
  it {should belong_to(:user)}
  it {should have_many(:attachments).dependent(:destroy)}
  it {should have_many(:comments).dependent(:destroy)}

  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_most(200)}
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }

  it {should accept_nested_attributes_for :attachments}

  it_behaves_like "Voting" do
    subject {create(:question)}
  end

end
