module MassAssignmentMacros
  def save_without_massasignment(model, attributes={})
    instance = model.new
    instance.assign_attributes(attributes, :without_protection => true)
    instance.save!
    return instance
  end
end