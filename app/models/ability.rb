class Ability
  include CanCan::Ability

  def initialize(user)
      @user = user
      if user
        user.admin? ? admin_abilities : non_admin_abilities
      else
          guest_abilities
      end
  end

  private
  def guest_abilities
    can :read, Question
  end

  def admin_abilities
    can :manage, :all
  end

  def non_admin_abilities
    can :read, Question
    can :create, [Question, Answer, Comment]
    can [:destroy, :update], [Question, Answer], user_id: @user.id

    can :destroy, Attachment do |obj|
      obj.attachmentable.user_id == @user.id
    end

    can :me, User, id: @user.id
    can :others, User

  end

end
