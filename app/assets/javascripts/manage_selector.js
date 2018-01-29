function manageSelector(obj, selector, cancelText, editText) {
  if (!$(obj).hasClass(selector)) {
    $(this).html(cancelText);
    $(this).addClass(selector);
  } else {
    $(this).html(editText);
    $(this).removeClass(selector);
  }
}
