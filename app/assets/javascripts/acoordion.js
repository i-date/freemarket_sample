$(function () {
  var acoordionTopDistance;
  var headerBottomPosition = 90;
  var accordion            = $('.accordion');
  var level                = $('.accordion__level');
  var level1               = $('.level-1');
  var level2               = $('.level-2');
  var level3               = $('.level-3');

  // アコーディオンのHeightをリストに反映
  function setHeight(accHeight) {
    level2.css('height', accHeight);
    level3.css('height', accHeight);
  }

  // リスト開閉にアコーディオンのWidthを反映
  function setAccordionWidth(accWidth) {
    level.css('width', accWidth);
  }

  // リスト上端を設定
  function setAccordionTop(accSelecter, accTopdistance) {
    accSelecter.css('top', accTopdistance);
  }

  // リスト上端を指定
  accordion.on('mouseover', function () {
    acoordionHeight = $(this).children('.accordion__level').height();
    setHeight(acoordionHeight);
  });

  // level-1のリスト開閉
  accordion.hover(function () {
    $(this).children('.accordion__level').children('.level-1').toggle(true);
  }, function () {
    $(this).children('.accordion__level').children('.level-1').toggle(false);
  });

  // level-2のリスト開閉
  level1.children('.level-1__list').hover(function () {
    if ($(this).children('.level-2').length) {
      acoordionTopDistance = headerBottomPosition - $(this).offset().top;
      setAccordionTop($(this).children('.level-2'), acoordionTopDistance);
      setAccordionWidth('448px')
      $(this).children('.level-2').toggle(true);
    }
  }, function () {
    if ($(this).children('.level-2').length) {
      setAccordionWidth('224px')
      $(this).children('.level-2').toggle(false);
    }
  });

  // level-3のリスト開閉
  level2.children('.level-2__list').hover(function () {
    if ($(this).children('.level-3').length) {
      acoordionTopDistance = headerBottomPosition - $(this).offset().top;
      setAccordionTop($(this).children('.level-3'), acoordionTopDistance);
      setAccordionWidth('768px')
      $(this).children('.level-3').toggle(true);
    }
  }, function () {
    if ($(this).children('.level-3').length) {
      setAccordionWidth('448px')
      $(this).children('.level-3').toggle(false);
    }
  });
});
