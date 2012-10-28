Store = require('../models/store')

class Stores
  
  @schedule: (data, respond) =>
    if data?
      Store.find data.store_id, (err, store) ->
        if err
          console.log err.stack
          respond err
        else
          store.schedule(respond)
          


module.exports = Stores