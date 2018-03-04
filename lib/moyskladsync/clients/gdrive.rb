module Moyskladsync
  module Clients
    class Gdrive
      def initialize(secret_json, spreadsheet_id)
        @secret_json = secret_json
        @spreadsheet_id = spreadsheet_id
      end

      def add_products(products)
        worksheet.update_cells(2, 1, products)
      end

      def save
        worksheet.save
      end

      def clear
        worksheet.delete_rows(2, worksheet.max_rows - 1)
      end

      private

      def worksheet
        @_worksheet ||= begin
          session = GoogleDrive::Session.from_service_account_key(secret_json)
          session.spreadsheet_by_key(spreadsheet_id).worksheets.first
        end
      end

      attr_reader :secret_json, :spreadsheet_id
    end
  end
end
