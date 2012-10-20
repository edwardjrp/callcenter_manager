Cart = require('../../dst/models/cart')

describe 'Cart', ->
  describe '#simplified', ->
    cart = new Cart({ user_id: 1 })
    it 'should return a json format of the cart', ->
      cart.simplified().should.eql(cart.toJSON())