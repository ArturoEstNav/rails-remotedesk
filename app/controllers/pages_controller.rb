class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :about]

  def home
    @tags = Tag.pluck(:name).sort
    @new_offers = Offer.last(6)
    # If remote or home office job and part and full time is selected
    if params[:q].present? && params[:job_type].present? && params[:location_type].present?
      if params[:sort] == "1"
        @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ? AND location_type = ?", params[:q], params[:job_type], params[:location_type]).order( posting_date: :desc)
      else
        @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ? AND location_type = ?", params[:q], params[:job_type], params[:location_type]).order( posting_date: :asc)
      end
    # If remote or home office job is selected
    elsif params[:q].present? && params[:location_type].present?
      if params[:sort] == "1"
        @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ?", params[:q], params[:location_type]).order( posting_date: :desc)
      else
        @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ?", params[:q], params[:location_type]).order( posting_date: :asc)
      end
    # If full or partial time is selected
    elsif params[:q].present? && params[:job_type].present?
      if params[:sort] == "1"
        @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ?", params[:q], params[:job_type]).order( posting_date: :desc)
      else
        @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ?", params[:q], params[:job_type]).order( posting_date: :asc)
      end
    # If no options are selected
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
