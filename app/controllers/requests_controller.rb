class RequestsController < ApplicationController
  def new
    @request = Request.new
  end

  def edit
  end

  def create
    @request = current_user.requests.new(request_params)

    if @request.save
      redirect_to root_url
    else
      render :new
    end
  end

  def update
  end

  private

    def request_params
      params.require(:request).permit(:date, :possible)
    end

end
