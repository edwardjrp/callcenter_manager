var Option,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Option = (function() {

  function Option(code, quantity, part) {
    this.code = code;
    this.quantity = quantity;
    this.part = part;
    this.toPulse = __bind(this.toPulse, this);

  }

  Option.prototype.toPulse = function() {
    if (Number(this.quantity) === 1) {
      return "" + this.code + "-" + this.part;
    } else {
      return "" + this.quantity + this.code + "-" + this.part;
    }
  };

  Option.pulseCollection = function(array) {
    var opt, result, _i, _len;
    result = [];
    for (_i = 0, _len = array.length; _i < _len; _i++) {
      opt = array[_i];
      result.push(new Option(opt.code, opt.quantity, opt.part).toPulse());
    }
    console.log(result);
    return result.join(',');
  };

  return Option;

})();

module.exports = Option;
