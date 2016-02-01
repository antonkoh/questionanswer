class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :body, presence: true
  validates :title, presence: true
  validates :title, length: {maximum: 200}
  validates :user_id, presence: true
end
