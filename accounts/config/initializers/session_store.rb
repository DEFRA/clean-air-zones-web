# frozen_string_literal: true

timeout_in_mins = Rails.configuration.x.session_timeout_in_min.minutes
store_type = ENV['REDIS_URL'] && !Rails.env.test? ? :cache_store : :cookie_store
Rails.application.config.session_store store_type,
                                       key: '_caz_fleets_session',
                                       expire_after: timeout_in_mins,
                                       same_site: :lax,
                                       secure: Rails.env.production?
