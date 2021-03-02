require 'rubygems'
require 'bundler/setup'
require 'aws-sdk-s3'
require 'uuid'
class PhotoController < ApplicationController
  def index
    @users=User.joins(:photos)
    @photos=Photo.joins(:comments)
    @users= User.find(params[:id])
    @photos= @users.photos
    #@comments= @users.comments


    #This is for making cnnection with AWS S3 and fetch the photos
    s3_client = Aws::S3::Client.new(region: 'us-east-1')
    signer = Aws::S3::Presigner.new(client: s3_client)
    @photos.each do |photo|
      fname = photo.file_name
      url = signer.presigned_url(
        :get_object,
        bucket: 'photosite-bucket',
        key: fname
      )
      photo.file_name = url
    end
  end
end
