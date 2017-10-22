require 'acceptance_helper'

feature 'Vote for answer', %q{
  In order to rate answer
  As an authenticated user
  I want to be able to vote for answer
} do

  given(:question)  { create(:question) }
  given!(:answer)   { create(:answer, question: question, user: author) }
  given(:container) { '.answers' }
  given(:obj)       { 'Answer' }

  it_behaves_like 'Vote ability'
end
