class LevelsController < ApplicationController
  def new
  end

  def create
    last_level = Dir[Rails.root.join('public', 'levels', '*')].sort_by{|f| File.basename(f)}.last
    last_level = last_level ? File.basename(last_level).to_i : 0

    new_level = ("%03d" % (last_level + 1)).scan(/\d{3}/).join("/")

    result = FileUtils.mkdir_p(Rails.root.join('public', 'levels', "#{ new_level }")).first

    time = Time.zone.now.to_i
    File.open(Rails.root.join(result, "#{time}.json"), File::CREAT|File::RDWR) do |file|
      file.write(params[:data])
    end

    render :json => {:result => "Новый уровень создан успешно!"}
  end

  def edit

  end
end