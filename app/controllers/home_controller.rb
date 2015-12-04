class HomeController < ApplicationController
  def index
    @levels =  Editor.level_ids
  end
end