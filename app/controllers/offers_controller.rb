require 'open-uri'
require 'nokogiri'
require 'json'

class OffersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_offer, only: [:show, :edit, :update, :destroy]

  def show
    @match = Match.new
  end

  def new
    @offer = Offer.new
    @tags = Tag.all
  end

  def create
    @offer = Offer.new(offer_params)
    @offer.source = current_user.id.to_s
    @offer.posting_date = DateTime.now()
    if @offer.save
      if params[:offer][:tags].class == Array
        params[:offer][:tags].shift
      end
      tag_ids = Array.new
      if params[:offer][:tags].class == Array
        params[:offer][:tags].each do |tag_name|
          tag_ids << tag_name
        end
      else
        tag_ids << params[:offer][:tags]
      end
      tag_ids.each do |tag_id|
        unless @offer.tags.include?(Tag.find(tag_id))
          @offer.tags << Tag.find(tag_id)
        end
      end
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @offer.update(offer_params)
      params[:offer][:tags].shift
      tag_ids = params[:offer][:tags]
      tag_ids.each do |tag_id|
        unless @offer.tags.include?(Tag.find(tag_id))
          @offer.tags << Tag.find(tag_id)
        end
      end
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  def destroy
    @offer.destroy
    redirect_to user_path(current_user)
  end

  def set_offer
    @offer = Offer.find(params[:id])
  end

  private

  def offer_params
    params.require(:offer).permit(:company, :title, :description, :position,
                                  :salary, :category, :job_type, :location,
                                  :posting_date, :source, :location_type)
  end
end
