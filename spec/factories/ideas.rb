RANDOM_HUNDRED_CHARS="hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello worldhello world"
FactoryBot.define do
  factory :idea do
    sequence(:title){ |n| Faker::Educator.university + "#{n}"}
    description{ Faker::Marketing.buzzwords + "#{RANDOM_HUNDRED_CHARS}"}
  end
end
