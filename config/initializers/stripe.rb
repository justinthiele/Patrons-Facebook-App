if Rails.env.staging?
  Stripe.api_key = "stripe-api-key"
  STRIPE_PUBLIC_KEY = "stripe-public-key"
else
  Stripe.api_key = "stripe-api-key"
  STRIPE_PUBLIC_KEY = "stripe-public-key"
end