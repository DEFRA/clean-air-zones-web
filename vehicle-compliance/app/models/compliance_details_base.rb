# frozen_string_literal: true

##
# This module is used to display data in +app/views/air_zones/compliance.html.haml+.
module ComplianceDetailsBase
  # Depend on CAZ name and charging date returns a proper value
  # Returns a string, e.g. '15 March 2021'
  def charging_starts
    case zone_name
    when 'Bath'
      'Now'
    when 'Birmingham'
      caz_live_in_future?(birmingham_live_date) ? birmingham_live_date : 'Now'
    else
      'Early 2021'
    end
  end

  private

  # Birmingham charge live date
  def birmingham_live_date
    '1 June 2021'
  end

  # Checks if a date charging is live
  def caz_live_in_future?(date)
    Date.parse(date).future?
  end
end
