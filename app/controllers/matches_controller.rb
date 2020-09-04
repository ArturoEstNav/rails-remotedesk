class MatchesController < ApplicationController
  def create
    @match = Match.new(offer_id: params[:offer_id])
    @match.user = current_user
    @match.save
    if !params[:q].empty?
      redirect_to "#{params[:redirect_url]}?q=#{params[:q]}&commit=Search#card-#{params[:offer_id]}"
    else
      redirect_to "#{params[:redirect_url]}#card-#{params[:offer_id]}"
    end
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy
    if !params[:q].empty?
      redirect_to "#{params[:redirect_url]}?q=#{params[:q]}&commit=Search#card-#{@match.offer.id}"
    else
      redirect_to "#{params[:redirect_url]}#card-#{@match.offer.id}"
    end
  end
end
