$(document).on('turbolinks:load', function () {
  // -------------------- 画像ファイルフィールド --------------------
  var image_file = $('.item-registration__form__group .nest-form');

  // ファイル選択
  image_file.on('click', function() {
    image_file.children('input')[0].click();
  })

  // 選択ファイルプレビュー
  image_file.children('input').on('change', function (e) {
    // ファイルオブジェクト取得
    var file = e.target.files[0];
    var reader = new FileReader();

    // TODO:アップロードした画像設定
  });

  // -------------------- カテゴリー連携 --------------------
  var top_category = $('.item-registration__form__group__box .top select');
  var middle_category = $('.item-registration__form__group__box .middle select');
  var bottom_category = $('.item-registration__form__group__box .bottom select');
  var top_category_id;
  var middle_category_id;
  var middle_data;
  var bottom_data;

  top_category.on('change', function () {
    // トップカテゴリー取得
    top_category_id = $(this).val();
    // マージン設定
    top_category.parent().css('margin-bottom', '40px')
    middle_category.parent().css('margin-bottom', '40px')
    // 非表示設定
    middle_category.parent().hide();
    bottom_category.parent().hide();
    // 選択している場合、該当するミドルカテゴリーを表示
    if ($(this).val().length) {
      top_category.parent().css('margin-bottom', '0')
      middle_category.each(function () {
        middle_data = $(this).data('val');
          if (top_category_id == middle_data) $(this).parent().show();
      })
    }
  })

  middle_category.on('change', function () {
    // ミドルカテゴリー取得
    middle_category_id = $(this).val();
    // マージン設定
    middle_category.parent().css('margin-bottom', '40px')
    // 非表示設定
    bottom_category.parent().hide();
    // 選択している場合、該当するボトムカテゴリーを表示
    if ($(this).val().length) {
      middle_category.parent().css('margin-bottom', '0')
      bottom_category.each(function () {
        bottom_data = $(this).data('val');
        if (middle_category_id == bottom_data) $(this).parent().show();
      })
    }
  })

  // -------------------- 価格計算 --------------------
  var item_price_field = $('.item-registration__form__group__box__list--right');
  var item_price;
  var item_fee;
  var item_benefit;

  function separate(num) {
    return String(num).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
  }

  item_price_field.on('change', function () {
    // 入力価格取得
    item_price = $(this).children('input').val();
    // 手数料と利益計算
    item_fee = Math.floor(item_price / 10);
    item_benefit = separate(item_price - item_fee);
    // 手数料と利益セット
    item_price_field.children('p').text("¥" + item_fee);
    item_price_field.children('h3').text("¥" + item_benefit);
  })
});
