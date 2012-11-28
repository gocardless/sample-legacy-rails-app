# GoCardless sample application

## Setup

The first thing to do is to clone the repository:

```sh
$ git clone https://github.com/gocardless/sample-rails-app.git
```

Change the account details in `app/initializers/gocardless.rb` to match your
**SANDBOX** developer credentials.

Then install the Gems:
```sh
$ bundle install
```

Once the installation has finished, run the app:
```sh
$ rails server
```

and open your browser at `http://127.0.0.1/3000`.

## Walkthrough

Before you interact with the application, go to GoCardless Sandbox and set up
the Redirect URI in the Developer settings. To make it work with this
application, use the value `http://127.0.0.1:3000/gocardless/confirm`. This is to
make sure you are redirected back to your site where the purchase is verified
after you have made a purchase.

### One-off purchases

The simplest payment type is one-off. By clicking `Make purchase` on the sample
appliation website, you are taken through the flow in making a single payment.

A real-world example of one-off purchases is buying something in an online store.

### Subscriptions

Subscriptions are fixed periodic payments. Upon clicking `Subscribe` on the sample
application website, you are taken through the process of registering a subscription
with a merchant.

An example would be subscribing to a magazine or newspaper. The magazine is
published once a month and it costs £10, the payment flow sets up an automatic
transaction transferring £10 monthly to the merchant's account.

### Pre-authorizations

Pre-authorizations are essentially subscriptions, with an added twist that it's
up to the merchant to request funds from the customer's account, and the
customer may be billed up to a certain, authorized amount every billing
period. Upon clicking `Preauthorize` on the sample app website, you are taken
through the flow of pre-authorizing a variable direct-debit payment.

An example from the real world would be a type of pay-as-you go service where
the customer authorizes the merchant to claim up to a certain amount per interval
depending on usage.

In the sample app, you pre-authorize a payment of up to £100 every 3 months.

For further information, refer to the [docs](https://sandbox.gocardless.com/docs/connect_guide#payment-types).

## Webhooks

Set up `localtunnel` to test out Webhooks. The `localtunnel` gem should be
installed as a dependency to the project.
Note, however, that the port number is the same as the port that `rails server` is
running on.
```sh
$ localtunnel -k ~/.ssh/id_rsa.pub 3000
=> Port 3000 is now publicly accessible from http://3u5q.localtunnel.com ...
```
Please refer to the [the Webhooks manual](https://sandbox.gocardless.com/docs/ruby/merchant_tutorial_webhook#receiving-webhooks) for more details.

### Test your Webhooks
Once you have the app running with `rails server` and tunneling set up with
`localtunnel` (make sure you verify that by navigating to the URL that
`localtunnel` gives back to you) navigate to the "Web hooks" tab under the
Developer section in GoCardless Sandbox. There should be a button for sending a
test webhook. Click that, select `Bill` as the object type and click `Fire webhook`.

The data from Webhook is accessible in the `webhook` endpoint in
`app/controllers/gocardless_controller.rb` in the `webhook_data` variable.

## Tests

To run the tests, run `rake test:functionals` in the project root.
