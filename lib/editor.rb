class Editor
  FIELD_SIZE = 9

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

  # TARGETS = %w{
  #   tile_blue tile_cyan tile_green tile_orange tile_purple tile_red
  #   road_tile stump ribbon_1 ribbon_2 ribbon_3
  #   spider jar_with_paint alarm_clock
  # }

  def current_data
    {}
  end

  def as_json(*args)
    {
      elements: ELEMENTS,
      field_size: FIELD_SIZE,
      current_data: current_data
    }
  end
end