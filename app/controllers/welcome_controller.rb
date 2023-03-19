class WelcomeController < ApplicationController
  def index
    if params.has_key? :register
      @register = true
    end
    #render 'index'         # AMIN ISAZDEH: I think this line is unnecessary.
  end
end
