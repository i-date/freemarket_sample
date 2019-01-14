$(document).on('turbolinks:load', function () {
  var left_tab = $('.tag-box__tab--left');
  var right_tab = $('.tag-box__tab--right');

  left_tab.on('click', function () {
    $(this).parent().children('.tag-box__tab--right').removeClass('tab-active');
    $(this).addClass('tab-active');
    $(this).parent().siblings('.tag-box .tag-box__list').hide();
    $(this).parent().siblings('.tag-box .tag-box__list:nth-child(2)').show();
  })

  right_tab.on('click', function () {
    $(this).parent().children('.tag-box__tab--left').removeClass('tab-active');
    $(this).addClass('tab-active');
    $(this).parent().siblings('.tag-box .tag-box__list').hide();
    $(this).parent().siblings('.tag-box .tag-box__list:last-child').show();
  })
});
