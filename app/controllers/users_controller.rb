class UsersController < ApplicationController
  def show
    @matches = Match.where(user: current_user)
  end

  def edit
    @tags = Tag.all
  end

  def update
    if current_user.update(user_params)
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :gender, :residence_country, :postal_code)
  end
end
