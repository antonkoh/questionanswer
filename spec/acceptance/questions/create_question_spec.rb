require 'rails_helper'

feature 'Create question', %q{
  As an authorized user
  I want to create a question
  To share my problem.
  } do

  given!(:user) {create(:user)}

  scenario 'An authorized user creates a question' do
    login(user)
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'Body of question'
    click_on 'Create'

    expect(page).to have_content 'Your question has been created'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Body of question'


  end

  scenario 'An authorized user creates a question with invalid data' do
    login(user)
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: ''
    fill_in 'Text', with: ''
    click_on 'Create'

    expect(page).to have_content 'Body can\'t be blank'
    expect(page).to have_content 'Title can\'t be blank'

  end

  scenario 'An unauthorized user tries to create a question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
    expect(current_path).to eq new_user_session_path

  end
end

