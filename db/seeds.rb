# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Idea.delete_all

NUM_IDEAS = 50


NUM_IDEAS.times do
    created_at = Faker::Date.backward(days: 365*5)
 
    p=Idea.create(
        title: Faker::Lorem.sentence(word_count: 3),
        description:Faker::Lorem.sentence(word_count: 100),
        created_at: created_at, 
        updated_at: created_at  
)
if p.valid?

    puts p.errors.full_messages
end
end

ideas = Idea.all

puts Cowsay.say("Generated #{ideas.count} ideas", :dragon)

