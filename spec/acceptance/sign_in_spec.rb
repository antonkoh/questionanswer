require 'rails_helper'

feature 'Sign in', %q{
  To access write-mode features
  as an unauthorized user
  I want to sign in.
 } do

  given!(:user) {create(:user)}

  scenario 'Existing user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_link 'Log out'
  end


  scenario 'Non-existing user tries to sign in' do

    visit new_user_session_path
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'

    click_on 'Log in'
    expect(page).to have_content 'Invalid email or password'
    expect(page).to_not have_link 'Sign out'
  end
end