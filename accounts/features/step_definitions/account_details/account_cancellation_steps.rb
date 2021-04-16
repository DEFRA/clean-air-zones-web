# frozen_string_literal: true

Then('I should be redirected to Account Closed page') do
  expect(page).to have_current_path(account_closed_path)
end

Then('I should be on the Closing Account page') do
  expect(page).to have_current_path(account_closing_notice_path)
end
