class ShortAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :votes_sum
end