shared_examples_for "Voting" do
  describe "voting" do
    it {should have_many(:votes).dependent(:destroy)}


    let(:user) {create(:user)}

    describe "#vote_up" do
      before do
        subject.vote_up(user)
      end

      it 'creates positive vote' do
        expect(subject.votes.last.value).to eq 1
      end

      it 'creates vote for user' do
        expect(subject.votes.last.user).to eq user
      end
    end

    describe "#vote_down" do
      before do
        subject.vote_down(user)
      end

      it 'creates negative vote' do
        expect(subject.votes.last.value).to eq -1
      end

      it 'creates vote for user' do
        expect(subject.votes.last.user).to eq user
      end
    end

    describe "#cancel_vote" do


      before do
        Vote.create(votable:subject, user: create(:user))
        Vote.create(votable:subject, user: user)
        Vote.create(votable:subject, user: create(:user))

      end

      it 'removes a vote' do
        expect{subject.cancel_vote(user)}.to change(subject.votes, :count).by(-1)
      end

      context "removes correct user vote" do
        before do
          subject.cancel_vote(user)
          subject.reload
        end

        (0..1).each do |i|
          it "remaining vote #{i} not owned by user" do
            expect(subject.votes[i].user_id).to_not eq user.id
          end
        end
      end
    end




    describe "#votes_sum" do
      let(:user) {create(:user)}

      it 'returns votes sum' do
        5.times {subject.votes.create(user:user, value: 1)}
        3.times {subject.votes.create(user:user, value: -1)}
        expect(subject.votes_sum).to eq 2
      end
    end
  end
end

shared_examples_for "Votable Controller" do
  before do
    login(other_user)
    allow(votable.class).to receive(:find) {votable}
  end


  describe "POST /vote_up" do
    it 'calls vote_up method' do
      expect(votable).to receive(:vote_up).with(other_user)
      post :vote_up, id: votable, format: :json
    end
  end

  describe "POST /vote_down" do
    it 'calls vote_down method' do
      expect(votable).to receive(:vote_down).with(other_user)
      post :vote_down, id: votable, format: :json
    end
  end


  describe "DELETE /cancel_vote" do
    it 'calls Question#votes_sum method' do
      post :vote_up, id: votable, format: :json
      expect(votable).to receive(:cancel_vote).with(other_user)
      delete :cancel_vote, id: votable
    end
  end
end

shared_examples_for "Voting Rules" do
  it {should be_able_to :vote_up, not_own_question}
  it {should be_able_to :vote_down, not_own_question}
  it {should be_able_to :vote_up, not_own_answer}
  it {should be_able_to :vote_down, not_own_answer}
  it {should_not be_able_to :vote_up, own_question}
  it {should_not be_able_to :vote_down, own_question}
  it {should_not be_able_to :vote_up, own_answer}
  it {should_not be_able_to :vote_down, own_answer}


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