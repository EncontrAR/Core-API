module V1
	class CampaignsController < PublicController
		include Wor::Paginate

		def show
 			campaign = Campaign.find(params[:id])
 			render json: campaign
		end

		def index_all
 			render_paginated Campaign.where(status: :actived).order("updated_at DESC"), each_serializer: CampaignSerializer
		end
	end
end