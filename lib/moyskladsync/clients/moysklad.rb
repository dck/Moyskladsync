module Moyskladsync
  module Clients
    class MoyskladItem
      def initialize(payload)
        @payload = payload
      end

      def to_product
        Product.new(
          id: id,
          name: name,
          wholesale_price: wholesale_price,
          retail_price: retail_price,
          other: []
        )
      end

      private

      def id
        payload['id']
      end

      def name
        payload['name']
      end

      def wholesale_price
        normalized_price(payload['buyPrice']['value'])
      end

      def retail_price
        price = payload['salePrices'].find { |p| p['priceType'] == 'Цена продажи' }
        normalized_price(price['value']) if price
      end

      def normalized_price(price)
        price.to_i / 100
      end

      attr_reader :payload
    end

    class Moysklad
      PRODUCT_ENDPOINT = 'https://online.moysklad.ru/api/remap/1.1/entity/product'.freeze
      STOCK_ENDPOINT = 'https://online.moysklad.ru/api/remap/1.1/report/stock/all'.freeze
      STEP = 100

      def initialize(login, password)
        @login = login
        @password = password
      end

      def products
        offset = 0
        Enumerator.new do |yielder|
          loop do
            items = get_json(page_url(offset, STEP))['rows']
            break if items.size.zero?
            items.each do |item|
              yielder << MoyskladItem.new(item)
            end
            offset += STEP
          end
        end
      end

      def quantity(product)
        url = stock_url(product.id)
        get_json(url)['rows']&.first&.[]('stock') || 0.0
      end

      private

      def get_json(url)
        response = RestClient::Request.new(
          method: :get,
          url: url,
          user: login,
          password: password,
          headers: { accept: :json, content_type: :json }
        ).execute

        JSON.parse(response.body)
      end

      def page_url(offset, limit)
        "#{PRODUCT_ENDPOINT}?offset=#{offset}&limit=#{limit}"
      end

      def stock_url(id)
        "#{STOCK_ENDPOINT}?product.id=#{id}"
      end

      attr_reader :login, :password
    end
  end
end
