# frozen_string_literal: true

Given('I am on the Relevant portal form page') do
  visit what_would_you_like_to_do_path
end

Then('I should be on the Root path') do
  expect(page).to have_current_path(root_path)
end
