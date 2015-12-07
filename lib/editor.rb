class Editor
  DIR = 'public'

  ELEMENTS = %w{
    empty
    random
    tile_blue
    tile_cyan
    tile_green
    tile_orange
    tile_purple
    tile_red
    tile_yellow
    sump_hatch
    wheel
    multicolored_crystal
    road_tile
    stump
    ribbon_1
    ribbon_2
    ribbon_3
    spider
    jar_with_paint
    alarm_clock
    horizontal_arrowheads
    vertical_arrowheads
    cross_arrowheads
    balloon
    suitcase
    dirt
  }

  TARGETS = %w{
    tile_blue tile_cyan tile_green tile_orange tile_purple tile_red
    road_tile stump ribbon_1
    spider jar_with_paint alarm_clock
  }

  SELECTORS = {
    tiles: [
      "empty", "random", "tile_blue", "tile_cyan", "tile_green", "tile_orange", "tile_purple", "tile_red", "tile_yellow",
      "sump_hatch", "wheel"
    ],

    backing: ["road_tile"],
    modifiers: ["stump", "ribbon_1", "spider", "jar_with_paint", "alarm_clock"],
    wrappers: ["suitcase"]
  }

  LAYERS = ["backing", "tiles", "modifiers", "wrappers"]

  attr_accessor :error, :current_data, :level_id

  class << self
    def level_ids
      Dir[Rails.root.join(DIR, 'levels', '*')].sort.map do |level_path|
        File.basename(level_path)
      end
    end

    def create_level(data)
      editor = new(MultiJson.decode(data))

      begin
        last_level = Dir[Rails.root.join(DIR, 'levels', '*')].sort_by{|f| File.basename(f)}.last
        last_level = last_level ? File.basename(last_level).to_i : 0

        new_level = ("%03d" % (last_level + 1)).scan(/\d{3}/).join("/")

        target_dir = FileUtils.mkdir_p(Rails.root.join(DIR, 'levels', "#{ new_level }")).first

        editor.save!(target_dir)

      rescue Exception => e
        editor.error = e.to_s

        editor
      end

      editor
    end

    def update_level(level_id, data)
      editor = new(MultiJson.decode(data)).tap do |editor|
        editor.level_id = level_id
      end

      begin
        editor.save!(editor.target_dir)

      rescue Exception => e
        editor.error = e.to_s

        editor
      end

      editor
    end

    def level_by_id(level_id)
      # находим последний сохраненный файл
      file = Dir[Rails.root.join(DIR, 'levels', level_id, "*.json")].sort_by{|f| File.basename(f)}.last

      data = File.read(file)

      new(MultiJson.decode(data)).tap do |editor|
        editor.level_id = level_id
      end
    end
  end

  def initialize(data = {}) # на вход принимается декодированный json
    @current_data = data
  end

  def target_dir
    Rails.root.join(DIR, 'levels', level_id)
  end

  def save!(target_dir)
    time = Time.zone.now.to_i

    @current_data[:datetime] = time

    File.open(Rails.root.join(target_dir, "#{time}.json"), File::CREAT|File::RDWR) do |file|
      file.write(MultiJson.encode(@current_data))
      file.close
    end
  end

  def as_json(*args)
    {
      level_id: level_id,
      elements: ELEMENTS,
      current_data: current_data,
      targets: TARGETS,
      selectors: SELECTORS,
      layers: LAYERS
    }
  end
end