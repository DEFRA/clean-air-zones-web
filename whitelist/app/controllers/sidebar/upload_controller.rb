# frozen_string_literal: true

##
# Module used to show sidebar only for proper controllers
module Sidebar
  ##
  # Controller class for uploading a csv file.
  #
  class UploadController < BaseController
    # checks if a user has a 'FORCE_NEW_PASSWORD' status
    before_action :redirect_to_new_password_path
    # checks if session +job+ is present
    before_action :check_job_data, only: %i[processing]

    ##
    # Upload csv file to AWS S3.
    #
    # ==== Path
    #
    #    :POST /upload/import
    #
    # ==== Params
    # * +file+ - uploaded file
    # * +current_user+ - an instance of the User class
    #
    def import
      filename = CsvUploadService.call(file: file, user: current_user)
      correlation_id = SecureRandom.uuid
      job_name = RegisterCheckerApi.register_job(filename, correlation_id)
      save_details_to_session(job_name, filename, correlation_id)
      redirect_to processing_upload_index_path
    end

    ##
    # Checking of job status.
    #
    # ==== Path
    #
    #    :GET /upload/processing
    #
    # ==== Params
    # * +job_name+ - UUID, eg '98faf123-d201-48cb-8fd5-4b30c1f80918'
    # * +job_correlation_id+ - UUID, eg '98faf123-d201-48cb-8fd5-4b30c1f80918'
    #
    def processing
      result = RegisterCheckerApi.job_status(job_name, job_correlation_id)
      return if result == 'RUNNING'

      if result == 'SUCCESS'
        session[:job] = nil
        flash[:success] = I18n.t('database_updated')
        redirect_to authenticated_root_path
      else
        redirect_to authenticated_root_path, alert: 'Uploaded file is not valid'
      end
    end

    ##
    # Renders the upload page.
    #
    # ==== Path
    #
    #    :GET /upload/index
    #
    def index
      return unless session[:job]

      @job_errors = RegisterCheckerApi.job_errors(job_name, job_correlation_id)
      session[:job] = nil
    end

    # Renders the data rules page.
    #
    # ==== Path
    #
    #    :GET /upload/data_rules
    #
    def data_rules
      # renders static page
    end

    private

    # Returns a string.
    def job_name
      job_data[:name]
    end

    # Returns a string.
    def job_correlation_id
      job_data[:correlation_id]
    end

    # Returns a hash.
    def job_data
      session[:job].transform_keys(&:to_sym)
    end

    # Returns a string.
    def file
      params[:file]
    end

    # Checks if user +aws_status+ equality to 'FORCE_NEW_PASSWORD'.
    def redirect_to_new_password_path
      return unless current_user.aws_status == 'FORCE_NEW_PASSWORD'

      redirect_to new_password_path
    end

    # Checks if session +job+ is present.
    def check_job_data
      return unless session[:job].nil?

      Rails.logger.error 'Job identifier is missing'
      redirect_to root_path
    end

    # Saving job details to session
    def save_details_to_session(job_name, filename, correlation_id)
      session[:job] = {
        name: job_name,
        filename: filename,
        submission_time: submission_time,
        correlation_id: correlation_id
      }
    end

    # Returns current time in a proper format.
    def submission_time
      Time.current.strftime(Rails.configuration.x.time_format)
    end
  end
end
