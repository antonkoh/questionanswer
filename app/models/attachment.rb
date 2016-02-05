class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader
  belongs_to :attachmentable, polymorphic: true

  #validates :attachmentable_id, presence: true
 # validates :attachmentable_type, presence: true

end
