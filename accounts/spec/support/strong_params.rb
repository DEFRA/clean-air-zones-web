# frozen_string_literal: true

module StrongParams
  def strong_params(params)
    ActionController::Parameters.new(params).permit!
  end
end
