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
    "moves": 15
  }

  selectors: {
    tiles: [
      "empty", "random", "tile_blue", "tile_cyan", "tile_green", "tile_orange", "tile_purple", "tile_red", "tile_yellow",
      "sump_hatch"
    ],

    backing: ["road_tile"],
    modifiers: ["stump", "ribbon_1"],
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

  render: ->
    @html(@.renderTemplate("index"))


  ceilStylePosition: (row, col)->
    "top: #{ row * @ceilSize }px; left: #{ col * @ceilSize }px;"

  targetOptions: ->
    result = []

    for target in @editor.targets
      result.push [target, @editor.elements.indexOf(target)]

    result

  onSelectorElementClick: (e)=>
    element = $(e.currentTarget)

    @selector_el.find(".element").removeClass("selected")

    if @currentSelector? && element.data("element") == @currentSelector[0]
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

