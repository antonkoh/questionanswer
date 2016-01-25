FactoryGirl.define do
  factory :answer do
    sequence(:body) {|i| "Answer body #{i}"}
  end

  factory :invalid_answer, class: 'Answer' do
    body ""
  end
end