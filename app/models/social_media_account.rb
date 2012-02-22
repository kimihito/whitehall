class SocialMediaAccount < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :social_media_service

  validates :social_media_service_id, presence: true
  validates :url, presence: true, format: URI::regexp(%w(http https))
end
