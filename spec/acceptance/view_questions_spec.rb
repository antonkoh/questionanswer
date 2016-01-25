require 'rails_helper'

feature 'View questions', %q{
  As a user
  I want to view a list of questions
  To find out about other people's problems.
  } do

  given!(:questions) {create_list(:question, 5)}

  scenario 'A user views a list of questions' do
    visit questions_path

    questions.each do |q|
      expect(page).to have_content q.title
    end
  end

end

