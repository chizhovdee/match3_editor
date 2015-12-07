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
    "points": [0, 0] #[two stars, three stars]
    "targets": [[-1, 0], [-1, 0], [-1, 0]] # [[index element, count]], -1 empty task
  }

  constructor: ->
    super

    @currentSelector = null # [element, group]

    @currentData = @.deepClone(@editor.current_data)

    @newData = if _.isEmpty(@editor.current_data)
      @.deepClone(@defaultData)
    else
      @.deepClone(@editor.current_data)

    @.bindEventListeners()
    @.render()

    @el.find("button.save").hide()

    @.checkChanges()

    @field_el.find(".ceil:odd").addClass('odd')

  bindEventListeners: ->
    @el.on("click", '.selector .element', @.onSelectorElementClick)
    @el.on("click", '.field .ceil', @.onFieldCeilClick)
    @el.on("click", '.settings .target', @.onSettingsTargetClick)
    @el.on("click", "button.save:not(.disabled)", @.onSaveButtonClick)
    @el.on("keyup", "input[type=text]", @.onInputChange)

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

  onFieldCeilClick: (e)=>
    return unless @currentSelector?

    ceil_el = $(e.currentTarget)
    row = ceil_el.data("row")
    col = ceil_el.data("col")

    layers = @newData.tiles[row][col]

    layers[@editor.layers.indexOf(@currentSelector[1])] = (
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

    @.checkChanges()

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

    @.checkChanges()

  onSaveButtonClick: (e)=>
    $(e.currentTarget).addClass("disabled")

    alertError = (msg)=>
      alert(msg)

      @el.find(".save").removeClass("disabled")

    value = parseInt(@settings_el.find("input[name=moves]").val(), 10)

    if _.isNaN(value) || value < 0
      alertError('Неправильное значение поля "Количество ходов"')

      return

    value = parseInt(@settings_el.find("input[name=points_two_stars]").val(), 10)

    if _.isNaN(value) || value < 0
      alertError('Неправильное значение поля "Количество очков (две звезды)"')

      return

    value = parseInt(@settings_el.find("input[name=points_three_stars]").val(), 10)

    if _.isNaN(value) || value < 0
      alertError('Неправильное значение поля "Количество очков (три звезды)"')

      return

    for target, index in @newData.targets
      continue if target[0] == -1

      value = parseInt(@settings_el.find("input[name=target_#{ index + 1 }_count]").val(), 10)

      if _.isNaN(value) || value < 0
        alertError('Неправильное значение поля "Цель ' + (index + 1) + '"')

        return

    if @editor.level_id
      $.ajax(
        url: "/levels/#{ @editor.level_id }"
        type: 'PUT'
        data: data: JSON.stringify(@newData)
        success: (response)=> alert response.result
      )

    else
      $.post("/levels", data: JSON.stringify(@newData), (response)=>
        alert response.result
      )

  onInputChange: (e)=>
    input_el = $(e.currentTarget)

    value = parseInt(input_el.val(), 10)

    if _.isNaN(value) || value < 0
      alert('Не кооректное значение')

      return

    switch input_el.attr("name")
      when "moves"
        @newData.moves = value
      when "points_two_stars"
        @newData.points[0] = value
      when "points_three_stars"
        @newData.points[1] = value
      when "target_1_count"
        @newData.targets[0][1] = value
      when "target_2_count"
        @newData.targets[1][1] = value
      when "target_3_count"
        @newData.targets[2][1] = value

    @.checkChanges()

  checkChanges: ->
    button = @el.find("button.save")

    # проверяем настройки
    if @newData.moves != @currentData.moves || @newData.points[0] != @currentData.points[0] ||
       @newData.points[1] != @currentData.points[1]

      return button.show()

    for target, index in @newData.targets
      if target[0] != @currentData.targets[index][0] || target[1] != @currentData.targets[index][1]
        return button.show()

    # проряем тайлы
    for cols, row in @newData.tiles
      for layers, col in cols
        for layer, index in layers
          if layer != @currentData.tiles[row][col][index]
            return button.show()

    button.hide()


