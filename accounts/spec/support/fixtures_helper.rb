# frozen_string_literal: true

module FixturesHelper
  def mocked_vrn
    'ABC123'
  end

  def mocked_uuid
    '5cd7441d-766f-48ff-b8ad-1809586fea37'
  end

  # Reads provided file from +spec/fixtures/responses+ directory and parses it to JSON
  def read_response(filename)
    JSON.parse(read_unparsed_response(filename))
  end

  # Reads provided file from +spec/fixtures/responses+ directory
  def read_unparsed_response(filename)
    File.read("spec/fixtures/responses/#{filename}")
  end
end
