function connectChannel(obj, subj, selector) {
  var question_id = $(selector).data("id");

  if (question_id) {
    obj.perform(subj, { id: question_id });
  } else {
    obj.perform("unfollow");
  }
}
