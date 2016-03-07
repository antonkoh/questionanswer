class Api::V1::ProfilesController < Api::V1::BaseController

  authorize_resource class: User

  def me
    render json: current_resource_owner
  end

  def others
    render json: User.all.select {|u| u != current_resource_owner}
  end


end