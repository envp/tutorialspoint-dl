B_SELECT_BY_SUBJECT = Proc.new { |link, property, subject| link[property].include? subject }

B_MAP_TO_PDF        = Proc.new { |link| link.split('/').insert(2, 'pdf').join('/').gsub(/htm(l)?/, 'pdf') }
