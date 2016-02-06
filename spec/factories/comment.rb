FactoryGirl.define do

  factory :comment do
    sequence(:body) {|i| "Comment body #{i}"}
  end

  factory :invalid_comment, class: 'Comment' do
    body ""
  end
end