# frozen_string_literal: true

Then('I should be on the enter details page') do
  expect_path(enter_details_vehicle_checkers_path)
end

Then('I should be on the UK registered details') do
  expect_path(confirm_uk_details_vehicle_checkers_path)
end

private

def expect_path(path)
  expect(page).to have_current_path(path)
end
