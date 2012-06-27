describe "Input restrictor", ->
  it "should only forbid letters", ->
    loadFixtures("generic_form.html")
    $('input#restricted').restric 'alpha'
    keypress = $.Event('keypress')
    keypress.which = 97
    $('input#restricted').trigger keypress
    expect( $('input#restricted').text() ).toEqual('')