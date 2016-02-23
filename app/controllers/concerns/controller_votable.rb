module ControllerVotable
  extend ActiveSupport::Concern
  included do
    before_action :authenticate_user!, only: [:vote_up, :vote_down, :cancel_vote]
    before_action :load_votable, only: [:vote_up, :vote_down, :cancel_vote]
  end


  def vote_up
    @votable.vote_up(current_user)
    @votable.reload
    render json: {votes_sum: @votable.votes_sum}
  end

  def vote_down
    @votable.vote_down(current_user)
    @votable.reload
    render json: {votes_sum: @votable.votes_sum}
  end

  def cancel_vote
    @votable.cancel_vote(current_user)
    @votable.reload
    render json: {votes_sum: @votable.votes_sum}
  end

  private
  def load_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
end