shared_examples_for "API Authenticable" do

  let(:options) {((defined? include_options) ? include_options : {})}

  context "unauthorized" do
    it 'returns 401 status has no access token' do
      do_request(method,url, options)
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 status has incorrect access token' do
      do_request(method, url, options.merge(acces_token: '1234'))
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "authorized" do
    let(:access_token) {create(:access_token)}

    before do
      do_request(method,url, options.merge(access_token: access_token.token))
    end

    it 'returns 200 status' do
      expect(response).to have_http_status(:ok)
    end


  end

end