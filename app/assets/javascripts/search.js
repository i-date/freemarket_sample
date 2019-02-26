$(document).on('turbolinks:load', function () {
  // -------------------- 検索（ヘッダー） --------------------
  $('.header__container__top__search i').on('click', function () {
    $('.header__container__top__search__action input').click();
  });

  // -------------------- 詳細検索：カテゴリー連携 --------------------
  const SEARCH_CATEGORY_GROUP = '.search__detail__container__group';
  var search_category_group = $(SEARCH_CATEGORY_GROUP);
  var search_top_category = $(SEARCH_CATEGORY_GROUP + ' .category-top select');
  var search_middle_category = $(SEARCH_CATEGORY_GROUP + ' .category-middle select');
  var search_bottom_category = $(SEARCH_CATEGORY_GROUP + ' .category-bottom');
  var search_top_category_id;
  var search_middle_category_id;
  var search_middle_data;
  var search_bottom_data;
  var search_category_params = [];

  // リセットボタンをクリックしたらミドル・ボトムカテゴリー非表示
  $('button[type="reset"]').on('click', function() {
    search_category_group.children('.category-middle').hide();
    search_category_group.children('.category-bottom').hide();
  });

  search_top_category.on('change', function() {
    // トップカテゴリー取得
    search_top_category_id = $(this).val();
    // 非表示設定
    search_category_group.children('.category-middle').hide();
    search_category_group.children('.category-bottom').hide();
    // disabled設定
    search_middle_category.prop('disabled', true);
    // 選択している場合、該当するミドルカテゴリーを表示
    if ($(this).val().length) {
      search_middle_category.each(function() {
        search_middle_data = $(this).data('val');
        if (search_top_category_id == search_middle_data) {
          $(this).parent().show();
          $(this).prop('disabled', false);
        }
      })
    }
  })

  search_middle_category.on('change', function() {
    // ミドルカテゴリー取得
    search_middle_category_id = $(this).val();
    // 非表示設定
    search_category_group.children('.category-bottom').hide();
    // 選択している場合、該当するボトムカテゴリーを表示
    if ($(this).val().length) {
      search_bottom_category.each(function() {
        search_bottom_data = $(this).data('val');
        if (search_middle_category_id == search_bottom_data) {
          $(this).css('display', 'flex');
        }
      })
    }
  })

  // -------------------- 詳細検索：価格範囲選択 --------------------
  var search_price_field = $('.search__detail__container__group__price');
  var search_price_select = search_price_field.parent('div').children('.search__detail__container__group__select').children('select');
  var price_range;
  var price_array;

  search_price_select.on('change', function() {
    price_range = $(this).val();
    price_array = price_range.split(/\s|~/);
    search_price_field.children('input:first-of-type').val(price_array.shift());
    search_price_field.children('input:last-of-type').val(price_array.pop());
  });

  // -------------------- 詳細検索：checkboxですべてを選択 --------------------
  var check_container = $('.search__detail__container__group__check__box');

  check_container.children('input').on('change', function() {
    if ($(this).val() == '0' || $(this).val() == 'all') {
      $(this).parent('div').siblings('div').children('input[type=checkbox]').click()
    }
  });

  // -------------------- 詳細検索：ソート --------------------
  $('.search-sorts').on('change', function() {
    $('.search__detail').submit();
  });
});
