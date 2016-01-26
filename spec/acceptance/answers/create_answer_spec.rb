require 'rails_helper'

feature 'Create answer', %q{
  As an authorized user
  I want to answer a question
  To share my experience.
  } do

  given!(:user) {create(:user)}
  given!(:questions) {create_list(:question, 5)}

  scenario 'An authorized user answers a question' do
    login(user)
    visit questions_path
    q = questions.sample
    click_on q.title
    fill_in 'Your answer:', with: 'Test answer'
    click_on "Post answer"
    expect(current_path).to eq question_path(q)
    expect(page).to have_content 'Test answer'

  end

  scenario 'An unauthorized user tries to answer a question' do
    visit questions_path
    click_on questions.sample.title
    click_on "Post answer"
    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
    expect(current_path).to eq new_user_session_path
  end
end

