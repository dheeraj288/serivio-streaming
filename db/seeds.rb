# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# db/seeds.rb
require 'faker'

Video.destroy_all

genres = %w[Action Drama Comedy Thriller Horror Sci-Fi Romance Fantasy]

10.times do
  Video.create!(
    title: Faker::Movie.title,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    genre: genres.sample,
    release_year: rand(2000..2025),
    thumbnail: "https://res.cloudinary.com/dwmbthmax/image/upload/v1751961183/AdobeStock_1461222253_Preview_mfqocw.jpg",
    video_url: "https://res.cloudinary.com/dwmbthmax/video/upload/v1751960866/AdobeStock_1156039967_Video_HD_Preview_jvypfj.mp4"
  )
end

puts "✅ 10 demo videos with real Cloudinary URLs created!"
