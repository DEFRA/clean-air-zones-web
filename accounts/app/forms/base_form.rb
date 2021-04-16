# frozen_string_literal: true

##
# This is an abstract class used as a base for form classes.
class BaseForm
  # allow using ActiveRecord validation
  include ActiveModel::Validations

  # Email Address Regular Expression
  EMAIL_FORMAT = %r{\A(([\w\d!#$%&'*+\-/=?^_`{|}~]+)(\.{1}))*
    ([\w\d!#$%&'*+\-/=?^_`{|}~]+)@[a-zA-Z\d\-]+(\.[a-zA-Z\d\-]+)*\.[a-zA-Z]+\z}x

  # Overrides default initializer for compliance with form_for method in content_form view
  def initialize(attributes = {})
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end
  end

  # Used in form view and should return nil when the object is not persisted.
  def to_key
    nil
  end

  # Logs exception on +error+ level
  def log_error(exception)
    Rails.logger.error "[#{self.class.name}] #{exception.class} - #{exception}"
  end

  # returns first error message from the errors collection.
  def first_error_message
    errors.messages.values.flatten.first
  end
end
