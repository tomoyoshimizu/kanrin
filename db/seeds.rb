# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveStorage::AnalyzeJob.queue_adapter = :inline
ActiveStorage::PurgeJob.queue_adapter = :inline

if Rails.env.development? || Rails.env.test?

  40.times {

    new_user = User.find_or_create_by!(email: Faker::Internet.unique.email) do |user|
      user.name = Faker::Name.unique.name
      user.telephone_number = Faker::Number.unique.leading_zero_number(digits: 11)
      user.password = SecureRandom.urlsafe_base64
      user.image.attach(
        io: File.open(Rails.root.join("app/assets/images/user_placeholder.png")),
        filename: "user_placeholder.png",
        content_type: "image/png"
      )
    end

    new_project = new_user.projects.create!(
      title: "テスト#{new_user.id}",
      description: "#{new_user.name}が作成したプロジェクトです。"
    )

    new_project.posts.create!(
      body: "#{new_user.name}の投稿です。",
      working_minutes: rand(1..120)
    )

    rand(1..5).times {
      new_tag = Tag.find_or_create_by!(name: Faker::Adjective.positive)
      new_tag.taggings.find_or_create_by!(project_id: new_project.id)
    }

  }

end

Admin.find_or_create_by!(email: "admin@mail.com") do |admin|
  admin.password = "administrator"
end
