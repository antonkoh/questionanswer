require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it {should have_many(:questions)}
  it {should have_many(:answers)}
  it {should have_many(:authorizations).dependent(:destroy)}

  describe '#can_edit?' do

    let!(:user) {create(:user)}

    it 'returns true if user can edit object' do
      object = create(:question, user: user)
      expect(user).to be_can_edit(object)
    end



    it 'returns false if user cannot edit object' do
      object = create(:question)
      expect(user).to_not be_can_edit(object)
    end


  end

  describe '.find_for_oauth' do
    context "user already has logged in this way" do
      let!(:user) {create(:user)}
      let(:auth_hash) {OmniAuth::AuthHash.new(provider: 'provider', uid: '123')}

      before do
        user.authorizations.create(provider: 'provider', uid: '123')
      end
      it 'returns the user' do
        expect(User.find_for_oauth(auth_hash)).to eq user
      end
    end

    context "no auth yet, user email already exists" do
      let!(:user) {create(:user)}
      let(:auth_hash) {OmniAuth::AuthHash.new(provider: 'provider', uid: '123',
                                              info: {email: user.email})}

      it 'does not create new user' do
        expect{User.find_for_oauth(auth_hash)}.to_not change(User, :count)
      end

      it 'creates an authorization' do
        expect{User.find_for_oauth(auth_hash)}.to change(user.authorizations, :count).by(1)
      end


      context "user is assigned correct authorization info" do
        before do
          User.find_for_oauth(auth_hash)
        end
        it 'connects found user with provider' do
          expect(user.authorizations.first.provider).to eq 'provider'
        end

        it 'connects found user with uid' do
          expect(user.authorizations.first.uid).to eq '123'
        end
      end

      it 'returns the user' do
        expect(User.find_for_oauth(auth_hash)).to eq user
      end
    end

    context "no auth yet, user email does not exist" do
      let(:auth_hash) {OmniAuth::AuthHash.new(provider: 'provider', uid: '123',
                                              info: {email: 'smth@ya.ru'})}

      it 'creates new user' do
        expect{User.find_for_oauth(auth_hash)}.to change(User, :count).by(1)
      end


      context "user is created with correct info" do
        before do
          User.find_for_oauth(auth_hash)
        end


        it 'connects created user with email' do
          expect(User.first.email).to eq 'smth@ya.ru'
        end

        it 'assigns created user with one authorization' do
          expect(User.first.authorizations.count).to eq 1
        end

        it 'connects created user with provider' do
          expect(User.first.authorizations.first.provider).to eq 'provider'
        end

        it 'connects created user with uid' do
          expect(User.first.authorizations.first.uid).to eq '123'
        end
      end

      it 'returns new user' do
        expect(User.find_for_oauth(auth_hash).email).to eq 'smth@ya.ru'
      end

    end


  end
end
