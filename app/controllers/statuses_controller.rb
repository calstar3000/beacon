class StatusesController < ApplicationController
  before_filter :signed_in_user 
  before_filter :correct_user,  only: :destroy

  # GET /statuses
  # GET /statuses.json
  def index
    @statuses = Status.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @statuses }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
    @status = Status.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.json
  def new
    @status = Status.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/1/edit
  def edit
    @status = Status.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = current_user.statuses.build(status_params)

    respond_to do |format|
      if @status.save
        flash[:success] = "Status was successfully created."
        format.html { redirect_to root_url }
        #format.json { render json: @status, status: :created, location: @status }
      else
        @status_feed = current_user.status_feed.paginate(page: params[:page], per_page: 20)
        format.html { render "static_pages/home" }
        #format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.json
  def update
    @status = Status.find(params[:id])

    respond_to do |format|
      if @status.update_attributes(params[:status])
        format.html { redirect_to @status, notice: 'Status was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    @status.destroy

    respond_to do |format|
      flash[:success] = "Status was successfully destroyed"
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private

    def status_params
      params.require(:status).permit(:content)
    end

    def correct_user
      @status = current_user.statuses.find_by_id(params[:id])
    rescue
      redirect_to root_url
    end

end
