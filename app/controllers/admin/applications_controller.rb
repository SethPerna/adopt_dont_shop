class Admin::ApplicationsController < ApplicationsController
  def show
    @application = Application.find(params[:id])
  end

  def update
    
  end
end
