# frozen_string_literal: true

##
# Base module for helpers, generated automatically during new application creation
#
module ApplicationHelper
  # Remove duplicated error messages, e.g. `Email and email address confirmation must be the same`
  def remove_duplicated_messages(errors)
    transformed_errors(errors).uniq(&:first)
  end

  # Transform hash of errors:
  # {
  #   :email_confirmation=>["Email confirmation is in an invalid format", "Email and email address confirmation must be the same"],
  #   :email=>["Email and email address confirmation must be the same"]
  # }
  # to array:
  # [
  #   ["Email confirmation is in an invalid format", :email_confirmation],
  #   ["Email and email address confirmation must be the same",:email_confirmation],
  #   ["Email and email address confirmation must be the same", :email]
  # ]
  #
  def transformed_errors(errors)
    errors.map { |error| error.second.map { |msg| [msg, error.first] } }.flatten(1)
  end

  # Returns name of service, eg. 'Drive in a Clean Air Zone'
  def service_name
    Rails.configuration.x.service_name
  end

  # Renders back link
  def back_link(url, text = 'Back')
    link_to(text, url, class: 'govuk-back-link back-link')
  end
end
