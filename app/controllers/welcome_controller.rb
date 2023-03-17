class WelcomeController < ApplicationController
  def index
    if params.has_key? :register
      @register = true
    end
    render 'index'
  end
  
  
  
  
  
  # def import
  #   Product.import(params[:file])
  #   redirect_to root_url, notice: "Products imported."
  # end
end