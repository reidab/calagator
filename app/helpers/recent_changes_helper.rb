module RecentChangesHelper
  # Return HTML representing the +object+, which is either its text or a stylized "nil".
  def text_or_nil(object)
    if object.nil?
      return content_tag("em", "nil")
    else
      return h(object)
    end
  end

  # Return an hash of changes for the given +Version+ record. The resulting
  # data structure is a hash whose keys are the names of changed columns and
  # values containing an array with the current and previous value. E.g.,:
  #
  #   {
  #     "my_column_name" => ["current_value", "past value"],
  #     ...
  #   }
  def changes_for(version)
    changes = {}
    current = version.next.ergo.reify
    previous = version.reify
    record = version.item_type.constantize.find(version.item_id) rescue nil

    case version.event
    when "create"
      current ||= record
    when "update"
      current ||= record
    when "destroy"
      previous ||= record
    else
      raise ArgumentError, "Unknown event: #{version.event}"
    end

    (current or previous).attribute_names.each do |name|
      next if name == "updated_at"
      next if name == "created_at"
      current_value = current.read_attribute(name) if current
      previous_value = previous.read_attribute(name) if previous
      unless current_value == previous_value
        changes[name] = [current_value, previous_value]
      end
    end

    return changes
  rescue Exception => e
    require 'rubygems'; require 'ruby-debug'; Debugger.start; debugger; 1 # FIXME
  end
end
