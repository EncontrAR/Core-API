class Campaign < ApplicationRecord
	belongs_to :user
	belongs_to :missing_person
	has_many :alerts
	has_many :campaign_images
	has_many :conversations
	has_many :finders, through: :conversations

	validates :title, :description, :user, presence: true

	before_update :log_status_change, if: :status_changed?

	enum status: { actived: 0, deactivated: 1, expired: 2, success: 3 }

	def images
		campaign_images.map { |element| element.url }
	end

	def last_zone
		alerts.order(:created_at).last.zone unless alerts.empty?
	end

	def log_status_change
		log = CampaignLog.create(campaign: self, old_status: status_was, new_status: status)
		log.save
	end
end
