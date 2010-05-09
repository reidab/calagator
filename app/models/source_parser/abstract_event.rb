class SourceParser
  AbstractEvent = Struct.new(
    :title,
    :description,
    :start_time,
    :end_time,
    :url,
    :location,
    :tag_list)
end
