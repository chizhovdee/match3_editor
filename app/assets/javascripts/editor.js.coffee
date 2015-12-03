class window.Editor extends Spine.Controller
  @include Utils

  elements:
    ".settings": "settings_el"
    ".field":    "field_el"
    ".selector": "selector_el"

  ceilSize: 50

  defaultData: {
# layers array [backing, tile, modifier, wrapper] value is index elements, -1 is empty layer
    "tiles": [[[-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1]],
              [[-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1]],
              [[-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1]],
              [[-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1]],
              [[-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1]],
              [[-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1]],
              [[-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1]],
              [[-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1]],
              [[-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1], [-1, 1, -1, -1]]],
    "moves": 15,
    "points_2": 100,
    "points_3": 200,
    "targets": [[-1, 0], [-1, 0], [-1, 0]] # [[index element, count]], -1 empty task
  }

  targetElements: [
    "tile_blue", "tile_cyan", "tile_green", "tile_orange", "tile_purple", "tile_red",
    "road_tile", "stump", "ribbon_1",
    "spider", "jar_with_paint", "alarm_clock"
  ]

  selectors: {
    tiles: [
      "empty", "random", "tile_blue", "tile_cyan", "tile_green", "tile_orange", "tile_purple", "tile_red", "tile_yellow",
      "sump_hatch"
    ],

    backing: ["road_tile"],
    modifiers: ["stump", "ribbon_1", "spider", "jar_with_paint", "alarm_clock"],
    wrappers: ["suitcase"]
  }

  layers: ["backing", "tiles", "modifiers", "wrappers"]

  constructor: ->
    super

    @currentSelector = null # [element, group]

    @currentData = @.deepClone(@editor.current_data)

    @newData = if _.isEmpty(@editor.current_data)
      @.deepClone(@defaultData)
    else
      @.deepClone(@editor.current_data)

    #console.log @currentData
    console.log @newData

    #console.log @editor

    @.bindEventListeners()
    @.render()

    @field_el.find(".ceil:odd").addClass('odd')

  bindEventListeners: ->
    @el.on("click", '.selector .element', @.onSelectorElementClick)
    @el.on("click", '.field .ceil', @.onFieldCeilClick)
    @el.on("click", '.settings .target', @.onSettingsTargetClick)

  render: ->
    @html(@.renderTemplate("index"))


  ceilStylePosition: (row, col)->
    "top: #{ row * @ceilSize }px; left: #{ col * @ceilSize }px;"

  onSelectorElementClick: (e)=>
    element = $(e.currentTarget)

    @selector_el.find(".element").removeClass("selected")

    if @currentSelector? && element.data("element") == @currentSelector[0] && element.data("group") == @currentSelector[1]
      @currentSelector = null
    else
      @currentSelector = [element.data("element"), element.data("group")]
      element.addClass('selected')

    console.log @currentSelector

  onFieldCeilClick: (e)=>
    return unless @currentSelector?

    ceil_el = $(e.currentTarget)
    row = ceil_el.data("row")
    col = ceil_el.data("col")

    console.log "row:", row, "col:", col

    console.log layers = @newData.tiles[row][col]

    layers[@layers.indexOf(@currentSelector[1])] = (
      if @currentSelector[0] == "delete"
        -1
      else
        @editor.elements.indexOf(@currentSelector[0])
    )

    ceil_el.replaceWith(@.renderTemplate("ceil",
      row: row
      col: col
      layers: layers
    ))

    @field_el.find(".ceil:odd").addClass('odd')

    console.log @newData.tiles[row][col]

  onSettingsTargetClick: (e)=>
    target_el = $(e.currentTarget)
    index = target_el.parents(".targets").data("index")

    target = @newData.targets[index]

    if target_el.data("target") == @editor.elements[target[0]]
      target[0] = -1
      target[1] = 0
      target_el.removeClass("selected")

    else
      target[0] = @editor.elements.indexOf(target_el.data("target"))
      target[1] = parseInt(@settings_el.find("input[name=target_#{ index + 1 }_count]").val(), 10)

      @settings_el.find(".targets[data-index=#{ index }] .target").removeClass("selected")
      target_el.addClass("selected")


    console.log target




