# frozen_string_literal: true

module AddToRedis
  def add_caz_lock_to_redis(user, user_id: user.user_id)
    REDIS.hmset(caz_lock_redis_key,
                'account_id', user.account_id,
                'user_id', user_id,
                'caz_id', caz_id,
                'email', user.email)
  end

  def add_upload_job_to_redis(job_id: SecureRandom.uuid, correlation_id: SecureRandom.uuid, large_fleet: true)
    REDIS.hmset(
      upload_job_redis_key,
      'job_id', job_id,
      'correlation_id', correlation_id,
      'large_fleet', large_fleet
    )
  end

  private

  def caz_lock_redis_key
    "caz_lock_#{user.account_id}_#{caz_id}"
  end
end
