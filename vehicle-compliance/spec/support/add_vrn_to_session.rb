# frozen_string_literal: true

module AddVrnToSession
  def add_vrn_to_session(data = { vrn: 'CU57ABC', country: 'UK', checked_zones: [] })
    encoded_data = RackSessionAccess.encode(data)
    put RackSessionAccess.path, params: { data: encoded_data }
  end
end
