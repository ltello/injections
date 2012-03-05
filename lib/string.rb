# -*- coding: utf-8 -*-
class String

  # Add quotes to the beginning and end of a string. Can be single or doubled quotes depending of
  # parameter <type> (defaults to :double):
  #     'alex'.stringify            #=> '"alex"'
  #     'alex'.stringify(:double)   #=> "'alex'"
  #     'alex'.stringify(:single)   #=> '"alex"'
  def stringify(tipo=:double)
    delimiter = tipo == :single ? "'" : '"'
    "#{delimiter}%s#{delimiter}" % self
  end

  # Máximum number included in a string.
  def max_included_number
    self.scan(/\d+/).map(&:to_i).max
  end

  # force utf-8 encoding
  def encoding_word_to_utf8
    self.dup.force_encoding(Encoding::UTF_8)
  end

  # Changes a string into a upper version, in utf-8 without accents
  def encodig_word_to_upper_clean_utf8
    self.dup.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s.upcase.force_encoding(Encoding::UTF_8)
  end

end
