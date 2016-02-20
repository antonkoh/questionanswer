shared_examples_for "API Authenticable" do
  context "unauthorized" do
    it 'returns 401 status has no access token' do
      do_request(method,url)
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 status has incorrect access token' do
      do_request(method, url, acces_token: '1234')
      expect(response).to have_http_status(:unauthorized)
    end
  end

end