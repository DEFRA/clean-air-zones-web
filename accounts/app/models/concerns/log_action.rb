# frozen_string_literal: true

# Used to log actions
module LogAction
  # Logs message on +info+ level
  def log_action(msg)
    Rails.logger.info("[#{self.class.name}] #{msg}")
  end
end
