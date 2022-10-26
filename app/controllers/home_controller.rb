class HomeController < ApplicationController
  def index
    @url = Url.new
  end

  def create
    begin 
      @url = Url.find_or_create_by!(url_params)
      if @url
        @url.update_if_expired
        respond_to do |format|
          format.turbo_stream
          format.html {render "home/result"}
        end
      end
    rescue ActiveRecord::RecordInvalid
      respond_to do |format|
          format.turbo_stream { render html: :index, status: :unprocessable_entity }
          format.html { render :index, status: :unprocessable_entity }
        end
    end
  end

  private

  def url_params
    params.require(:url).permit(:link)
  end
end
