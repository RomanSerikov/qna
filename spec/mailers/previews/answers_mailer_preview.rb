# Preview all emails at http://localhost:3000/rails/mailers/answers_mailer
class AnswersMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/answers_mailer/new
  def new
    AnswersMailerMailer.new
  end

end
