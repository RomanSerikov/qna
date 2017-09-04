FactoryGirl.define do
  factory :question do
    title "MyQuestionTitle"
    body "MyQuestionText"
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end
end
