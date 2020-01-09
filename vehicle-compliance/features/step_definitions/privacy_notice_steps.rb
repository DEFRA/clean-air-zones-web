# frozen_string_literal: true

When('I press Privacy link') do
  within('footer.govuk-footer') do
    click_link 'Privacy'
  end
end
