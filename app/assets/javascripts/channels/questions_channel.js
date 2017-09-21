App.cable.subscriptions.create('QuestionsChannel', {
  connected: function() {
  },
  
  received: function(data) {
    $('.questions-list').append(data)
  }
});
