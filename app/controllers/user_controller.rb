class UserController < ApplicationController
  def index
    @users_set=User.all;
  end
end
