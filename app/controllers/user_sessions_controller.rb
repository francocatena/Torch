class UserSessionsController < ApplicationController
  before_filter :require_no_user, only: [:new, :create]
  before_filter :require_user, only: :destroy

  # GET /user_sessions/new
  # GET /user_sessions/new.json
  def new
    @title = t('view.user_sessions.new_title')
    @user_session = UserSession.new
  end

  def create
    @title = t('view.user_sessions.new_title')
    @user_session = UserSession.new(params[:user_session])
    
    respond_to do |format|
      if @user_session.save
        format.html { redirect_to(apps_url, notice: t('view.user_sessions.correctly_created')) }
        format.json { render json: @user_session, status: :created, location: apps_url }
      else
        format.html { render action: 'new' }
        format.json { render json: @user_session.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    current_user_session.destroy

    respond_to do |format|
      format.html { redirect_to(new_user_session_url, notice: t('view.user_sessions.correctly_destroyed')) }
      format.json { head :ok }
    end
  end
end