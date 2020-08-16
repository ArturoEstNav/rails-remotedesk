class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @tags = Tag.pluck(:name).sort
    if params[:q].present?
      @offers = Offer.joins(:tags).where('tags.name = ?', params[:q])
    end
    @params = params[:q]
  end
end
