var Config;

Config = (function() {

  function Config() {}

  Config.host = "localhost";

  Config.username = function() {
    switch (process.env.NODE_ENV) {
      case 'production':
        return "proteus";
      case 'development':
        return 'radhamesbrito';
      case 'test':
        return 'radhamesbrito';
      default:
        return 'radhamesbrito';
    }
  };

  Config.password = function() {
    switch (process.env.NODE_ENV) {
      case 'production':
        return "u5bl4ck";
      case 'development':
        return 'siriguillo';
      case 'test':
        return 'siriguillo';
      default:
        return 'siriguillo';
    }
  };

  Config.db = function() {
    switch (process.env.NODE_ENV) {
      case 'production':
        return "kapiqua_" + process.env.NODE_ENV;
      case 'development':
        return "kapiqua_" + process.env.NODE_ENV;
      case 'test':
        return "kapiqua_" + process.env.NODE_ENV;
      default:
        return "kapiqua_development";
    }
  };

  Config.connection_string = "postgres://" + (Config.username()) + ":" + (Config.password()) + "@" + Config.host + "/" + (Config.db());

  return Config;

})();

module.exports = Config;
