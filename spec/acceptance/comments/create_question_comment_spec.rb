require 'rails_helper'

feature 'Create question comment', %q{
  As any user
  I want to comment a question
  To share my opinion.
  } do

  given!(:question) {create(:question)}

  scenario 'A guest comments a question' do
    visit question_path(question)
    click_on 'Add comment to question'
    fill_in 'Your comment:', with: 'Test comment'
    click_on "Post comment"
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Test comment'
  end

  scenario 'A guest comments a question with invalid data' do
    visit question_path(question)
    click_on 'Add comment to question'
    fill_in 'Your comment:', with: ''
    click_on "Post comment"
    expect(current_path).to eq question_comments_path(question)
    expect(page).to have_content 'Body can\'t be blank'
  end

end

