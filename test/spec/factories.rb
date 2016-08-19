require 'active_support/core_ext/hash/keys'
require 'faker'

FactoryGirl.define do
  factory :trello_list, class: Trello::List do
    initialize_with { new(attributes.stringify_keys) }

    id { SecureRandom.uuid }
    name { Faker::StarWars.planet }
    closed false
  end

  factory :trello_card, class: Trello::Card do
    initialize_with { new(attributes.stringify_keys) }

    id { SecureRandom.uuid }
    name { Faker::StarWars.quote }
    closed false
  end
end
