# frozen_string_literal: true

##
# Controls the flow for sending contact forms
#
class ContactFormsController < ApplicationController
  ##
  # Renders the contact form page
  #
  # ==== Path
  #    GET /contact_forms
  #
  def index
    @return_url = if request.referer&.include?(non_uk_vehicle_checkers_path)
                    non_uk_vehicle_checkers_path
                  else
                    root_path
                  end
  end

  ##
  # Validates user data entered in contact form
  # If successful, redirects to {result}[rdoc-ref:ContactFormsController.result]
  # If not successful, renders {index view}[rdoc-ref:ContactFormsController.index] with errors
  #
  # ==== Path
  #    POST /contact_forms
  #
  # ==== Params
  # * +params+ - hash
  #   * +first_name+ - string, users's first name
  #   * +last_name+ - string, users's  last name
  #   * +email+ - string, user's email address
  #   * +email_confirmation+ - string, user's email confirmation address
  #   * +type_of_enquiry+ - string, users's type of enquiry
  #   * +message+ - string, users's message typed in form
  #
  def validate
    form = ContactForm.new(params['contact_form'])
    if form.valid?
      message_ids = send_emails(form)
      redirect_to result_contact_forms_path, alert: message_ids.any?(&:blank?)
    else
      @errors = form.errors.messages
      log_invalid_form 'Rendering :index'
      render :index
    end
  end

  ##
  # Renders the contact form result page
  #
  # ==== Path
  #    GET /contact_forms/result
  #
  def result
    # renders static view
  end

  private

  # Calls Sqs::JaquMessage and Sqs::UserMessage with submitted form data
  # Returns an array of message IDs
  def send_emails(form)
    [Sqs::JaquMessage, Sqs::UserMessage].map { |klass| klass.call(contact_form: form) }
  end
end
