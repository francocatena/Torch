class FeedbacksController < ApplicationController
  layout lambda { |controller| controller.request.xhr? ? false : 'application' }
  
  # POST /feedbacks/1/positive
  def create
    @feedback = Hint.find(params[:hint_id]).feedbacks.build(
      positive: params[:score] == 'positive'
    )

    respond_to do |format|
      if @feedback.save
        format.html { render @feedback.positive ? 'positive' : 'negative' }
      end
    end
  end

  # PUT /feedbacks/1
  def update
    @feedback = Feedback.negative.find(params[:id])

    respond_to do |format|
      if @feedback.update_attributes(params[:feedback])
        format.html { render 'negative_comment' }
      end
    end
  end
end