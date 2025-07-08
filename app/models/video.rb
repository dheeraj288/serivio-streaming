class Video < ApplicationRecord
	def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "genre", "id", "id_value", "release_year", "thumbnail", "title", "updated_at", "video_url"]
  end
end
