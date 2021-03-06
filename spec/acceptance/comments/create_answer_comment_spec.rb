require 'rails_helper'

feature 'Create answer comment', %q{
  As any user
  I want to comment an answer
  To share my opinion.
  } do

  given!(:question) {create(:question)}
  given!(:answer) {create(:answer, question: question)}
  given!(:user) {create(:user)}

  scenario 'A user comments an answer' do
    login(user)
    visit question_path(question)
    click_on 'Add comment to answer'
    fill_in 'Your comment:', with: 'Test comment'
    click_on "Post comment"
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Test comment'
  end

  scenario 'A user comments an answer with invalid data' do
    login(user)
    visit question_path(question)
    click_on 'Add comment to answer'
    fill_in 'Your comment:', with: ''
    click_on "Post comment"
    expect(current_path).to eq answer_comments_path(answer)
    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'A guest comments an answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Add comment to answer'
  end


end

