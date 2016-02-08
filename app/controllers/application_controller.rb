class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  check_authorization unless :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html {redirect_to root_path, notice: exception.message}
      format.json {render json: {error: I18n.t('unauthorized.default')}, status: :forbidden}
      format.js do
        render 'common/unauthorized', status: :forbidden
      end
    end

  end



end
