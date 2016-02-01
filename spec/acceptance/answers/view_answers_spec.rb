require 'rails_helper'

feature 'View answers', %q{
  As a user
  I want to view a list of answers
  To see other people's opinion on a question.
  } do

  given!(:question) {create(:question)}
  given!(:answers) {create_list(:answer, 6, question: question)}

  scenario 'A user views answers to a question' do
    visit question_path(question)
    question.answers.each do |a|
      expect(page).to have_content a.body
    end
  end

end

