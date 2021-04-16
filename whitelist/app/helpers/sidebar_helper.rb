# frozen_string_literal: true

##
# Module methods checks if given flow should render link on sidebar in `active` state
# (i.e. 'successfully added' should still mark `Add a vehicle` as active navigation link)
#
module SidebarHelper
  # Sidebar links class name
  ACTIVE_ITEM_CLASS = 'moj-side-navigation__item--active'

  # Returns a 'govuk-header__navigation-item--active' if current path equals a new path.
  def current_path?(path)
    'govuk-header__navigation-item--active' if request.path_info == path
  end

  # Returns a 'moj-side-navigation__item--active' if current path equals a new path.
  def current_active_path?(path)
    ACTIVE_ITEM_CLASS if request.path_info == path
  end

  # Returns a 'moj-side-navigation__item--active' if upload flow include current path
  def upload_flow_active?
    ACTIVE_ITEM_CLASS if [
      authenticated_root_path,
      processing_upload_index_path,
      data_rules_upload_index_path
    ].include?(request.path_info)
  end

  # Returns a 'moj-side-navigation__item--active' if search flow include current path
  def search_flow_active?
    ACTIVE_ITEM_CLASS if [
      vehicles_path,
      historic_search_vehicles_path,
      search_vehicles_path
    ].include?(request.path_info)
  end

  # Returns a 'moj-side-navigation__item--active' if remove vehicle flow include current path
  def remove_vehicle_flow_active?
    ACTIVE_ITEM_CLASS if [
      remove_vehicles_path,
      confirm_remove_vehicles_path
    ].include?(request.path_info)
  end
end
