var Setting, YAML;

Setting = require('./schema').Setting;

YAML = require('libyaml');

Setting.node_url = function(cb) {
  return this.all({
    "var": 'node_url'
  }, function(err, result) {
    if (err) {
      console.error(err);
      return cb(err);
    } else {
      return cb(err, YAML.parse(result.value)[0]);
    }
  });
};

Setting.priceStoreId = function(cb) {
  return this.all({
    "var": 'price_store_id'
  }, function(err, result) {
    if (err) {
      console.error(err);
      return cb(err);
    } else {
      return cb(err, YAML.parse(result.value)[0]);
    }
  });
};

Setting.priceStoreIp = function(cb) {
  return this.all({
    "var": 'price_store_ip'
  }, function(err, result) {
    if (err) {
      console.error(err);
      return cb(err);
    } else {
      return cb(err, YAML.parse(result.value)[0]);
    }
  });
};

Setting.pulsePort = function(cb) {
  return this.all({
    "var": 'pulse_port'
  }, function(err, result) {
    if (err) {
      console.error(err);
      return cb(err);
    } else {
      return cb(err, YAML.parse(result.value)[0]);
    }
  });
};

Setting.kapiqua = function(cb) {
  return Setting.all({}, function(err, results) {
    var kapiquaConfig, result, _i, _len;
    if (err) {
      console.error(err);
      return cb(err);
    } else {
      kapiquaConfig = {};
      for (_i = 0, _len = results.length; _i < _len; _i++) {
        result = results[_i];
        kapiquaConfig[result["var"]] = YAML.parse(result.value)[0];
      }
      return cb(err, kapiquaConfig);
    }
  });
};

module.exports = Setting;
