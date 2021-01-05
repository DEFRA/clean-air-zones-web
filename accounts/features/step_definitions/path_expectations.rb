# frozen_string_literal: true

And('I should be on the Dashboard page') do
  expect_path(dashboard_path)
end

private

def expect_path(path)
  expect(page).to have_current_path(path)
end
