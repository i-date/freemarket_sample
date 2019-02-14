$(document).on('turbolinks:load', function () {
  // -------------------- 画像ファイルフィールド --------------------
  var image_file = $('.nest-form');
  var image_count = 1;
  var image_tag;
  var file_tag;

  function build_image_tag(alt, src) {
    // 編集と削除を表示する場合（機能は別途実装する必要あり）：<img>以下に<span>編集</span>と<span>削除</span>を挿入
    var html = `<li>
                  <img alt="${alt}" src="${src}">
                </li>`
    return html;
  }

  function build_file_tag(num) {
    var html = `<input name="images[name][${num}]" style="display: none;" type="file" id="image${num}">`
    return html;
  }

  // ファイル選択
  image_file.on('click', function() {
    image_file.children('input[name="images[name][' + image_count + ']"]')[0].click();
  })

  // プレビュー
  image_file.on('change', image_file.children('input[name="images[name][' + image_count + ']"]'), function (e) {
    // ファイルオブジェクト取得
    var file = e.target.files[0];
    var file_reader = new FileReader();

    // 選択画像プレビュー操作
    file_reader.onload = (function () {
      return function (e) {
        // imgタグ追加
        image_tag = build_image_tag(image_count, e.target.result);
        $('.image-preview').append(image_tag);
        // ファイル数カウント
        image_count += 1;
        file_tag = build_file_tag(image_count);
        image_file.append(file_tag);
      };
    })(file);

     file_reader.readAsDataURL(file);
  });

  // -------------------- カテゴリー連携 --------------------
  const CATEGORY_GROUP = '.item-registration__form__group__box';
  var category_container = $('.item-registration__form__group__box__category');
  var top_category = $(CATEGORY_GROUP + ' .top .field_with_errors').length ? $(CATEGORY_GROUP + ' .top .field_with_errors select') : $(CATEGORY_GROUP + ' .top select');
  var middle_category = $(CATEGORY_GROUP + ' .middle .field_with_errors').length ? $(CATEGORY_GROUP + ' .middle .field_with_errors select') : $(CATEGORY_GROUP + ' .middle select');
  var bottom_category = $(CATEGORY_GROUP + ' .bottom .field_with_errors').length ? $(CATEGORY_GROUP + ' .bottom .field_with_errors select') : $(CATEGORY_GROUP + ' .bottom select');
  var top_category_id;
  var middle_category_id;
  var bottom_category_id;
  var middle_data;
  var bottom_data;

  top_category.on('change', function () {
    // トップカテゴリー取得
    top_category_id = $(this).val();
    // マージン設定
    category_container.children('.top').css('margin-bottom', '40px')
    category_container.children('.middle').css('margin-bottom', '40px')
    // 非表示設定
    category_container.children('.middle').hide();
    category_container.children('.bottom').hide();
    // 選択している場合、該当するミドルカテゴリーを表示
    if ($(this).val().length) {
      category_container.children('.top').css('margin-bottom', '0')
      middle_category.each(function () {
        middle_data = $(this).data('val');
        if (top_category_id == middle_data) $(CATEGORY_GROUP + ' .middle .field_with_errors').length ? $(this).parent().parent().show() : $(this).parent().show();
      })
    }
  })

  middle_category.on('change', function () {
    // ミドルカテゴリー取得
    middle_category_id = $(this).val();
    // マージン設定
    category_container.children('.middle').css('margin-bottom', '40px')
    // 非表示設定
    category_container.children('.bottom').hide();
    // 選択している場合、該当するボトムカテゴリーを表示
    if ($(this).val().length) {
      category_container.children('.middle').css('margin-bottom', '0')
      bottom_category.each(function () {
        bottom_data = $(this).data('val');
        if (middle_category_id == bottom_data) $(CATEGORY_GROUP + ' .bottom .field_with_errors').length ? $(this).parent().parent().show() : $(this).parent().show();
      })
    }
  })

  bottom_category.on('change', function () {
    // ミドルカテゴリー取得
    bottom_category_id = $(this).val();
    // params用categoy_id設定
    category_container.children('input[type="hidden"]').attr('value', bottom_category_id);
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
    item_price = $(this).children('input').length ? $(this).children('input').val() : $(this).children('.field_with_errors').children('input').val();
    console.log(item_price);
    // 手数料と利益計算
    item_fee = Math.floor(item_price / 10);
    item_benefit = separate(item_price - item_fee);
    // 手数料と利益セット
    item_price_field.children('p').text("¥" + item_fee);
    item_price_field.children('h3').text("¥" + item_benefit);
  })
});
