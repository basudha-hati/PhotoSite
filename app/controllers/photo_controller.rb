class PhotoController < ApplicationController
  def index
    @users=User.joins(:photos)
    @photos=Photo.joins(:comments)
    @users= User.find(params[:id])
    @photos= @users.photos
    @comments= @users.comments
  end
end
