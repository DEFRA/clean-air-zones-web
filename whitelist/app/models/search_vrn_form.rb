# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/vehicles/search.html.haml+.
#
# rubocop:disable Metrics/ClassLength
class SearchVrnForm < MultipleAttributesBaseForm
  # Attribute used in the search view
  attr_accessor :vrn, :historic, :start_date_day, :start_date_month, :start_date_year,
                :end_date_day, :end_date_month, :end_date_year, :start_date, :end_date

  # Check if VRN is present
  validates :vrn, presence: { message: I18n.t('vrn_form.errors.vrn_missing') }

  # Check if search type is present
  validates :historic, presence: {
    message: I18n.t('search_vrn_form.errors.dates.missing.search_type')
  }

  # Check if dates are present
  validates :start_date_day, :start_date_month, :start_date_year, :end_date_day, :end_date_month,
            :end_date_year, presence: true, if: -> { historic == 'true' }

  # Checks if VRN has valid length
  validates :vrn, length: {
    minimum: 1, too_short: I18n.t('vrn_form.errors.vrn_too_short'),
    maximum: 15, too_long: I18n.t('vrn_form.errors.vrn_too_long')
  }, allow_blank: true

  # Checks if VRN contains only alphanumerics
  validates :vrn, format: {
    with: /\A[A-Za-z0-9]+\z/,
    message: I18n.t('vrn_form.errors.vrn_invalid_format')
  }, allow_blank: true

  validate :validate_dates, if: -> { historic == 'true' }
  validate :validate_start_month_format, if: -> { historic == 'true' && no_date_errors? }
  validate :validate_end_month_format, if: -> { historic == 'true' && no_date_errors? }
  validate :validate_start_date_format, if: -> { historic == 'true' && no_date_errors? }
  validate :validate_end_date_format, if: -> { historic == 'true' && no_date_errors? }
  validate :validate_dates_period, if: -> { historic == 'true' && no_date_errors? }
  validate :validate_start_date, if: -> { historic == 'true' && no_date_errors? }

  private

  # validates start and end dates
  def validate_dates
    validate_fields(:start_date, start_date_day, start_date_month, start_date_year)
    validate_fields(:end_date, end_date_day, end_date_month, end_date_year)
  end

  # validate input fields
  def validate_fields(period, day, month, year)
    period_msg = period.to_s.humanize

    validate_day_month_year(period, period_msg, day, month, year) ||
      validate_day(period, period_msg, day, month, year) ||
      validate_month(period, period_msg, day, month, year) ||
      validate_year(period, period_msg, day, month, year) ||
      validate_day_month(period, period_msg, day, month, year) ||
      validate_day_year(period, period_msg, day, month, year) ||
      validate_month_year(period, period_msg, day, month, year)
  end

  # validates presence of day, month and year
  def validate_day_month_year(period, period_msg, day, month, year)
    return unless day.empty? && month.empty? && year.empty?

    errors.add(
      period,
      :missing,
      message: I18n.t('search_vrn_form.errors.dates.missing.all', parameter: period_msg)
    )
  end

  # validates presence of day
  def validate_day(period, period_msg, day, month, year)
    return unless day.empty? && month.present? && year.present?

    errors.add(
      period,
      :missing,
      message: I18n.t('search_vrn_form.errors.dates.missing.day', parameter: period_msg)
    )
  end

  # validates presence of month
  def validate_month(period, period_msg, day, month, year)
    return unless day.present? && month.empty? && year.present?

    errors.add(
      period,
      :missing,
      message: I18n.t('search_vrn_form.errors.dates.missing.month', parameter: period_msg)
    )
  end

  # validates presence and length of year
  def validate_year(period, period_msg, day, month, year)
    validate_year_presence(period, period_msg, day, month, year)
    validate_year_length(period, period_msg, year)
  end

  # validates presence of day and month
  def validate_day_month(period, period_msg, day, month, year)
    return unless day.empty? && month.empty? && year.present?

    errors.add(
      period,
      :missing,
      message: I18n.t('search_vrn_form.errors.dates.missing.day_month', parameter: period_msg)
    )
  end

  # validates presence of day and year
  def validate_day_year(period, period_msg, day, month, year)
    return unless day.empty? && month.present? && year.empty?

    errors.add(
      period,
      :missing,
      message: I18n.t('search_vrn_form.errors.dates.missing.day_year', parameter: period_msg)
    )
  end

  # validates presence of month and year
  def validate_month_year(period, period_msg, day, month, year)
    return unless day.present? && month.empty? && year.empty?

    errors.add(
      period,
      :missing,
      message: I18n.t('search_vrn_form.errors.dates.missing.month_year', parameter: period_msg)
    )
  end

  # validates start date format
  def validate_start_date_format
    start_date = "#{start_date_year}-#{start_date_month}-#{start_date_day}"
    self.start_date = Date.parse(start_date).strftime('%Y-%m-%d')
    raise ArgumentError unless start_date_year.to_i.positive?
  rescue ArgumentError
    add_errors_to_start_date
    errors.add(
      :start_date,
      :invalid,
      message: I18n.t('search_vrn_form.errors.dates.invalid.start_date_format')
    )
  end

  # validates end date format
  def validate_end_date_format
    end_date = "#{end_date_year}-#{end_date_month}-#{end_date_day}"
    self.end_date = Date.parse(end_date).strftime('%Y-%m-%d')
    raise ArgumentError unless end_date_year.to_i.positive?
  rescue ArgumentError
    add_errors_to_end_date
    errors.add(
      :end_date,
      :invalid,
      message: I18n.t('search_vrn_form.errors.dates.invalid.end_date_format')
    )
  end

  # validates start and end dates period
  def validate_dates_period
    return unless start_date > end_date

    add_errors_to_start_date
    errors.add(:start_date, :invalid, message: I18n.t('search_vrn_form.errors.dates.invalid.start_date'))
  end

  # checks if +start_date+ or +end_date+ errors are empty
  def no_date_errors?
    errors.messages[:start_date].empty? && errors.messages[:end_date].empty?
  end

  # add errors messages to +start_date_day+, +start_date_month+ and +start_date_year+
  def add_errors_to_start_date
    %i[start_date_day start_date_month start_date_year].each do |attr|
      errors.add(attr, :invalid)
    end
  end

  # add errors messages to +end_date_day+, +end_date_month+ and +end_date_year+
  def add_errors_to_end_date
    %i[end_date_day end_date_month end_date_year].each do |attr|
      errors.add(attr, :invalid)
    end
  end

  # validates presence of year
  def validate_year_presence(period, period_msg, day, month, year)
    return unless day.present? && month.present? && year.empty?

    errors.add(
      period,
      :missing,
      message: I18n.t('search_vrn_form.errors.dates.missing.year', parameter: period_msg)
    )
  end

  # validates length of year
  def validate_year_length(period, period_msg, year)
    return unless year.to_i.abs.to_s.length > 4

    errors.add(
      period,
      :invalid,
      message: I18n.t('search_vrn_form.errors.dates.invalid.too_many_numbers',
                      parameter: period_msg)
    )
  end

  # strip leading zeros and validate if the start date month is not more then 12
  def validate_start_month_format
    self.start_date_month = start_date_month.sub(/^0+/, '')
    return if start_date_month.to_i <= 12

    add_errors_to_start_date
    errors.add(
      :start_date,
      :invalid,
      message: I18n.t('search_vrn_form.errors.dates.invalid.start_date_format')
    )
  end

  # strip leading zeros and validate if the end date month is not more then 12
  def validate_end_month_format
    self.end_date_month = end_date_month.sub(/^0+/, '')
    return if end_date_month.to_i <= 12

    add_errors_to_end_date
    errors.add(:end_date, :invalid, message: I18n.t('search_vrn_form.errors.dates.invalid.end_date_format'))
  end

  # Validate start date if date in the future
  def validate_start_date
    return if Date.parse(start_date) <= Date.current

    add_errors_to_start_date
    errors.add(
      :start_date,
      :invalid,
      message: I18n.t('search_vrn_form.errors.dates.invalid.start_date_in_future')
    )
  end
end
# rubocop:enable Metrics/ClassLength
