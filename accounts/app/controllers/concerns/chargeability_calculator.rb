# frozen_string_literal: true

# Module used to check upload job status
module ChargeabilityCalculator
  private

  # Checks job status and depends on it adding a flash message and redirects to proper page
  # Clears job data from redis if api returns 404 error
  def check_job_status
    return unless job_id && job_correlation_id && large_fleet

    status = FleetsApi.job_status(job_id: job_id, correlation_id: job_correlation_id)[:status].upcase
    handle_job_status(status)
  rescue BaseApi::Error404Exception
    clear_upload_job_data
  end

  # Adding hash to redis
  def add_data_to_redis(correlation_id, job_id, large_fleet)
    REDIS.hmset(account_id_redis_key,
                'job_id', job_id,
                'correlation_id', correlation_id,
                'large_fleet', large_fleet)
  end

  # Handles controller reaction based on the given job status
  def handle_job_status(status)
    case status
    when 'SUCCESS'
      assign_flash_message
    when 'CHARGEABILITY_CALCULATION_IN_PROGRESS'
      redirect_to calculating_chargeability_uploads_path
    when 'RUNNING'
      redirect_to processing_uploads_path
    else
      clear_upload_job_data
    end
  end

  # Returns job_id for pending job
  def job_id
    REDIS.hget(account_id_redis_key, 'job_id')
  end

  # Returns correlation_id for pending job
  def job_correlation_id
    REDIS.hget(account_id_redis_key, 'correlation_id')
  end

  # Returns large_fleet status for pending job, e.g. 'true'
  def large_fleet
    REDIS.hget(account_id_redis_key, 'large_fleet')
  end

  # Clears pending job data for current user
  def clear_upload_job_data
    REDIS.del(account_id_redis_key)
  end

  # Returns string, e.g. 'account_id_214e8858-5f61-44be-b17d-571a94bee1b0'
  def account_id_redis_key
    "account_id_#{current_user.account_id}"
  end

  # Assign flash message only if user want to visit the fleets page
  def assign_flash_message
    return unless request.path.include?(fleets_path)

    flash.now[:success] = I18n.t(
      'vrn_form.messages.multiple_vrns_added',
      vrns_count: @fleet.total_vehicles_count
    )
  end
end
