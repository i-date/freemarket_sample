$(document).on('turbolinks:load', function () {
  $('.swiper-pagination-bullet').on('mouseover', function(){
    $(this).click();
  })
});
