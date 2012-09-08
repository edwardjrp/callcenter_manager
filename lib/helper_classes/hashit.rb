class Hashit
  def initialize(hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v)
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
    end
  end

  def save
    hash_to_return = {}
    self.instance_variables.each do |var|
      hash_to_return[var.gsub("@","")] = self.instance_variable_get(var)
    end
    return hash_to_return
  end
end