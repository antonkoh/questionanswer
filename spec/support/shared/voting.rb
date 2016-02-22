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
      it 'returns votes sum' do
        5.times {subject.votes.create(user:user, value: 1)}
        3.times {subject.votes.create(user:user, value: -1)}
        expect(subject.votes_sum).to eq 2
      end
    end
  end
end