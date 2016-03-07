class Answer < ActiveRecord::Base
  include Votable
  include Attachable
  belongs_to :question
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  validates :body, :question_id, :user_id, presence: true

end
