class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :votes_sum
  has_many :answers
  has_many :attachments


end
