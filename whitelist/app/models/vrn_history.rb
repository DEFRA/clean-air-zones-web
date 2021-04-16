# frozen_string_literal: true

##
# Represents the virtual model of the vrn history.
#
class VrnHistory
  # Initializer method.
  #
  # ==== Params
  # * +data+ - hash
  #   * +modifyDate+ - string, date format
  #   * +action+ - string, status of current VRM for a specific date range
  #   * +category+ - string, eg. 'Early Adopter'
  #   * +manufacturer+ - string, eg. 'ZAZ'
  #   * +reasonUpdated+ - string, eg. 'Testing'
  #   * +uploaderId+ - string, eg. '3fa85f64-5717-4562-b3fc-2c963f66afa6'
  #
  def initialize(data)
    @data = data
  end

  # returns date, e.g. '22/06/2020'
  def data_upload_date
    formatted_timestamp(data['modifyDate'])
  end

  # returns string, e.g. 'Updated'
  # returns `Added` if value is 'Created'
  def action
    value = data['action'].capitalize
    value == 'Created' ? 'Added' : value
  end

  # returns string, e.g. 'Early Adopter'
  def category
    data['category']
  end

  # returns string, e.g. 'Testing'
  def reason_updated
    data['reasonUpdated']
  end

  # returns string, e.g. 'ZAZ'
  def manufacturer
    data['manufacturer']
  end

  # returns a string, e.g. 'user@example.com'
  def uploader_email
    data['uploaderEmail']
  end

  private

  # Reader for data hash
  attr_reader :data

  # returns formatted date, e.g. '22/06/2020'
  def formatted_timestamp(date)
    Date.parse(date).strftime('%d/%m/%Y')
  end
end
