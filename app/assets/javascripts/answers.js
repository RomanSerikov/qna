$(document).on('click', '.edit_answer_link', function(e) {
  e.preventDefault();

  var answerId = $(this).data('answerId');
  var form = $('#edit-answer-' + answerId);

  manageSelector(this, 'answer-cancel', 'Cancel edit', 'Edit')

  form.toggle();
});

$(document).on('ajax:success', 'a.vote_answer', function(e, data, status, xhr) {
  var votes = $.parseJSON(xhr.responseText);
  var answerId = $(this).data('answerId');

  $('.answer-votes-' + answerId).html('<p>Answer rating: ' + votes + '</p>');
});
