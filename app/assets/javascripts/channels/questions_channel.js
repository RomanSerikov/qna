App.cable.subscriptions.create('QuestionsChannel', {
  received: function(data) {
    $('.questions-list').append(data)
  },
  connected: function() {
    console.log('connected');
  }
});
