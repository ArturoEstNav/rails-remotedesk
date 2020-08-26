class UsersController < ApplicationController
  def show
    saved_enum = current_user.offers.each_slice(3)
    @saved = saved_enum.to_a

    suggested_offers = []
    current_user.tags.each do |tag|
      suggested_offers << tag.offers
    end
    suggested_offers.flatten!
    suggested_offers = suggested_offers.reject { |offer| current_user.offers.include?(offer) }
    suggested_enum = suggested_offers.sample(12).each_slice(3)
    @suggested = suggested_enum.to_a
  end

  def edit
    @tags = Tag.all
  end

  def update
    if current_user.update(user_params)
      params[:user][:tags].shift
      tag_ids = params[:user][:tags]
      tag_ids.each do |tag_id|
        if current_user.tags.include?(Tag.find(tag_id))
        else
          current_user.tags << Tag.find(tag_id)
        end
      end
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :gender,
                                 :residence_country, :postal_code)
  end
end
