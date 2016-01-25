FactoryGirl.define do
  factory :answer do
    sequence(:body) {|i| "Answer body #{i}"}
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body ""
  end
end