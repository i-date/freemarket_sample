$(document).on('turbolinks:load', function () {
  if ($('.devise-main__content__form .field .error').length) {
    $('.devise-main__content__form .field .error').siblings('input').css('border-color', '#ea352d');
  };
});
