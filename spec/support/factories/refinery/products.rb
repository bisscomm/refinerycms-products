
FactoryGirl.define do
  factory :product, :class => Refinery::Products::Product do
    sequence(:title) { |n| "refinery#{n}" }
  end
end

