class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@status = current_user.statuses.build
  		@status_feed = current_user.status_feed.paginate(page: params[:page], per_page: 20)
  	end
  end

  def help
  end

  def about
  end

  def contact
  end
end
