# frozen_string_literal: true

module ParsedResponse
  #:nocov:
  def json_response
    JSON.parse(response.body)
  end

  def xml_response
    Hash.from_xml(response.body)
  end
  #:nocov:
end
