FactoryGirl.define do
  factory :question_comment, class: "Comment" do
    body "MyCommentText"
    user
    association :commentable, factory: :question
  end

  factory :answer_comment, class: "Comment" do
    body "MyCommentText"
    user
    association :commentable, factory: :answer
  end
end
