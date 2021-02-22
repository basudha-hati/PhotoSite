class UserController < ApplicationController
  def index
    @users_set = User.all;
  end

  # def download
  #   s3 = Aws::S3::Resource.new(region: 'us-east-1')
  #   uuid = UUID.new
  #   bucket_name = "ruby-sdk-sample-#{uuid.generate}"
  #   bucket = s3.bucket(bucket_name)
  #   bucket.create
  #   object = bucket.object('hilton1.jpg')
  #   object.upload_file("/Users/Basudha/Downloads/p4images/hilton1.jpg")
  #   puts "Created an object in S3 at:"
  #   puts object.public_url
  #   puts "\nUse this URL to download the file:"
  #   puts object.presigned_url(:get)
  #   @download = object.presigned_url(:get)
  # end
end
