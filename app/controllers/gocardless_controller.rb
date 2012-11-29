class GocardlessController < ApplicationController
  def index
  end

  # More information on the billing process is located at:
  # https://gocardless.com/docs/ruby/merchant_client_guide#starting-the-billing-process

  # Generate a URL for a one-off payment and redirect to it
  def buy
    url = GoCardless.new_bill_url(amount: "10", name: "One-off purchase")
    redirect_to(url)
  end

  # Generate a URL for a subscription and redirect to it
  def subscribe
    url = GoCardless.new_subscription_url(
      amount: "10",
      interval_unit: "month",
      interval_length: "1",
      name: "Sample subscription"
    )
    redirect_to(url)
  end

  # Generate a URL for a preauthorization and redirect to it
  def preauth
    url = GoCardless.new_pre_authorization_url(
      amount: "100",
      interval_length: "month",
      interval_unit: "3",
      name: "Sample preauthorization"
    )
    redirect_to(url)
  end

  # Handle the callback after the user finishes the payment process.
  # Render a success/error page depending on whether the transaction
  # was successful or not.
  # https://gocardless.com/docs/ruby/merchant_client_guide#completing-the-payment
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

  # Handle the incoming Webhook and perform an action with the
  # Webhook data.
  # More information at https://gocardless.com/docs/web_hooks_guide
  def webhook
    webhook_data = params[:payload]

    if GoCardless.webhook_valid?(webhook_data)
      # Do something with webhook_data, save to DB, log etc
      # For example, if you had a model called Bills and you want
      # to update each of the incoming bills
      # webhook_data.bills.each do |b|
      #   bill = Bills.find_by_bill_id(b[:id])
      #   bill.status = b[:status]
      #   bill.save
      # end
    else
      # log the error
    end

    render nothing: true, status: 200
  end
end
