class Ability
  include CanCan::Ability

  def initialize(user)
      @user = user
      alias_action :create, :update, :read, :destroy, to: :crud
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
    can :crud, :all

    can [:vote_up, :vote_down], [Question, Answer] do |object|
      object.user_id != @user.id && object.votes.select{|vote| vote.user_id == @user.id}.empty?
    end

    can :cancel_vote, [Question,Answer] do |object|
      !object.votes.select{|vote| vote.user_id == @user.id}.empty?
    end
  end

  def non_admin_abilities
    can :read, [Question, Answer]
    can :create, [Question, Answer, Comment]
    can [:destroy, :update], [Question, Answer], user_id: @user.id

    can :destroy, Attachment do |obj|
      obj.attachmentable.user_id == @user.id
    end

    can :me, User, id: @user.id
    can :others, User

    can [:vote_up, :vote_down], [Question, Answer] do |object|
      object.user_id != @user.id && object.votes.select{|vote| vote.user_id == @user.id}.empty?
    end

    can :cancel_vote, [Question,Answer] do |object|
      !object.votes.select{|vote| vote.user_id == @user.id}.empty?
    end


  end

end
