require 'rails_helper'

feature 'Delete question', %q{
  As an authorized user
  I want to delete my own question
  To hide it from everyeone.
  } do

  given!(:user1) {create(:user)}
  given!(:user2) {create(:user)}
  given!(:question) {create(:question, user: user1)}

  scenario 'An authorized user deletes own question' do
    login(user1)
    visit question_path(question)
    click_on 'Delete question'
    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
  end

  scenario 'An unauthorized user tries to delete a question' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete question'
  end

  scenario 'An authorized user tries to delete not own question' do
    login(user2)
    visit question_path(question)
    expect(page).to_not have_content 'Delete question'
  end
end

