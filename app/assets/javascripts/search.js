$(document).on('turbolinks:load', function () {
  $('.header__container__top__search i').on('click', function () {
    $('.header__container__top__search__action input').click();
  })
});
