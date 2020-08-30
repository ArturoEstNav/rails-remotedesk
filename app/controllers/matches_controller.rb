class MatchesController < ApplicationController
  def create
    @match = Match.new(match_params)
    @match.user = current_user
    if @match.save
      redirect_to user_path(current_user)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def match_params
    params.require(:match).permit(:offer_id)
  end
end
