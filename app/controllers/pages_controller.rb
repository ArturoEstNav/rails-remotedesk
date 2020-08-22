class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @tags = Tag.pluck(:name).sort
    if params[:q].present? && params[:job_type].present? && params[:location_type].present?
      @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ? AND location_type = ?", params[:q], params[:job_type], params[:location_type])
    elsif params[:q].present? && params[:location_type].present?
      @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ?", params[:q], params[:location_type])
    elsif params[:q].present? && params[:job_type].present?
      @offers = Offer.joins(:tags).where("tags.name = ? AND job_type = ?", params[:q], params[:job_type])
    elsif params[:q].present?
      @offers = Offer.joins(:tags).where('tags.name = ?', params[:q])
    end
    @params = params[:q]
  end
end
