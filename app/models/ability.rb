class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    set_aliases

    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  protected

  def set_aliases
    alias_action :update, :destroy, :to => :modify
    alias_action :voteup, :votedown, :to => :vote
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :modify, [Question, Answer], user: user
    can :vote, [Question, Answer]
    cannot :vote, [Question, Answer], user: user
    can :best, Answer do |answer|
      answer.question.user == user
    end
  end
end
