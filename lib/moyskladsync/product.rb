module Moyskladsync
  Product = KeywordStruct.new(:id, :full_name, :wholesale_price, :retail_price) do
    def brewery
      full_name.match(/(.+?)\s+-/)[1]
    end

    def name
      title_substring.match(/-\s+(.+)/)[1]
    end

    def style
      options_substring.match(/(.+?)\./)[1].strip
    end

    def to_row
      [brewery, name, style]
    end

    private

    def options_substring
      full_name[full_name.rindex('(')+1...full_name.size-1]
    end

    def title_substring
      full_name[0...full_name.rindex('(')-1]
    end
  end
end
