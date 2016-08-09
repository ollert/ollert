require 'active_support/core_ext/hash/keys'
require 'faker'

FactoryGirl.define do
  factory :trello_list, class: Trello::List do
    initialize_with { new(attributes.stringify_keys) }

    id { SecureRandom.uuid }
    name { Faker::StarWars.planet }
    closed false
  end
end
