$(document).on('click', '.add_comment_link', function(e) {
  e.preventDefault();

  var comment_link = $(this),
      form         = comment_link.next('.comment-form').find('.new_comment');

  if (!$(this).hasClass('cancel')) {
    $(this).html('Cancel comment');
    $(this).addClass('cancel');
  } else {
    $(this).html('Add Comment');
    $(this).removeClass('cancel');
  }

  form.toggle();
});

$(document).on('ajax:success', 'form.new_comment', function(e, data) {
  var comment_form     = $(this),
      form_container   = comment_form.closest('.comment-form'),
      comments_list    = form_container.closest('.item-comments').find('.comments-list'),
      comment_body     = form_container.find('#comment_body'),
      add_comment_link = $('.add_comment_link');
 
  comments_list.append(JST["templates/comment"]({ comment: data }));

  comment_body.val('');
  comment_form.hide();
  add_comment_link.html('Add Comment');
  add_comment_link.removeClass('cancel');
});
