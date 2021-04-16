# frozen_string_literal: true

When('I visit the make payment page') do
  mock_debits
  mock_actual_account_name
  login_user(permissions: %w[MANAGE_VEHICLES MAKE_PAYMENTS], account_id: account_id)
  visit payments_path
end

When('I visit the make payment page as a beta tester') do
  mock_debits
  mock_actual_account_name
  login_user(permissions: %w[MANAGE_VEHICLES MAKE_PAYMENTS], account_id: account_id, beta_tester: true)
  visit payments_path
end

Then('I should be on the first upload page') do
  expect_path(first_upload_fleets_path)
end

Then('I should be on the make a payment page') do
  expect_path(payments_path)
end

Then('I should be on the payment matrix page') do
  expect_path(matrix_payments_path)
end

Then('I should be on the No chargeable vehicles page') do
  expect_path(no_chargeable_vehicles_payments_path)
end

Then('I should be on the Undetermined vehicles page') do
  expect_path(undetermined_vehicles_payments_path)
end

When('I select any date for vrn on the payment matrix') do
  page.find('.govuk-checkboxes__input', match: :first).click
end

And('I confirm that my vehicles are not exempt from payment') do
  page.find('#confirm_not_exemption').click
end

Then('I should be on the confirm payment page') do
  expect_path(review_payments_path)
end

When('I click view details link') do
  click_link('View details')
end

Then('I should be on the Charge details page') do
  expect_path(review_details_payments_path)
end

And('I want to confirm my payment') do
  mock_debits('active_mandates')
  mock_requests_to_payments_api_with(return_url: result_payments_path)
end

And('I want to confirm my payment without any active Direct Debit mandate') do
  mock_caz_mandates('inactive_caz_mandates')
  mock_requests_to_payments_api_with(return_url: result_payments_path)
end

And('I want to confirm my payment when Direct Debits are disabled') do
  mock_direct_debit_disabled
  mock_requests_to_payments_api_with(return_url: result_payments_path)
end

Then('I should be on the success payment page') do
  expect_path(success_payments_path)
end

And('I should see success message') do
  expect(page).to have_content('Payment complete')
end

When('I click Next 7 days tab') do
  click_link('Next 7 days')
end

Then('I should be on the Post Payment Details page') do
  expect_path(post_payment_details_payments_path)
end

Then('I should be on the Select payment method page') do
  expect_path(select_payment_method_payments_path)
end

Then('Second user is blocked from making a payment in the same CAZ') do
  Capybara.using_session('Second user session') do
    sign_in_second_user
    mock_user_details
    visit_caz_selection_page
    expect_path(in_progress_payments_path)
  end
end

Then('Second user can now pay for Birmingham') do
  Capybara.using_session('Second user session') do
    visit_caz_selection_page
    expect_path(matrix_payments_path)
  end
end

Then('After 16 minutes second user can pay for Bath too') do
  travel(16.minutes) do
    sign_in_second_user
    visit payments_path
    choose('Bath')
    click_on('Continue')
    expect_path(matrix_payments_path)
  end
end

And('Second user starts payment in the same CAZ') do
  Capybara.using_session('Second user session') do
    sign_in_second_user
    visit payments_path
    visit_caz_selection_page
    expect_path(matrix_payments_path)
  end
  mock_second_user_details
end

Then('I should be on the payment in progress page') do
  expect_path(in_progress_payments_path)
end

private

def sign_in_second_user
  login_user(
    email: 'second_user@email.com',
    permissions: %w[MANAGE_VEHICLES MAKE_PAYMENTS],
    account_id: account_id,
    user_id: second_user_id
  )
end

def visit_caz_selection_page
  visit payments_path
  choose('Birmingham')
  click_on('Continue')
end
