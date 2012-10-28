Store = require('./schema').Store
_ = require('underscore')
libxmljs = require("libxmljs")
PulseBridge = require('../pulse_bridge/pulse_bridge')
Setting = require('../models/setting')

Store.prototype.schedule = (respond, socket) ->
  me = this
  Setting.kapiqua (err, settings) ->
    if err
      console.error err.stack
    else
      pulse_com_error = (comm_err) ->
        console.error comm_err.stack
        respond comm_err
      store_request = new PulseBridge(null, me.storeid, me.ip, settings.pulse_port)
      store_request.schedule pulse_com_error, (res_data)->
        doc = libxmljs.parseXmlString(res_data)
        schedule = doc.get('//StoreSchedule')
        console.log res_data
        console.log schedule
        console.log schedule.text()
        respond res_data




module.exports = Store