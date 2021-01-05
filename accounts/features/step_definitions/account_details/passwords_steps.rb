# frozen_string_literal: true

And('I should be on account details update password page') do
  expect(page).to have_current_path(edit_password_path)
end

And('I want to change my password') do
  visit edit_password_path
end
