class Ability
  include CanCan::Ability

  def initialize(user)
      if user
        if user.admin?
          can :manage, :all
        else
          can :read, Question
          can :create, [Question, Answer, Comment]
          can :destroy, [Question, Answer], user_id: user.id
          can :update, [Question, Answer], user_id: user.id

          can :destroy, Attachment do
            self.attachmentable.user_id == user.id
          end

        end
      else #guest
        can :read, Question
      end

  end
end
