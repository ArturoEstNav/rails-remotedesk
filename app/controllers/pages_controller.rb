class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :about]

  def home
    @tags = Tag.pluck(:name).sort
    @new_offers = Offer.last(6)
    if params[:q].present? && params[:job_type].present? && params[:location_type].present?
      @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ? AND location_type = ?", params[:q], params[:job_type], params[:location_type])
    elsif params[:q].present? && params[:location_type].present?
      @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ?", params[:q], params[:location_type])
    elsif params[:q].present? && params[:job_type].present?
      @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ?", params[:q], params[:job_type])
    elsif params[:q].present?
      @offers = Offer.joins(:tags).where('tags.name = ?', params[:q])
    end
    @query = params[:q]
    @job_type = params[:job_type]
    @location_type = params[:location_type]
    @match = Match.new
  end

  def about; end
end

# for each search made through dashboard default newest sort will be shown
#unless params[:sort] is oldest ASC order will be placed

# SELECT billing_date,
# FROM collection
# ORDER BY billing_date ASC;

