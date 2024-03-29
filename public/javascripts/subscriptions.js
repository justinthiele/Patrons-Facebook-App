/* DO NOT MODIFY. This file was compiled Sun, 23 Oct 2011 18:56:59 GMT from
 * /Users/justinthiele/Dropbox/code-apps/pledges/app/coffeescripts/subscriptions.coffee
 */

(function() {
  var subscription;
  jQuery(function() {
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
    return subscription.setupForm();
  });
  subscription = {
    setupForm: function() {
      return $('#new_subscription').submit(function() {
        $('input[type=submit]').attr('disabled', true);
        if ($('#card_number').length) {
          subscription.processCard();
          return false;
        } else {
          return true;
        }
      });
    },
    processCard: function() {
      var card;
      card = {
        number: $('#card_number').val(),
        cvc: $('#card_code').val(),
        expMonth: $('#card_month').val(),
        expYear: $('#card_year').val()
      };
      return Stripe.createToken(card, subscription.handleStripeResponse);
    },
    handleStripeResponse: function(status, response) {
      if (status === 200) {
        $('#subscription_stripe_card_token').val(response.id);
        return $('#new_subscription')[0].submit();
      } else {
        $('#stripe_error').text(response.error.message);
        return $('input[type=submit]').attr('disabled', false);
      }
    }
  };
}).call(this);


(function() {
  var subscription;
  jQuery(function() {
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
    return subscription.setupForm();
  });
  subscription = {
    setupForm: function() {
      return $('#edit_subscription').submit(function() {
        $('input[type=submit]').attr('disabled', true);
        if ($('#card_number').length) {
          subscription.processCard();
          return false;
        } else {
          return true;
        }
      });
    },
    processCard: function() {
      var card;
      card = {
        number: $('#card_number').val(),
        cvc: $('#card_code').val(),
        expMonth: $('#card_month').val(),
        expYear: $('#card_year').val()
      };
      return Stripe.createToken(card, subscription.handleStripeResponse);
    },
    handleStripeResponse: function(status, response) {
      if (status === 200) {
        $('#subscription_stripe_card_token').val(response.id);
        return $('#edit_subscription')[0].submit();
      } else {
        $('#stripe_error').text(response.error.message);
        return $('input[type=submit]').attr('disabled', false);
      }
    }
  };
}).call(this);
