require 'rails_helper'

feature 'Edit answer', %q{
  As an authorized user
  I would like to delete my own answer
  To hide it from others.
} do

  given!(:user1) {create(:user)}
  given!(:user2) {create(:user)}
  given!(:question) {create(:question)}
  given!(:answer) {create(:answer, user: user1, question: question)}

  scenario 'An authorized user deletes own answer' do
    login(user1)
    visit question_path(question)
    click_on 'Delete answer'
    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content answer.body
  end

  scenario 'An unauthorized user tries to delete an answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'An authorized user tries to delete not own answer' do
    login(user2)
    visit question_path(question)
    expect(page).to_not have_content 'Delete answer'
  end
end