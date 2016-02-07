class AttachmentsController < ApplicationController
  before_action :authenticate_user!


  def destroy
    @attachment = Attachment.find(params[:id])
    authorize!(:destroy, @attachment)
    @attachment.destroy
  end
end
