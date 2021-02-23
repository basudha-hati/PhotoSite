require 'rubygems'
require 'bundler/setup'
require 'aws-sdk-s3'
require 'uuid'

class PhotoController < ApplicationController
  def index
    @users = User.joins(:photos)
    @photos = Photo.joins(:comments)
    @users = User.find(params[:id])
    @comments = @users.comments
    @photos = @users.photos
    # @filename = Photo.find(params[:user_id])
    puts "Basudha start"
    puts @photos.instance_values
    puts "Basudha end"

    s3_client = Aws::S3::Client.new(region: 'us-east-1')
    # sample = s3_client.list_objects_v2(
    #   bucket: 'photobooth-rubyonrails',
    #   max_keys: 100
    # ).contents
    signer = Aws::S3::Presigner.new(client: s3_client)
    @photos.each do |photo|
      fname = photo.file_name
      url = signer.presigned_url(
        :get_object,
        bucket: 'photobooth-rubyonrails',
        key: fname
      )
      photo.file_name = url
    end
  end
end
