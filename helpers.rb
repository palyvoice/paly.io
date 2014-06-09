# helpers

def host
  ENV['PALYIO_HOSTNAME']
end

def gen_rand size=6
  # tries to avoid confusion inside set of numbers and letters
  charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T U W X Y Z}
  (0...size).map{ charset.to_a[rand charset.size] }.join
end

def fetch_url key
  # case insensitive
  Link.first :shortkey => key.upcase
end

def key_exists? key
  fetch_url(key) != nil
end

def save_url key, url
  Link.create :shortkey => key, :url => url
end

def gen_key size=6, num_attempts=0
  attempt = gen_rand size
  if key_exists? attempt
    # don't endlessly recurse
    return gen_key size+1 if num_attempts > 9
    return gen_key size, num_attempts+1
  else
    return attempt
  end
end

def build_stats link
  {
    :key => link.shortkey,
    :created_at => link.created_at,
    :hit_count => link.hit_objs.length,
    :hits => link.hit_objs
  }
end

def classify_long long
  case long
    # email: has anything@anything.anything
  when /.+@.+\..+/
    long = "mailto:#{long}" if not long[/^mailto:/]
    return long, :email

    # url: has (an http/https (maybe) followed by slashes) (maybe) followed by anything .anything (maybe)
  when /^(https?:\/\/)?.+(\..+)?/
    long = "http://#{long}" if not long[/^https?/]
    return long, :url

    # otherwise...
  else
    return long, :invalid
  end
end

def valid_key? key
  # five or more letters/digits/underscores/dashes, no leading/trailing underscores/dashes
  exp = /^[a-zA-Z0-9]([\w]|-){3,}[a-zA-Z0-9]$/

  # doesn't match our requirements
  if (key =~ exp) != 0
    return false, 'URL is too short or does not have only alphanumeric, underscore, and dash characters.'
  elsif key_exists? key
    return false, 'URL already exists.'
  else
    return true, 'URL is valid.'
  end

  # matches regex and does not already exist
  #return (key =~ exp) == 0 && !key_exists?(key)
end

def method_missing meth, *args, &block
  if meth.to_s =~ /^gen_(.+)_response$/
    generic_response $1, *args
  else
    super
  end
end

def generic_response type, *args
  { :response_type => type.to_sym, :success => args[0], :response => args[1], :comment => args[2] }
end
