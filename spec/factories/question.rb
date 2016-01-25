FactoryGirl.define do
  factory :question do
    title "My question"
    body "Something"
  end

  factory :invalid_question, class: 'Question' do
    title ""
    body ""
  end
end