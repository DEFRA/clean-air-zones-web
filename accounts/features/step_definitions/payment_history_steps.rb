# frozen_string_literal: true

Given('I visit the Company payment history page') do
  mock_api_on_payment_history
  mock_clean_air_zones
  mock_debits
  login_user(permissions: %w[VIEW_PAYMENTS MAKE_PAYMENTS])
  visit payment_history_path
end

Given('I go to the Company payment history page') do
  visit payment_history_path
end

Given('I want visit the Payments details page from Company payments history page') do
  mock_users
  mock_api_and_sign_in_user
  visit payment_history_path
end

Then('I should be on the the Company payment history page') do
  expect_path(payment_history_path)
end

And('I should be on the Payment history page number {int}') do |page_number|
  expect(page).to have_current_path("#{payment_history_url}?page=#{page_number}")
end

And('I should be on the Payment history page number {int} when using back button') do |page_number|
  expect(page).to have_current_path("#{payment_history_url}?page=#{page_number}?back=true")
end

And('I should be on the User payment history page number {int}') do |page_number|
  expect(page).to have_current_path("#{user_payment_history_url}?page=#{page_number}")
end

And('I should be on the User payment history page number {int} when using back button') do |page_number|
  expect(page).to have_current_path("#{user_payment_history_url}?page=#{page_number}?back=true")
end

When('I press {int} pagination button on the payment history page') do |selected_page|
  mock_payment_history(selected_page)
  page.find("#pagination-button-#{selected_page}").first('a').click
end

Then('I should be on the the Payment details history page') do
  expect_path("#{payment_history_details_path}?payment_id=b1f14586-d024-11ea-afe0-47fd231cac0c")
end

private

def mock_payment_history(page = 1)
  allow(PaymentHistory::History).to receive(:new).and_return(create_history(page))
end

def mock_empty_payment_history
  allow(PaymentHistory::History).to receive(:new).and_return(create_empty_history)
end

def create_empty_history
  instance_double(PaymentHistory::History, pagination: empty_payments_history_page)
end

def create_history(page)
  instance_double(PaymentHistory::History, pagination: paginated_history(page))
end

def paginated_history(page = 1)
  instance_double(
    PaymentHistory::PaginatedPayment,
    payments_list: payments_list, page: page, total_pages: 5, range_start: 1, range_end: 10,
    total_payments_count: 52, results_per_page: [10, 20, 30, 40, 50]
  )
end

def empty_payments_history_page
  instance_double(
    PaymentHistory::PaginatedPayment,
    payments_list: [], page: 1, total_pages: 0, range_start: 1, range_end: 10,
    total_payments_count: 0, results_per_page: [10, 20, 30, 40, 50]
  )
end

def payments_list
  api_response.map { |data| PaymentHistory::Payment.new(data) }
end

def api_response
  read_response('payment_history/payments.json')['1']['payments']
end

def mock_api_and_sign_in_user
  mock_api_on_payment_history
  mock_payment_details_history
  mock_clean_air_zones
  mock_debits
  login_user(permissions: %w[VIEW_PAYMENTS MAKE_PAYMENTS])
end

def mock_payment_details_history
  api_response = read_response('payment_history/payment_details.json')
  allow(PaymentHistoryApi).to receive(:payment_details).and_return(api_response)
end

def mock_api_on_payment_history
  mock_actual_account_name
  mock_vehicles_in_fleet
  mock_payment_history
  mock_users
end
