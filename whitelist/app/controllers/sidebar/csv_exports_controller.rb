# frozen_string_literal: true

##
# Module used to show sidebar only for proper controllers
module Sidebar
  ##
  # Controller class for downloading a csv file
  #
  class CsvExportsController < BaseController
    ##
    # Download a csv file from AWS S3.
    #
    # ==== Path
    #
    #    :GET /vehicles/export
    #
    def export
      render 'sidebar/vehicles/export'
    end

    ##
    # Download a csv file from AWS S3.
    #
    # ==== Path
    #
    #    :GET /vehicles/download_csv
    #
    def download_csv
      file_url = WhitelistApi.csv_exports
      redirect_to file_url
    end
  end
end
