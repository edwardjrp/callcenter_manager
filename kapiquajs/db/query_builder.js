var _ = require('underscore');


module.exports = Builder;

function Builder() {}

Builder.prototype.create = function(table_name, element){
  fields = _.toArray(_.keys(element));
  values = _.toArray(_.values(element));

  fields_list = '"'+fields.join('\",\"')+'"';
  values_list = '"'+values.join('\",\"')+'"';
  key_list = [];
  for(i = 1; i <= fields.length; i++){ key_list.push('$'+i)}
  key_value = [];
  for(i = 0; i < fields.length; i++){ key_value.push('[\"'+fields[i]+'\",\"'+values[i]+'\"]')}
  key_value_match   = '['+key_value.join(',')+']'
  return 'INSERT INTO "'+table_name+'" ('+fields_list+') VALUES ('+key_list+') RETURNING "id" '+key_value_match+'';
}

