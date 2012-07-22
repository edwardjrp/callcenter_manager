var Config, pg;

pg = require('pg');

Config = (function() {

  function Config() {}

  Config.host = "localhost";

  Config.username = "radhamesbrito";

  Config.password = "siriguillo";

  Config.db = "kapiqua_development";

  Config.connection_string = "postgres://" + Config.username + ":" + Config.password + "@" + Config.host + "/" + Config.db;

  return Config;

})();

module.exports = Config;
