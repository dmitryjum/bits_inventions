FactoryBot.define do
  factory :invention do
    title { 'Robot' }
    description { 'suffisticated robot '}
    user_name { FFaker::Name.name }
    user_email { FFaker::Internet.email }
    bits { {'branch' => 1, 'bright-led' => 1, 'button' => 2} }
    materials { ['scissors'] }
  end
end