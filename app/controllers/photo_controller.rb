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
    @comments= @users.comments

    s3_client = Aws::S3::Client.new(#access_key_id: 'ASIAVBFNYDIQFNSIWKE3',
                                    secret_access_key: 'kjyLR1y0A3SsnUH46y8LCONz7ZOZh1MyyEzl/LTl',
                                    session_token: 'FwoGZXIvYXdzEH0aDHw/JG+czAmXNKwENSLPAYWfH3VhAqMH38NOsPZ762msJfRCGo8bPL1qHz0QWEsaiZo3PU3ixBPNIbAgdyQInPJIB8pq7b0KJcFC5ryt3/KbOEP0dtzzNrz0sJHpwXRsox2ZaBKvb2rQ2p8Iq4js1EtM8OWs0e05ibUcd3d5p8Cys12BnRXdijEUcIKdQms39dvD4/NfklXVfVOlBuGi3mrgacGZxRmhFLrCMl6nw989wr8DpoGMHxvGBuNjQYIBJCbkVyNpaqv1ePphIz8ZrjQFS6F3tFkuWvHG8lARKCjoxvGBBjItvJn2QaUYI/lj0Mj/OCgFQz1jTudSt78lL9MnJTcg3x3PWFjM/FzezO0S1hHX',
                                    region: 'us-east-1')
    #signer = Aws::Sigv4::Signer.new(
    # service: 's3',
    # region: 'us-east-1',
    # static credentials
    # access_key_id: 'ASIAVBFNYDIQLGVI5LW5',

    # secret_access_key: '5SpRoYRc7Ec5/Mqeeot4/LPHGf4h1DAvm/TQFgg4'
    #)
    #s3_client = Aws::S3::Client.new(region: 'us-east-1')
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
