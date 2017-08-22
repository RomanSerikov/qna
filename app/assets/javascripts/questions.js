$(document).on('click', '.edit_question_link', function(e) {
  e.preventDefault();

  var form = $('.edit_question');

  if (!$(this).hasClass('cancel')) {
    $(this).html('Close edit');
    $(this).addClass('cancel');
  } else {
    $(this).html('Edit my question');
    $(this).removeClass('cancel');
  }

  form.toggle();
});

$(document).on('click', '.edit_question_button', function() {
  var form = $('.edit_question');
  var link = $('.edit_question_link');

  form.hide();
  link.html('Edit my question');
  link.removeClass('cancel');
});
