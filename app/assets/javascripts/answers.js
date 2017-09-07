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

var ready = function() {
  $('a.vote_answer').bind('ajax:success', function (e, data, status, xhr) {
    var votes = $.parseJSON(xhr.responseText);
    var answerId = $(this).data('answerId');

    $('.answer-votes-' + answerId).html('<p>Answer rating: ' + votes + '</p>');
  });
};

$(document).ready(ready);
$(document).on('turbolinks:load',ready);
