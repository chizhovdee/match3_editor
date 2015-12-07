window.Utils =
  renderTemplate: (name, attributes...)->
    JST["views/#{ name }"](_.extend({}, @, attributes...))

  deepClone: (obj)->
    if _.isObject(obj)
      if _.isArray(obj)
        @.cloneArray(obj)
      else
        @.clone(obj)
    else
      obj

  clone: (obj)->
    newObj = {}

    for key, value of obj
      if _.isObject(value)
        newObj[key] = if _.isArray(value) then @.cloneArray(value) else @.clone(value)
      else
        newObj[key] = value

    newObj

  cloneArray: (arr)->
    newArr = []

    for value in arr
      if _.isObject(value)
        newArr.push(if _.isArray(value) then @.cloneArray(value) else @.clone(value))
      else
        newArr.push(value)

    newArr