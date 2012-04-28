class String
  def to_safe_uri
    self.strip.downcase.gsub('&', 'and').gsub(' ', '-').gsub(/[^\w-]/,'')
  end

  def briefiate(size=20)
    s = self.remove_html.strip
    if s.length > size
      p = s.rindex(' ', size) || size
      s = s[0..p-1] + '...'
    end
    return s
  end

  def normalize_phone!
    self.gsub!(/\D/, "")
  end

  def remove_html
    tokenizer = HTML::Tokenizer.new(self)
    result = ""
    while token = tokenizer.next
      if token[0..0] == "<"
        result << " "
      else
        result << token
      end
    end
    result
  end


end
