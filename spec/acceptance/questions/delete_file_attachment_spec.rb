require 'rails_helper'

feature 'Delete file from question', %q{
  As an authorized user
  I want to delete a file from my question
  To remove reference for my problem.
  } do

  given!(:user1) {create(:user)}
  given!(:user2) {create(:user)}
  given!(:question) {create(:question, user: user1)}
  given!(:attachment) {create(:attachment, attachmentable_id: question.id, attachmentable_type: 'Question')}

  background do
    attachment
  end


  scenario 'A question author deletes file attached to question', js:true do
    login(user1)
    visit question_path(question)
    click_on 'Delete file'
    expect(current_path).to eq question_path(question)
    expect(page).to_not have_link 'Delete file'
    expect(page).to_not have_content 'spec_helper.rb'
  end

  scenario 'A non-author cannot delete file attached to question', js:true do
    login(user2)
    visit question_path(question)
    expect(page).to have_link 'spec_helper.rb', 'http://localhost:3000/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to_not have_link 'Delete file'
  end

  scenario 'An unauthorized user cannot delete file attached to question', js:true do
    visit question_path(question)
    expect(page).to have_link 'spec_helper.rb', 'http://localhost:3000/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to_not have_link 'Delete file'
  end




end

