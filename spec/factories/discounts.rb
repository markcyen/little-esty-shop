FactoryBot.define do
  factory :discount do
    pct_discount { "9.99" }
    threshold { 1 }
    merchant { nil }
  end
end
