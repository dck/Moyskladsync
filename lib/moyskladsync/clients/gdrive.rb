module Moyskladsync
  module Clients
    class GdriveItem
      def initialize(row)
        @row = row
      end

      def to_product
        name, abv, og, ibu, ws_price, r_price, *rest = row
        Product.new(
          name: name,
          abv: abv,
          og: og,
          ib: ibu,
          wholesale_price: ws_price,
          retail_price: r_price,
          other: rest
        )
      end

      private

      attr_reader :row
    end

    class Gdrive
      def initialize(secret_json, spreadsheet_id)
        @secret_json = secret_json
        @spreadsheet_id = spreadsheet_id
      end

      def products
        Enumerator.new do |yielder|
          worksheet.rows.drop(1).each do |row|
            yielder << GdriveItem.new(row).to_product
          end
        end
      end

      private

      def worksheet
        session = GoogleDrive::Session.from_service_account_key(secret_json)
        session.spreadsheet_by_key(spreadsheet_id).worksheets.first
      end

      attr_reader :secret_json, :spreadsheet_id
    end
  end
end
