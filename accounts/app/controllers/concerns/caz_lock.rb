# frozen_string_literal: true

# Module used to add or release a lock on CAZ if user is paying for it
module CazLock
  # Determinate if lock on caz should release, then adding a new selected caz to the session
  # Redirects to payment in progress page if selected caz already in paying progress by another user
  # Or lock CAZ and redirects to the matrix page
  def determinate_lock_caz(caz_id)
    release_lock_on_caz if caz_id_in_session
    SessionManipulation::AddCazId.call(session: session, caz_id: caz_id)
    if caz_locked?
      redirect_to in_progress_payments_path
    else
      lock_caz(caz_id)
      redirect_to determine_next_page(caz_id)
    end
  end

  # Checks if selected caz locked
  def caz_locked?
    return false if current_user.user_id == caz_lock_user_id
    return false if current_user.account_id != caz_lock_account_id

    redis_value('caz_id') == caz_id_in_session
  end

  # Adds a lock on CAZ if user is paying for it
  def lock_caz(caz_id)
    REDIS.hmset(caz_lock_redis_key,
                'account_id', current_user.account_id,
                'user_id', current_user.user_id,
                'caz_id', caz_id,
                'email', current_user.email)
    REDIS.expire(caz_lock_redis_key, 900)
  end

  # Removes a lock on CAZ if user is paying for it
  def release_lock_on_caz
    REDIS.del(caz_lock_redis_key) if current_user_payment?
  end

  private

  # Returns redis value for current +field+ key
  def redis_value(field)
    REDIS.hget(caz_lock_redis_key, field)
  end

  # Returns string, e.g. "caz_lock_aba44322-38bf-43f7-96d0-4a1afa9f4963_5cd7441d-766f-48ff-b8ad-1809586fea37"
  def caz_lock_redis_key
    "caz_lock_#{current_user&.account_id}_#{caz_id_in_session}"
  end

  # Returns CAZ UUID from the session
  def caz_id_in_session
    helpers.new_payment_data[:caz_id] || helpers.initiated_payment_data[:caz_id]
  end

  # Checks if current user is locked caz
  def current_user_payment?
    current_user&.user_id == caz_lock_user_id
  end

  # Returns user_id for Caz lock process
  def caz_lock_user_id
    redis_value('user_id')
  end

  # Returns account_id for Caz lock process
  def caz_lock_account_id
    redis_value('account_id')
  end
end
