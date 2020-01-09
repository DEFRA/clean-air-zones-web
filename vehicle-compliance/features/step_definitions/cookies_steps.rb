# frozen_string_literal: true

When('I press Cookies link') do
  within('footer.govuk-footer') do
    click_link 'Cookies'
  end
end
