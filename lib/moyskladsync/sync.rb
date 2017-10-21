module Moyskladsync
  class Sync
    def initialize(source:, destination:)
      @source = source
      @destination = destination
    end

    def start
    end

    private

    def source_products
      source.products.to_a
    end

    def destination_products
      destination.products.to_a
    end

    attr_reader :source, :destination
  end
end
