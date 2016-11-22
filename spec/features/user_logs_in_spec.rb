require 'spec_helper'

feature User, 'logs in:' do

  background do
    @user = FactoryGirl.create(:user)
  end

  scenario "visits root page and sees log in link" do
    visit "/"
    expect(page).to have_css("#new_user")
  end

  scenario "sees the log in form" do
    visit "/"
    expect(page).to have_css("#user_email")
    expect(page).to have_css("#user_password")
  end

  scenario "fails to log in with an invalid account", :js => true do
    visit new_user_session_path
    fill_the_form_with(@user.email, "wrong_password")
    click_on('Entrar')
    sees_error_message "Correo o contraseña inválidos."
  end

  scenario "succeed to log in with a valid account", :js => true do
    visit new_user_session_path
    fill_the_form_with(@user.email, @user.password)
    click_on('Entrar')
    sees_success_message "Ingreso exitoso"
    expect(current_path).to eq(organization_path(@user.organization))
  end

  def fill_the_form_with(email, password)
    fill_in("Correo electrónico", :with => email)
    fill_in("Contraseña", :with => password)
  end
end
