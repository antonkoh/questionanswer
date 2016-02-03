class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy
  belongs_to :user

  validates :body, :title, :user_id, presence: true
  validates :title, length: {maximum: 200}

  accepts_nested_attributes_for :attachments
end
