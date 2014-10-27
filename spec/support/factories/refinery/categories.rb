
FactoryGirl.define do
  factory :category, :class => Refinery::Products::Category do
    sequence(:title) { |n| "refinery#{n}" }
  end
end

