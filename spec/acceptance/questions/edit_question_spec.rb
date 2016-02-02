require 'rails_helper'

feature 'Edit question', %q{
  As an authorized user
  I would like to edit my own question
  To fix its content
} do

  given!(:user1) {create(:user)}
  given!(:user2) {create(:user)}
  given!(:question) {create(:question, user: user1)}

  scenario 'An authorized user edits own question', js:true do
    login(user1)
    visit question_path(question)
    click_on 'Edit'
   # expect(current_path).to eq edit_question_path(question)
    fill_in 'Title', with: 'New question title'
    fill_in 'Text', with: 'New question body'
    click_on 'Save'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'New question title'
    expect(page).to have_content 'New question body'
  end

  scenario 'An authorized user edits own question with invalid data', js:true do
    login(user1)
    visit question_path(question)
    click_on 'Edit'
#    expect(current_path).to eq edit_answer_path(answer)
    fill_in 'Title', with: ''
    fill_in 'Text', with: ''
    click_on 'Save'
    expect(current_path).to eq question_path(question)

    expect(page).to have_content 'Body can\'t be blank'
    expect(page).to have_content 'Title can\'t be blank'
  end

  scenario 'An unauthorized user tries to edit a question', js:true do
    visit question_path(question)
    expect(page).to_not have_content 'Edit'
  end

  scenario 'An authorized user tries to edit not own question', js:true do
    login(user2)
    visit question_path(question)
    expect(page).to_not have_content 'Edit'
  end
end