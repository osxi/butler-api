class WebsitesController < ApplicationController
	skip_before_action :authenticate!, only: :ping_now

  def index
    @websites = Website.all
    @website = Website.new
  end

  def create
    @website = Website.new(website_params)
    if @website.save
    	@website.ping_now
    	redirect_to :index, notice: 'Website added'
    else
    	redirect_to :index, alert: @website.errors.full_messages.join('. ')
    end
  end

  def ping_now
  	website = Website.find(params[:id])
  	website.ping_url
  	redirect_to :back, notice: website.url + ' pinged'
  end

  private

  def website_params
    params[:website].permit(
      :name,
      :url
    )
  end

end
