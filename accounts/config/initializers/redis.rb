# frozen_string_literal: true

REDIS = if Rails.env.production? && ENV['REDIS_URL']
          Redis.new(cluster: [ENV['REDIS_URL']])
        else
          Redis.new
        end
