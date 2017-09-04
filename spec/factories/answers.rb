FactoryGirl.define do
  factory :answer do
    body "MyAnswerText"
    question
    user
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    question
    user
  end
end
