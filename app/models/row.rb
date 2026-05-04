class Row
  attr_accessor :items

  def to_json
    result = {}
    items.each do |item|
      result[item.field.name] = item.value
    end
    result.to_json
  end
end
