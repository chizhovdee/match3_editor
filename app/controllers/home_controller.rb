class HomeController < ApplicationController
  def index
    #file = Dir[Rails.root.join(level_path, '*.json')].sort_by{|f| File.basename(f).gsub(/[.json]/, '').to_i}.last
    @levels = Dir[Rails.root.join('public', 'levels', '*')].sort.map do |level_path|
     File.basename(level_path)
    end
  end
end