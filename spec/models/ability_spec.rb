require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject {Ability.new(user)}

  describe "guest" do
    let(:user) {nil}

    it {should be_able_to :read, Question}
    it {should_not be_able_to :create, Question}
    it {should_not be_able_to :update, Question}
    it {should_not be_able_to :destroy, Question}


    it {should_not be_able_to :create, Answer}
    it {should_not be_able_to :update, Answer}
    it {should_not be_able_to :destroy, Answer}

    it {should_not be_able_to :create, Comment}

    # it {should be_able_to :read, Attachment}
    # it {should_not be_able_to :create, Attachment}
    # it {should_not be_able_to :update, Attachment}
    # it {should_not be_able_to :destroy, Attachment}
  end

  describe "admin" do
    let(:user) {create(:user, admin: true)}

    it {should be_able_to :manage, :all}
  end

  describe "non-admin" do
    let(:user) {create(:user, admin: false)}
    let!(:own_question) {create(:question, user:user)}
    let!(:not_own_question) {create(:question, user: create(:user))}
    let!(:own_answer) {create(:answer, question:not_own_question, user:user)}
    let!(:not_own_answer) {create(:answer, question:own_question,user: create(:user))}

    it {should be_able_to :read, Question}
    it {should be_able_to :create, Question}
    it {should be_able_to :update, own_question}
    it {should be_able_to :destroy, own_question}
    it {should_not be_able_to :update, not_own_question}
    it {should_not be_able_to :destroy, not_own_question}

    it {should be_able_to :create, Answer}
    it {should be_able_to :update, own_answer}
    it {should be_able_to :destroy, own_answer}
    it {should_not be_able_to :update, not_own_answer}
    it {should_not be_able_to :destroy, not_own_answer}

    it {should be_able_to :create, Comment}

    #it {should be_able_to :read, Attachment}
    #it {should_not be_able_to :destroy, Attachment}
  end

end