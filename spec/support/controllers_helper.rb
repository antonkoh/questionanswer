module ControllersHelper
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  def it_redirects_to_root
    expect(response).to redirect_to root_path
  end

  def it_includes_unauthorized_flash
    expect(flash[:notice]).to eq I18n.t('unauthorized.default')
  end

  def it_renders_JS_unauthorized
    expect(response).to render_template 'common/unauthorized'
  end



  # def handle_unauthorized
  #   it 'redirects to root' do
  #     expect(response).to redirect_to root_path
  #   end
  #
  #   it 'includes a flash notice' do
  #     expect(flash[:notice]).to eq I18n.t('unauthorized.default')
  #   end
  # end


end