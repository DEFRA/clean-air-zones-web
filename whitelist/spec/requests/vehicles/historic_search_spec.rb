# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - GET #historic_search', type: :request do
  subject { get historic_search_vehicles_path }
  before do
    add_to_session(vrn: 'CU57ABC')
    sign_in new_user
  end
  context 'search results are not empty' do
    before do
      mock_vrn_history
      subject
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the view' do
      expect(response).to render_template(:historic_search)
    end
  end

  context 'search results is empty' do
    before do
      empty_history = instance_double(HistoricalVrnDetails,
                                      pagination: [],
                                      total_changes_count_zero?: true,
                                      changes_empty?: true,
                                      parsed_start_date: '10/03/2020',
                                      parsed_end_date: '14/03/2020')
      allow(HistoricalVrnDetails).to receive(:new).and_return(empty_history)
      subject
    end

    it 'returns a found response' do
      expect(response).to have_http_status(:found)
    end

    it 'redirects to the search vehicles page' do
      expect(response).to redirect_to(search_vehicles_path)
    end
  end
end

private

def mock_vrn_history
  allow(HistoricalVrnDetails).to receive(:new).and_return(instance_double(HistoricalVrnDetails,
                                                                          pagination: paginated_history,
                                                                          total_changes_count_zero?: false,
                                                                          changes_empty?: false))
end

def paginated_history
  instance_double(
    PaginatedVrnHistory,
    vrn_changes_list: mocked_changes,
    page: 1,
    total_pages: 2,
    range_start: 1,
    range_end: 10,
    total_changes_count: 12
  )
end

def mocked_changes
  vehicles_data = read_file('whitelist_info_historical_response.json')['1']['changes']
  vehicles_data.map { |data| VrnHistory.new(data) }
end
