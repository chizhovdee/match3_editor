class LevelsController < ApplicationController
  def new
  end

  def create
    last_level = Dir[Rails.root.join('public', 'levels', '*')].sort_by{|f| File.basename(f)}.last
    new_level = ("%03d" % (File.basename(last_level).to_i + 1)).scan(/\d{3}/).join("/")

    result = FileUtils.mkdir_p(Rails.root.join('public', 'levels', "#{ new_level }"))

    redirect_to edit_level_path new_level


    # time = Time.zone.now.to_i
    # File.open(Rails.root.join(result, "#{time}.json"), File::CREAT|File::RDWR) do |file|
    #   file.write(MultiJson.encode({datetime: time}))
    # end
  end

  def edit

  end
end