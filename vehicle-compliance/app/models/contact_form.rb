# frozen_string_literal: true

##
# This class is used to validate user data entered in contact form.
class ContactForm
  # allow using ActiveRecord validation
  include ActiveModel::Validations

  # Attribute used in contact_form view
  attr_accessor :first_name, :last_name, :email, :email_confirmation, :type_of_enquiry, :message

  # validates attributes to presence
  # rubocop:disable Style/FormatStringToken:
  validates :first_name, :last_name, :email, :email_confirmation, :type_of_enquiry, :message,
            presence: { message: '%{attribute} is required' }

  # validates max length
  validates :first_name, :last_name, :email, :email_confirmation,
            length: { maximum: 45, message: '%{attribute} is too long (maximum is 45 characters)' }

  # validates max length of message
  validates :message, length: { maximum: 2000,
                                message: '%{attribute} is too long (maximum is 2000 characters)' }

  # validates email and email_confirmation format
  validates :email, :email_confirmation, format: {
    with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/,
    message: '%{attribute} is in an invalid format'
  }

  # validates first_name and last_name format and allow double name, e.g. 'Wojciech Bogdan'
  validates :first_name, :last_name, format: {
    with: /\A[a-zA-Z ]+\z/,
    message: '%{attribute} is in an invalid format'
  }

  # rubocop:enable Style/FormatStringToken:

  # validates +email+ and +email_confirmation+
  validate :correct_email_confirmation

  # Checks if +email+ and +email_confirmation+ are same.
  # If not, add error message to +email+. and +email_confirmation+
  def correct_email_confirmation
    return if email == email_confirmation

    error_message = 'Email and email address confirmation must be the same'
    errors.add(:email, :confirmation, message: error_message)
    errors.add(:email_confirmation, :confirmation, message: error_message)
  end

  # Overrides default initializer for compliance with form_for method in content_form view
  def initialize(attributes = {})
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end
  end

  # Used in contact form view and should return nil when the object is not persisted.
  def to_key
    nil
  end
end
