class AttachmentsController < ApplicationController

  def destroy
    @attachment = Attachment.find(params[:id])
    @has_rights = false
    @signed_in = false
    if user_signed_in?
      @signed_in = true
      if current_user.can_edit?(@attachment.attachmentable)
        @has_rights = true
        @attachment.destroy
      end
    end
  end
end
