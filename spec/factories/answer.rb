FactoryGirl.define do
  factory :answer do
    body "Something in answer"
  end

  factory :invalid_answer, class: 'Answer' do
    body ""
  end
end