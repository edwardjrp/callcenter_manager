class Option
  constructor: (@code, @quantity, @part)->

  toPulse: =>
    if Number(@quantity) == 1 then "#{@code}-#{@part}" else "#{@quantity}#{@code}-#{@part}"

  @pulseCollection: (array)->
    result = []
    for opt in array
      result.push new Option(opt.code, opt.quantity, opt.part ).toPulse()
    console.log result
    result.join(',')



module.exports = Option

