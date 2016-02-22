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

    it {should be_able_to :votes_sum, Question}
    it {should be_able_to :votes_sum, Answer}

    it {should_not be_able_to :vote_up, Question}
    it {should_not be_able_to :vote_up, Answer}
    it {should_not be_able_to :vote_down, Question}
    it {should_not be_able_to :vote_down, Answer}


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

    it {should be_able_to :vote_up, not_own_question}
    it {should be_able_to :vote_down, not_own_question}
    it {should be_able_to :vote_up, not_own_answer}
    it {should be_able_to :vote_down, not_own_answer}
    it {should_not be_able_to :vote_up, own_question}
    it {should_not be_able_to :vote_down, own_question}
    it {should_not be_able_to :vote_up, own_answer}
    it {should_not be_able_to :vote_down, own_answer}
    it {should be_able_to :votes_sum, Question}
    it {should be_able_to :votes_sum, Answer}

    it {should_not be_able_to :cancel_vote, own_question}
    it {should_not be_able_to :cancel_vote, own_answer}

    describe "existing vote" do
      let!(:vote_q) {Vote.create(votable: not_own_question, user: user)}
      let!(:vote_a) {Vote.create(votable: not_own_answer, user: user)}

      it {should_not be_able_to :vote_up, not_own_question}
      it {should_not be_able_to :vote_down, not_own_question}
      it {should_not be_able_to :vote_up, not_own_answer}
      it {should_not be_able_to :vote_down, not_own_answer}
    end

    describe "destroy vote" do
      let!(:vote_q) {Vote.create(votable: not_own_question, user: user)}
      let!(:vote_a) {Vote.create(votable: not_own_answer, user: user)}

      it {should be_able_to :cancel_vote, not_own_question}
      it {should be_able_to :cancel_vote, not_own_answer}

    end



  end

end