FactoryGirl.define do
  sequence :title do |i|
    "My question title #{i}"
  end

  sequence :body do |i|
    "My question body #{i}"
  end

  factory :question do
    title
    body
    user
  end

  factory :invalid_question, class: 'Question' do
    title ""
    body ""
    user
  end
end