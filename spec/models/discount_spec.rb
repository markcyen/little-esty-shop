require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'validations' do
    [:pct_discount, :threshold].each do |attribute|
      it {should validate_presence_of attribute}
    end
    it {should validate_numericality_of :pct_discount}
    it {should validate_numericality_of(:threshold).only_integer}
  end

  describe 'relationships' do
    it {should belong_to :merchant}
  end
end
