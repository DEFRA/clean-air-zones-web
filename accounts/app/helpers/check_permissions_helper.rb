# frozen_string_literal: true

# Module used to check user permissions in views
module CheckPermissionsHelper
  include CheckPermissions

  # Checks if created user has a +permission+
  def checked_permission?(permission)
    new_user_permission = session.dig(:new_user, 'permissions')
    return if new_user_permission.nil?

    new_user_permission.include?(permission)
  end

  # Checks if edited user has a +permission+
  def edit_user_permission?(permission)
    edit_user_permission = session.dig(:edit_user, 'permissions')
    return if edit_user_permission.nil?

    edit_user_permission.include?(permission)
  end
end
