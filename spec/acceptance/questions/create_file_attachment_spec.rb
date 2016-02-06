require 'rails_helper'

feature 'Question with file', %q{
  As an authorized user
  I want to attach a file to my question
  To provide reference for my problem.
  } do

  given!(:user) {create(:user)}

  scenario 'An authorized user creates a question with file attached', js:true do
    login(user)
    visit questions_path()
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'Body of question'
    click_on 'Add file'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'
    expect(page).to have_link 'spec_helper.rb', 'http://localhost:3000/uploads/attachment/file/1/spec_helper.rb'
  end

  # scenario 'An author user attaches a file to own question', js:true do
  #   login(user)
  #   visit question_path(question)
  #   click_on 'Edit'
  #   fill_in 'Title', with: 'Test question'
  #   fill_in 'Text', with: 'Body of question'
  #   attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
  #   click_on 'Save'
  #   expect(page).to have_link 'spec_helper.rb', 'http://localhost:3000/uploads/attachment/file/1/spec_helper.rb'
  # end


end

