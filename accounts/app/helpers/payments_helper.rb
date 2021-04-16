# frozen_string_literal: true

# View helpers for make payments flow
module PaymentsHelper
  # Gets data about the new account from the session
  def new_account_data
    (session[:new_account] || {}).symbolize_keys
  end

  # Gets data about the new payment from the session
  def new_payment_data
    (session[:new_payment] || {}).symbolize_keys
  end

  # Gets data about the current payment from the session
  def initiated_payment_data
    (session[:initiated_payment] || {}).symbolize_keys
  end

  # Extracts :payment_query form the session
  def payment_query_data
    (session[:payment_query] || {}).symbolize_keys
  end

  # Checks if given date is checked for the given VRN
  def checked?(vrn, date)
    date.in?(new_payment_data.dig(:details, vrn, :dates) || [])
  end

  # Number of selected dates
  def selected_dates_count
    session.dig('new_payment', :details)&.sum { |_k, vrn| vrn[:dates].length }
  end

  # Checks if given date is already paid
  def paid?(vehicle, date)
    vehicle.paid_dates.include?(date)
  end

  # Loads selected vrns to pay
  def vrn_to_pay(details)
    @vrn_to_pay ||= details.reject { |_k, vrn| vrn.symbolize_keys![:dates].empty? }
  end

  # Calculates total amount to pay
  def total_to_pay(details)
    vrn_to_pay(details).sum { |_k, vrn| vrn[:dates].length * vrn[:charge] }
  end

  # Collects all dates to pay
  def days_to_pay(details)
    vrn_to_pay(details).collect { |_k, vrn| vrn[:dates] }.flatten.count
  end

  # Parses date to expected format (e.g. 'Tuesday 3 March 2020')
  def parse_date(date)
    parsed_date = Date.parse(date)
    parsed_date.strftime('%A %d %B %Y')
  end

  # Parses charge for single vehicle number
  def single_vrn_parsed_charge(dates, charge)
    parse_charge(dates.length * charge)
  end

  # Reads file with additional URLs
  def external_urls
    YAML.load_file('additional_urls.yaml')
  end

  # Transforms a date into more user friendly string such as '25 March 2020'.
  def formatted_date_string(date)
    Date.parse(date).strftime('%d %B %Y')
  end

  # Returns exemption URL with proper title for given CAZ
  def exemption_url_for(caz)
    external_link_to(caz.name, caz.exemption_url)
  end
end
