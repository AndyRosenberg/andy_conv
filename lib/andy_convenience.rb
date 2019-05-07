require 'securerandom'

class String
  def to_binary
    ascii = []
    self.each_byte {|char| ascii << char}
    ascii.map{ |n| n.to_binary }.join(' ')
  end

  def webitize(tag, options = nil)
    if options
      options = ' ' + (options.map {|k, v| "#{k}='#{v}'"}.join(' '))
    end
    "<#{tag}#{options}>#{self}</#{tag}>"
  end

  def crunch(str)
    str.chars.chunk{|s| s}.map(&:first).join
  end

  def -(n)
    str = self
    n.times { str = str.chop }
    str
  end

  def /(n)
    left = self.size % n
    reg = Regexp.new(".{#{n}}")
    res = self.scan(reg)
    res += [self[(0 - left)..-1]]
  end

  def stringcrement(interval = 1, operator = :+, seq = 1)
    self.to_i.stringcrement(interval, operator, seq)
  end

  def increment(interval = 1, operator = :+, seq = 1)
    self.to_i.increment(interval, operator, seq)
  end

  def indexment(coll, interval = 1, operator = :+, seq = 1)
    coll[self.increment(interval, operator, seq)]
  end

  def idx(coll)
    coll[self.to_i - 1]
  end

  alias_method :strc, :stringcrement
  alias_method :stinc, :increment
  alias_method :idxmt, :indexment
  alias_method :to_web, :webitize
end

class Integer
  def increment(interval = 1, operator = :+, seq = 1)
    int = self
    seq.times { int = int.send(operator.to_sym, interval) }
    int
  end

  def stringcrement(interval = 1, operator = :+, seq = 1)
    self.increment(interval, operator, seq).to_s
  end

  def to_tkn
    SecureRandom.urlsafe_base64(self)
  end

  def to_binary
    final_string = ''
    bins = binlib.select { |n| n <= self }.reverse
    return '0' if bins.empty?
    return '1' if bins[0] == 1
    final_string << '1'
    difference = self - bins[0]
    bins[1..-1].each do |bin|
      if difference >= bin
        final_string << '1'
        difference -= bin
      else
        final_string << '0'
      end
    end
    final_string
  end

  alias_method :strc, :stringcrement
  alias_method :inc, :increment

  private

  def binlib
    counter = 0
    library = []
    until counter == 1000
      library << (2 ** counter)
      counter += 1
    end
    library
  end
end

class Array
  def /(n)
    self.each_slice(n).to_a
  end

  def max_count
    context = self
    counts = context.group_by do |i|
        context.count(i)
      end.max_by {|k, v| k}.last.uniq
  
    counts.one? ? counts.first : counts
  end
end
