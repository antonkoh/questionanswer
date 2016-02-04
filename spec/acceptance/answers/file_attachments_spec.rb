require 'rails_helper'

feature 'Answer with file', %q{
  As an authorized user
  I want to attach a file to my answer
  To provide reference for my solution.
  } do

  given!(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}

  scenario 'An authorized user creates an answer with file attached', js:true do
    login(user)
    visit question_path(question)
    fill_in 'Your answer:', with: 'Test answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Post answer'
    expect(current_path).to eq question_path(question)
    expect(page).to have_link 'spec_helper.rb', 'http://localhost:3000/uploads/attachment/file/1/spec_helper.rb'
  end

  # scenario 'An author user updates a file to own question', js:true do
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

