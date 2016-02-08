require 'rails_helper'

feature 'Edit answer', %q{
  As an authorized user
  I would like to edit my own answer
  To fix its content
} do

  given!(:user1) {create(:user)}
  given!(:user2) {create(:user)}
  given!(:question) {create(:question)}
  given!(:answer) {create(:answer, user: user1, question: question)}

  scenario 'An authorized user edits own answer', js: true do
    login(user1)
    visit question_path(question)
    click_on 'Edit answer'
#    expect(current_path).to eq edit_answer_path(answer)
    fill_in 'Your answer:', with: 'New answer body'
    click_on 'Save'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'New answer body'
  end

  scenario 'An authorized user edits own answer with invalid data', js:true do
    login(user1)
    visit question_path(question)
    click_on 'Edit answer'
#    expect(current_path).to eq edit_answer_path(answer)
    fill_in 'Your answer:', with: ''
    click_on 'Save'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'An unauthorized user tries to edit an answer', js:true do
    visit question_path(question)
    expect(page).to_not have_content 'Edit answer'
  end

  scenario 'An authorized user tries to edit not own answer', js:true do
    login(user2)
    visit question_path(question)
    expect(page).to_not have_content 'Edit answer'
  end
end