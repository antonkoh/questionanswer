require 'rails_helper'

RSpec.describe "Profiles API" do
  describe "GET /me" do
    let(:method) {:get}
    let(:url) {'/api/v1/profiles/me'}
    it_behaves_like "API Authenticable"

    context "authorized" do
      let(:me) {create(:user)}
      let(:access_token) {create(:access_token, resource_owner_id: me.id)}

      before do
        do_request(method,url, access_token: access_token.token)
      end

      context 'profile contents' do
        it_behaves_like "API Single Contents", 'id email created_at updated_at admin' do
          let(:single) {me}
          let(:substitute_single_name) {''}
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
    let(:method) {:get}
    let(:url) {'/api/v1/profiles/others'}

    it_behaves_like "API Authenticable" do
      let(:method) {:get}
    end


    context "authorized" do
      size = 2
      let(:me) {create(:user)}
      let!(:others) {create_list(:user,size)}
      let(:access_token) {create(:access_token, resource_owner_id: me.id)}


      before do
        do_request(method,url, access_token: access_token.token)
      end

      it_behaves_like "API List Contents", 'id email created_at updated_at admin', 'password encrypted_password' do
        let(:substitute_contents_name) {'profiles'}
        let(:contents) {others}
      end



      (0..size-1).each do |index|
        it "does not contain current user at #{index}" do
          expect(response.body).to_not be_json_eql(me.to_json).at_path("profiles/#{index}")
        end
      end


    end

  end
end