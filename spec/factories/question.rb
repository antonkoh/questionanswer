FactoryGirl.define do
  factory :question do
    title "My question"
    body "Something"
    user
  end

  factory :invalid_question, class: 'Question' do
    title ""
    body ""
    user
  end
end