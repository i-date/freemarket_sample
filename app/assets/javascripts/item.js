$(document).on('turbolinks:load', function () {
  // -------------------- 商品画像選択 --------------------
  var small_image_box = $('.detail__box__item__image--small');
  var large_image_box = $('.detail__box__item__image--large');
  var small_image_src;

  small_image_box.children('img').on('mouseover', function () {
    // imageのopacity変更
    small_image_box.children('img').css('opacity', '0.4');
    $(this).css('opacity', '1');
    // 選択したsmall_imageのsrcをlarge_imageのsrcに設定
    small_image_src = $(this).attr('src');
    large_image_box.children('img').attr('src', small_image_src);
  })

  // -------------------- 商品画像（小）のサイズ変更 --------------------
  if (small_image_box.children('img').length == 5) {
    small_image_box.children('img').css({'width': '60px', 'height': '60px'});
    $('.detail__box__item').css('min-height', '360px');
  } else if (small_image_box.children('img').length > 5) {
    small_image_box.children('img').css({'width': '60px', 'height': '60px'});
    $('.detail__box__item').css('min-height', '420px');
  };

  // -------------------- 出品ボタンの削除 --------------------
  var item_detail_url = $(location).attr("href").match(/\/jp\/\d+/);
  if (item_detail_url != null) $('.sell-btn').remove();
});
