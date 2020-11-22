class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :about]

  def home
    @tags = Tag.pluck(:name).sort
    @new_offers = Offer.last(6)
    if params[:q].present? && params[:job_type].present? && params[:location_type].present?
      # Current working code
        # @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ? AND location_type = ?", params[:q], params[:job_type], params[:location_type])
      # Current working code
      if params[:sort] == "1"
        @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ? AND location_type = ?", params[:q], params[:job_type], params[:location_type]).order( posting_date: :desc)
      else
        @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ? AND location_type = ?", params[:q], params[:job_type], params[:location_type]).order( posting_date: :asc)
      end

    elsif params[:q].present? && params[:location_type].present?
      # Current working code
        # @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ?", params[:q], params[:location_type])
      # Current working code
      if params[:sort] == "1"
        @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ?", params[:q], params[:location_type]).order( posting_date: :desc)
      else
        @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ?", params[:q], params[:location_type]).order( posting_date: :asc)
      end

    elsif params[:q].present? && params[:job_type].present?
      # Current working code
        # @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ?", params[:q], params[:job_type])
      # Current working code
      if params[:sort] == "1"
        @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ?", params[:q], params[:job_type]).order( posting_date: :desc)
      else
        @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ?", params[:q], params[:job_type]).order( posting_date: :asc)
      end

    elsif params[:q].present?
      # Current working code
        @offers = Offer.joins(:tags).where('tags.name = ?', params[:q])
      # Current working code
    end
    @query = params[:q]
    @job_type = params[:job_type]
    @location_type = params[:location_type]
    @match = Match.new
  end

  def about; end
end

# .order( posting_date: :desc)
# .order( posting_date: :asc)
