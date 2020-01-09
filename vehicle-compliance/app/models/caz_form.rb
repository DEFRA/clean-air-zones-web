# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/air_zones/caz_selection.html.haml+.
class CazForm < BaseForm
  ##
  # Validate user data.
  #
  # Returns a boolean.
  def valid?
    chosen?
  end

  private

  # Checks if at least one 'Clean Air Zone' was selected.
  #
  # Returns a boolean.
  def chosen?
    if !parameter.is_a?(Array) || parameter.reject(&:empty?).blank?
      @message = I18n.t('caz_selection_form.la_missing')
      false
    else
      true
    end
  end
end
