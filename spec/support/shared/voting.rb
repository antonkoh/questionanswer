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
      post :vote_up, id: votable
    end
  end

  describe "POST /vote_down" do
    it 'calls vote_down method' do
      expect(votable).to receive(:vote_down).with(other_user)
      post :vote_down, id: votable
    end
  end


  describe "DELETE /cancel_vote" do
    it 'calls Question#votes_sum method' do
      post :vote_up, id: votable
      expect(votable).to receive(:cancel_vote).with(other_user)
      delete :cancel_vote, id: votable
    end
  end
end