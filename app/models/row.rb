class Row
  attr_accessor :items

  def get_value(field_name)
    items.select { |item| item.field.name == field_name }.first.value
  end

  def to_json
    result = {}
    items.each do |item|
      result[item.field.name] = item.value
    end
    result.to_json
  end
end
