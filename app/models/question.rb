class Question < ActiveRecord::Base
  validates :body, presence: true
  validates :title, presence: true
  validates :title, length: {maximum: 200}
end
