require 'rails_helper'

feature 'Create question', %q{
  As an authorized user
  I want to create a question
  To share my problem.
  } do

  given!(:user) {create(:user)}

  scenario 'An authorized user creates a question' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'Body of question'
    click_on 'Create'

    expect(page).to have_content 'Your question has been created'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Body of question'


  end

  scenario 'An unauthorized user tries to creates a question' do

  end
end

