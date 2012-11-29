class GocardlessController < ApplicationController
  def index
  end

  def buy
    url = GoCardless.new_bill_url(amount: params[:amount], name: params[:name])
    redirect_to(url)
  end

  def subscribe
    url = GoCardless.new_subscription_url(
      amount: params[:amount],
      interval_unit: params[:interval_unit],
      interval_length: params[:interval_length],
      name: params[:name]
    )
    redirect_to(url)
  end

  def preauth
    url = GoCardless.new_pre_authorization_url(
      amount: params[:amount],
      interval_length: params[:interval_length],
      interval_unit: params[:interval_unit],
      name: params[:name]
    )
    redirect_to(url)
  end

  def confirm
    begin
      GoCardless.confirm_resource params
      render "gocardless/success"
    rescue GoCardless::ApiError => e
      @error = e
      render "gocardless/error"
    end
  end

  def success
  end

  def error
  end

  def webhook
    webhook_data = params[:payload]

    if GoCardless.webhook_valid?(webhook_data)
      puts webhook_data.inspect
      # do something with request_data, save to DB, log etc
    else
      # log the error
    end

    render nothing: true, status: 200
  end
end
