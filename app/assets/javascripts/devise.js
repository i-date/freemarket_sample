$(document).on('turbolinks:load', function () {
  var session_form = $('.devise-main__session__form .field .error');
  var session_error_field = session_form.siblings('input');
  var registration_form = $('.devise-main__registration__form .field .error');
  var registration_error_field = registration_form.siblings('.field_with_errors').children('input');
  var omniauth_form = $('.omniauth .field .error');
  var omniauth_error_field = omniauth_form.siblings('input');

  if (session_form.length) {
    session_error_field.css('border-color', '#ea352d');
    session_error_field.on('click', function () {
      session_error_field.css('border-color', '#ea352d');
      $(this).css('border-color', '#0099e8');
    });
  };

  if (registration_form.length) {
    registration_error_field.css('border-color', '#ea352d');
    registration_error_field.on('click', function () {
      registration_error_field.css('border-color', '#ea352d');
      $(this).css('border-color', '#0099e8');
    })
  };

  if (omniauth_form.length) {
    omniauth_error_field.css('border-color', '#ea352d');
    omniauth_error_field.on('click', function () {
      omniauth_error_field.css('border-color', '#ea352d');
      $(this).css('border-color', '#0099e8');
    })
  };
});
