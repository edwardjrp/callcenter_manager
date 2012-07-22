var Cart;

Cart = require('./schema').Cart;

Cart.validatesPresenceOf('user_id');

module.exports = Cart;
