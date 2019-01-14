
$(document).on('turbolinks:load', function () {
  var url = window.location.pathname;

  $('.mypage-nav__list a[href="' + url + '"]').css({
    'background-color': '#eee',
    'font-weight': 'bold'
  });

  $('.mypage-nav__list a[href="' + url + '"] i').css({
    'color': '#333',
  });
});
