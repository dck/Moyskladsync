require 'minitest/autorun'
require 'minitest/spec'
require_relative '../lib/moyskladsync'

module Moyskladsync
  describe Product do
    describe '#full_name' do
      it 'returns a set full name' do
        p = Product.new(full_name: 'Bear')
        assert_equal 'Bear', p.full_name
      end
    end

    describe '#brewery' do
      it 'returns a beer brewery' do
        p = Product.new(full_name: 'Jaws - Cafe Raser (Brown Ale - Belgian. OG 15%, ABV 5,5% IBU 20)')
        assert_equal 'Jaws', p.brewery
      end

      it 'respects long brewery names' do
        p = Product.new(full_name: 'G. Menabrea & Figli - Menabrea Ambrata (Marzen. ABV 5%)')
        assert_equal 'G. Menabrea & Figli', p.brewery
      end
    end

    describe '#name' do
      it 'returns a beer title' do
        p1 = Product.new(full_name: 'Бакунин - All In: Citra (Sour - Ale. OG 14%, ABV 6%, IBU 20)')
        assert_equal 'All In: Citra', p1.name

        p2 = Product.new(full_name: 'HopHead - Прощай Лето (клубника) (IPA - American. OG 17.5)')
        assert_equal 'Прощай Лето (клубника)', p2.name
      end
    end

    describe '#style' do
      it 'returns a beer style' do
        p1 = Product.new(full_name: 'Бакунин - All In: Citra (Sour - Ale. OG 14%, ABV 6%, IBU 20)')
        assert_equal 'Sour - Ale', p1.style

        p2 = Product.new(full_name: 'HopHead - Прощай Лето (клубника) (IPA - American. OG 17.5)')
        assert_equal 'IPA - American', p2.style
      end
    end

    describe '#to_row' do
      it 'returns an array of properties' do
        p = Product.new(full_name: "Salden's - 4С AIPA (IPA - American. ABV 6,8%, IBU 60)")
        assert_equal ["Salden's", '4С AIPA', 'IPA - American'], p.to_row
      end
    end
  end
end
