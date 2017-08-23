$(document).on('click', '.edit_answer_link', function(e) {
  e.preventDefault();

  var answerId = $(this).data('answerId');
  var form = $('#edit-answer-' + answerId);

  if (!$(this).hasClass('answer-cancel')) {
    $(this).html('Cancel edit');
    $(this).addClass('answer-cancel');
  } else {
    $(this).html('Edit');
    $(this).removeClass('answer-cancel');
  }

  form.toggle();
});
