class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :body, presence: true
  validates :title, presence: true
  validates :title, length: {maximum: 200}
end
