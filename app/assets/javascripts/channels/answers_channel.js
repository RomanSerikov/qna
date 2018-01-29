App.cable.subscriptions.create('AnswersChannel', {
  connected: function() {
    connectChannel(this, "follow_answers", ".question")
  },
  
  received: function(data) {
    var current_user_id = gon.current_user_id,
        answer_user_id  = JSON.parse(data["answer_user_id"]);

    if (current_user_id !== answer_user_id) {
      $('.answers').append(JST["templates/answer"]({ data: data }));
    }
  }
});
