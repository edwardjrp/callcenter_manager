json.array! @categories  do |json, category|
 json.id category.id
 json.name category.name
 json.products category.products
end