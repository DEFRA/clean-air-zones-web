# frozen_string_literal: true

# Used for toggle content for `A-Day`, should be remove once it is no longer needed
module PaymentFeatures
  # Assign +bath_live+ variable
  def assign_payment_enabled
    @payment_features_enabled = payment_features_enabled?
  end

  # Assign +bath_d_day_date+ variable
  def assign_bath_d_day_date
    @bath_d_day_date = bath_d_day_date
  end

  # Returns Bath charge start date
  def bath_d_day_date
    CleanAirZone.all.find { |caz| caz.name == 'Bath' }&.active_charge_start_date
  end

  # Determinate if current user is a beta tester or Bath payments has gone live
  def payment_features_enabled?
    current_user&.beta_tester || bath_live?
  end

  private

  # Checks if the current date is after the Bath payments has gone live
  def bath_live?
    !bath_d_day_date&.future?
  end
end
