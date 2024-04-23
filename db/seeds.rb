# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "json"

ActiveStorage::AnalyzeJob.queue_adapter = :inline
ActiveStorage::PurgeJob.queue_adapter = :inline

if Rails.env.development? || Rails.env.test?

  TEST_GMAIL_ACCOUNT_NAME = ENV["TEST_GMAIL_ACCOUNT_NAME"]
  TEST_PASSWORD = ENV["TEST_PASSWORD"]
  TEST_TELEPHONE_NUMBER = ENV["TEST_TELEPHONE_NUMBER"]

  File.open(Rails.root.join("app/assets/seeds", "initial_users.json")) do |file|
    data = JSON.load(file)
    data.each.with_index(1) do |user, i|
      user["email"] = "#{TEST_GMAIL_ACCOUNT_NAME}+test#{i}@gmail.com"
      user["telephone_number"] = TEST_TELEPHONE_NUMBER
      user["password"] = TEST_PASSWORD
      user["password_confirmation"] = TEST_PASSWORD
      new_user = User.create(user)
      new_user.image.attach(
        io: File.open(Rails.root.join("app/assets/seeds", "images/user_#{i}.jpg")),
        filename: "user_#{i}.jpg"
      )
    end
  end

  File.open(Rails.root.join("app/assets/seeds", "initial_projects.json")) do |file|
    data = JSON.load(file)
    Project.create(data)
  end

  File.open(Rails.root.join("app/assets/seeds", "initial_tags.json")) do |file|
    data = JSON.load(file)
    Tag.create(data)
  end

  File.open(Rails.root.join("app/assets/seeds", "initial_taggings.json")) do |file|
    data = JSON.load(file)
    Tagging.create(data)
  end

  File.open(Rails.root.join("app/assets/seeds", "initial_posts.json")) do |file|
    data = JSON.load(file)
    data.each.with_index(1) do |element, i|
      new_element = Post.create(element)
      new_element.image.attach(
        io: File.open(Rails.root.join("app/assets/seeds", "images/post_#{i}.jpg")),
        filename: "post_#{i}.jpg"
      )
    end
  end

end

Admin.create(
  email: 'admin@mail',
  password: 'administrator',
  password_confirmation: "administrator"
)
