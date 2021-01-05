# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # Service used to validate and upload csv file to S3
  #
  class UploadFile < BaseService
    # Attributes used externally
    attr_reader :filename

    ##
    # Initializer method.
    #
    # ==== Params
    #
    # * +file+ - uploaded file
    # * +user+ - an instance of the User class
    #
    def initialize(file:, user:)
      @file = file
      @user = user
      @filename = "fleet_#{user.user_id}_#{Time.current.to_i}"
    end

    # Invokes validating, uploading file to AWS S3, count number of vehicles and compare with threshold settings
    def call
      validate
      upload_to_s3
      self
    end

    # Count number of vehicles and compare with threshold setting
    def large_fleet?
      vehicles_count >= Rails.configuration.x.large_fleet_threshold
    end

    private

    # Validates a csv file.
    #
    # Raises exception if at least one validation not returns true.
    #
    # Returns a boolean.
    def validate
      return unless no_file_selected? || invalid_extname? || filesize_too_big? || fleet_size_too_big?

      raise CsvUploadException, error
    end

    # Checks if file is present.
    # If not, add error message to +error+.
    #
    # Returns a boolean if file is present.
    # Returns a string if not.
    def no_file_selected?
      @error = I18n.t('csv.errors.no_file') if file.nil?
    end

    # Checks if filename extension equals `csv`.
    # If not, add error message to +error+.
    #
    # Returns a boolean if filename extension equals `csv`.
    # Returns a string if not.
    def invalid_extname?
      return if File.extname(file.original_filename).downcase == '.csv'

      @error = I18n.t('csv.errors.invalid_ext')
    end

    # Checks if file size not bigger than `Rails.configuration.x.csv_file_size_limit`
    # Returns a boolean if filename is compliant with the naming rules
    # Returns a string if not.
    def filesize_too_big?
      csv_file_size_limit = Rails.configuration.x.csv_file_size_limit
      return unless file.size > csv_file_size_limit.megabytes

      @error = I18n.t('csv.errors.file_size_too_big', file_size: csv_file_size_limit)
    end

    # Count number of vehicles and compare with max fleet size setting
    def fleet_size_too_big?
      return unless vehicles_count > Rails.configuration.x.max_fleet_size

      @error = I18n.t('csv.errors.fleet_size_too_big')
    end

    # Count number of vehicles
    def vehicles_count
      @vehicles_count ||= VehiclesManagement::CountVehicles.call(file: file)
    end

    # Uploading file to AWS S3.
    #
    # Raise exception if upload failed
    #
    # Returns a boolean.
    def upload_to_s3
      log_action('Uploading file to S3')
      return true if aws_call

      raise CsvUploadException, I18n.t('csv.errors.base')
    rescue Aws::S3::Errors::ServiceError => e
      log_error e
      raise CsvUploadException, I18n.t('csv.errors.base')
    end

    # Uploading file to AWS S3.
    #
    # Returns a boolean.
    def aws_call
      s3_object = AMAZON_S3_CLIENT.bucket(bucket_name).object(filename)
      s3_object.upload_file(file, metadata: metadata)
    end

    # AWS S3 Bucket Name.
    #
    # Returns a string.
    def bucket_name
      ENV.fetch('S3_AWS_BUCKET', 'bucket_name')
    end

    def metadata
      { 'account-user-id': user.user_id, 'account-id': user.account_id }
    end

    # Attributes used internally to read values
    attr_reader :file, :error, :user
  end
end
