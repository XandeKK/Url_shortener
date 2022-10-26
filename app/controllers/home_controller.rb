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

  def redirect
    @url = Url.find_by(shortener: params[:id])
    if @url
      if @url.expiration_time > DateTime.now
        redirect_to @url.link, allow_other_host: true
      else
        render "home/expiration", layout: false, status: 404
      end
    else
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
  end

  private

  def url_params
    params.require(:url).permit(:link)
  end
end
