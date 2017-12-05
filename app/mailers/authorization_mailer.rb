class AuthorizationMailer < ApplicationMailer
  def confirmation
    @auth = Authorization.find(params[:id])

    mail to: @auth.user.email
  end
end
