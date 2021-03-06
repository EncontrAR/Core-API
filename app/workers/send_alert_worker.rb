class SendAlertWorker
  	include Sidekiq::Worker
  	include GeoSearchHelper

	def perform(alert_id, campaign_id)
		alert = Alert.find_by_id(alert_id)
		campaign = Campaign.find_by_id(campaign_id)
		return unless alert.present? && campaign.present?

		finders = GeoSearchHelper.search_finders_by_zone(alert.zone)
		message_content = { message: CampaignSerializer.new(campaign), alert_id: alert.id }

		finders.each do |finder| 
			Wor::Push::Notifications::Aws.send_message(finder, message_content)
		end

		alert.notifications_sent = finders.size
		alert.save
	end
end
