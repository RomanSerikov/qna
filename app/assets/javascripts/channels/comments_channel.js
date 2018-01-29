App.cable.subscriptions.create('CommentsChannel', {
  connected: function() {
    connectChannel(this, "follow_comments", ".question")
  },
  
  received: function(data) {
    var current_user_id = gon.current_user_id,
        comment_user_id = data.comment.user_id;

    if (current_user_id !== comment_user_id) {
      var comments_list = '#comments-' + data['commentable_type'] + '-' + data['commentable_id'];
      $(comments_list).append(JST["templates/comment"]({ comment: data.comment }));
    }
  }
});
