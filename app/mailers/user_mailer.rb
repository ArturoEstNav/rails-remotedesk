include Rails.application.routes.url_helpers

class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.matches.subject
  #
  def matches
    @user = params[:user]

    suggested_offers = []
    @user.tags.each do |tag|
      suggested_offers << tag.offers
    end
    suggested_offers.flatten!
    suggested_offers = suggested_offers.reject { |offer| @user.offers.include?(offer) }
    suggested_enum = suggested_offers.sample(3)
    @suggested = suggested_enum.to_a

    mail(
      to: @user.email,
      subject: "#{@user.first_name}! You are a great match for this jobs!"
    )
  end
end
