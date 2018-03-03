module Moyskladsync
  class Sync
    def initialize(source:, destination:)
      @source = source
      @destination = destination
    end

    def start!
      Logger.info('Sync is starting')

      destination.clear
      Logger.info('The destination is cleared')

      rows = products_to_export.sort_by { |p, _| p.full_name }.map(&:to_row)
      destination.add_products(2, rows)
      Logger.info('Products have been exported')

      destination.save
      Logger.info('Sync is finished')
    end

    private

    def products_to_export
      quantities = source.products.each_with_object({}) do |p, hsh|
        product = p.to_product
        hsh[product] = source.quantity(product)
      end

      quantities.select do |p, q|
        q > 0 && p.full_name.include?('ABV')
      end.keys
    end

    attr_reader :source, :destination
  end
end
