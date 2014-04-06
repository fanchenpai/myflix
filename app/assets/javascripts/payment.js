var stripeResponseHandler = function(status, response) {
  var $form = $('#payment-form');
  if (response.error) {
    $form.find('.payment-errors').addClass('alert alert-danger').text(response.error.message).show();
    $form.find(':submit').val('Sign Up').prop('disabled', false);
  }
  else {
    var token = response.id;
    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
    $form.get(0).submit();
  }
};

jQuery(function($) {
  $('#payment-form').submit(function(event) {
    var $form = $(this);
    $form.find(':submit').val('Processing...').prop('disabled', true);
    Stripe.card.createToken($form, stripeResponseHandler);
    return false;
  });
});
