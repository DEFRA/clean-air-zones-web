# frozen_string_literal: true

Given('I am on the Export to CSV page') do
  sign_in_user
  visit export_vehicles_path
end

When('I press Export button') do
  allow(WhitelistApi).to receive(:csv_exports).and_return(read_file('csv_exports.json')['fileUrl'])
  click_on 'Export'
end
