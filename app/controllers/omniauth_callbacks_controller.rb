class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    process_oauth('Facebook')
  end
  def github
    process_oauth('Github')
  end


  private
  def process_oauth(kind)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    end

  end
end
