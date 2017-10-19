require 'acceptance_helper'

feature 'Vote for question', %q{
  In order to rate question
  As an authenticated user
  I want to be able to vote for question
} do

  given(:question)  { create(:question, user: author) }
  given(:container) { '.question' }
  given(:obj)       { 'Question' }

  it_behaves_like 'Vote ability'
end
