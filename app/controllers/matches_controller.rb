class MatchesController < ApplicationController
  def index
    # @matches = Match.where(user: current_user)
    @offers = []
    Offer.all.each do |offer|
      if offer.user == current_user { @offers << offer }
    end
  end

  def create
    # @match = Match.new()
    # @match.user = current_user
    # @offer = Offer.find(params()) (this on button )
    # @match.offer = @offer
    # @match.save
    # redirect_to users_path(current_user)
  end

  def destroy
    # @match = Match.find(params[:id])
    # @match.destroy
    # redirect_to users_path(current_user)
  end
end
