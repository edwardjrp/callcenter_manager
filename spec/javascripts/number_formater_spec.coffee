describe "NumberFormatter", ->
  it "Should present the number as a phone number", ->
    expect(NumberFormatter.to_phone('8095080393')).toEqual '809-508-0393'
  it "Should present the number as an id", ->
    expect(NumberFormatter.to_id('00113574339')).toEqual '001-1357433-9'
  it "Should present the number as clear", ->
    expect(NumberFormatter.to_clear('001-1357433-9')).toEqual '00113574339'