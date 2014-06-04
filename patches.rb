class PalyIO; end

class Hash
  # Return a hash that includes everything but the given keys. This is useful for
  # limiting a set of parameters to everything but a few known toggles:
  #
  #   @person.update_attributes(params[:person].except(:admin))
  #
  # If the receiver responds to +convert_key+, the method is called on each of the
  # arguments. This allows +except+ to play nice with hashes with indifferent access
  # for instance:
  #
  #   {:a => 1}.with_indifferent_access.except(:a)  # => {}
  #   {:a => 1}.with_indifferent_access.except("a") # => {}
  #
  def except(*keys)
    dup.except!(*keys)
  end

  # Replaces the hash without the given keys.
  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end

  def only(*keys)
    Hash[*dup.select {|k,v| keys.include?(k)}.flatten]
  end

  def only_sym(*keys)
    Hash[*dup.select {|k,v| keys.include?(k.to_sym)}.flatten]
  end

  def attribute_replace(before, after)
    hash = dup
    hash[after] = hash[before]
    hash.delete before
    hash
  end
end

module DataMapper
  module Resource
    def with_attributes(*attrs)
      self.attributes.merge(Hash[attrs.map {|k| [k, self.send(k)]}])
    end

    def attribute_replace(before, after)
      hash = self.attributes if self.attributes
      hash[after] = hash[before]
      hash.delete(before)
    end
  end
end
