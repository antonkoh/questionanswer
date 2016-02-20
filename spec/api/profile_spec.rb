require 'rails_helper'

RSpec.describe "Profiles API" do
  describe "GET /me" do

    let(:url) {'/api/v1/profiles/me'}
    it_behaves_like "API Authenticable" do
      let(:method) {:get}
    end

    context "authorized" do
      let(:me) {create(:user)}
      let(:access_token) {create(:access_token, resource_owner_id: me.id)}

      before do
        get '/api/v1/profiles/me', format: :json, access_token: access_token.token
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end


      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

  end


  describe "GET /others" do

    let(:url) {'/api/v1/profiles/others'}
    it_behaves_like "API Authenticable" do
      let(:method) {:get}
    end


    context "authorized" do
      size = 2
      let(:me) {create(:user)}
      let!(:others) {create_list(:user,size)}
      let(:other) {others.first}
      let(:access_token) {create(:access_token, resource_owner_id: me.id)}

      before do
        get '/api/v1/profiles/others', format: :json, access_token: access_token.token
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns array of 2 users' do
        expect(response.body).to have_json_size(2).at_path("profiles")
      end

      (0..size-1).each do |index|
        it "does not contain current user at #{index}" do
          expect(response.body).to_not be_json_eql(me.to_json).at_path("profiles/#{index}")
        end
      end


      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(other.send(attr).to_json).at_path("profiles/0/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

  end
end