$(document).on('click', '.edit_question_link', function(e) {
  e.preventDefault();

  var form = $('.edit_question');

  manageSelector(this, 'cancel', 'Close edit', 'Edit my question')

  form.toggle();
});

$(document).on('click', '.edit_question_button', function() {
  var form = $('.edit_question');
  var link = $('.edit_question_link');

  form.hide();
  link.html('Edit my question');
  link.removeClass('cancel');
});

$(document).on('ajax:success', 'a.vote_question', function(e, data, status, xhr) {
  var votes = $.parseJSON(xhr.responseText);
  $('.question-votes').html('<p>Question rating: ' + votes + '</p>');
});
