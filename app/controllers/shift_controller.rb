class ShiftController < ApplicationController
  before_action :logged_in_user, only: %i[profile]

  def index
  end

  def profile
  end
end
