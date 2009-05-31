def form_for( ticket, template )
  output = %Q{<form method="post" action="/tickets/#{ticket['_id']}">
  <table id="edit ticket" border="0" cellpadding="0" cellspacing="0">\n}
  
  # all fields in template, sorted by template sort order
  template.keys.sort{ |a,b| template[a]['sort'].to_i <=> template[b]['sort'].to_i }.each do |field|
    if field =~ /^_.*$/
      output << %Q{<input type="hidden" name="ticket[#{field}]" value="#{ticket[field]}" />\n}
    else
      output << %Q{<tr>
      <td style="text-align:right"><strong>#{field.capitalize}</strong></td>
      <td>}
      if template[field]['edit']
        case template[field]['form']
        when 'select'
          output << %Q{<select name="ticket[#{field}]">\n}
          template[field]['values'].each { |value| output << "<option>#{value}</option>\n" }
          output << "</select>\n"
        when 'text'
          output << %Q{<input type="text" name="ticket[#{field}]" value="#{ticket[field]}" />}
        when 'textarea'
          output << %Q{<textarea name="ticket[#{field}]">#{ticket[field]}</textarea>}
        end
      else
        output << ticket[field] << %Q{<input type="hidden" name="ticket[#{field}]" value="#{ticket[field]}" />\n}
      end
      output << "</td>\n</tr>"
    end
  end
    output << %q{</table>
  <input type="submit" value="Save" />
  <input type="button" value="Cancel" />
  </form>}
end