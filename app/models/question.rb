class Question < ActiveRecord::Base
  include Votable
  include Attachable
  has_many :answers, dependent: :destroy

  has_many :comments, as: :commentable, dependent: :destroy

  belongs_to :user

  validates :body, :title, :user_id, presence: true
  validates :title, length: {maximum: 200}




end
