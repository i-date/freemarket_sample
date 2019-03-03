$(document).on('turbolinks:load', function() {

  // ページ内各トップカテゴリーリストへスムーススクロール
  $('a[href^="#"]').on('click', function (e) {
    var speed = 400;
    var href = $(this).attr("href");
    var target = $(href == "#" || href == "" ? 'html' : href);
    var position = target.offset().top;
    $('body,html').animate({scrollTop:position}, speed, 'swing');
    return false;
  })
});
