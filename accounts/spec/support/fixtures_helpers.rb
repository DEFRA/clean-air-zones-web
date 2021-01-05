# frozen_string_literal: true

module FixturesHelpers
  # Reads provided file from +spec/fixtures/responses+ directory and parses it to JSON
  def read_response(filename)
    JSON.parse(read_unparsed_response(filename))
  end

  # Reads provided file from +spec/fixtures/responses+ directory
  def read_unparsed_response(filename)
    File.read("spec/fixtures/responses/#{filename}")
  end
end
