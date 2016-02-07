require 'rails_helper'

feature 'Create answer', %q{
  As an authorized user
  I want to answer a question
  To share my experience.
  } do

  given!(:user) {create(:user)}
  given!(:questions) {create_list(:question, 5)}

  scenario 'An authorized user answers a question', js:true do
    login(user)
    visit questions_path
    q = questions.sample
    click_on q.title
    fill_in 'Your answer:', with: 'Test answer'
    click_on "Post answer"
    expect(current_path).to eq question_path(q)
    expect(page).to have_content 'Test answer'

  end

  scenario 'An authorized user adds invalid answer', js:true do
    login(user)
    visit questions_path
    q = questions.sample
    click_on q.title
    click_on "Post answer"
    expect(page).to have_content 'Body can\'t be blank'

  end

  scenario 'An unauthorized user tries to answer a question', js:true do
    visit questions_path
    click_on questions.sample.title

    expect(page).to_not have_button "Post answer"

    #expect(current_path).to eq new_user_session_path
  end
end

