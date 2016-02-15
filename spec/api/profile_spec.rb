require 'rails_helper'

RSpec.describe "Profiles API" do
  describe "GET /me" do
    context "unauthorized" do
      it 'returns 401 status has no access token' do
        get '/api/v1/profiles/me', format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns 401 status has incorrect access token' do
        get '/api/v1/profiles/me', format: :json, acces_token: '1234'
        expect(response).to have_http_status(:unauthorized)
      end
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
end