require 'uri'
require 'debugger'

class Params
  attr_accessor :params 
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  def initialize(req, route_params = {})
    @params = Hash.new { |hash, key| hash[key] = 
      Hash.new { |hash, key| hash[key] = 
        Hash.new { |hash, key| hash[key] = "" } } } #triple nested hash
    parse_www_encoded_form(req.query_string) unless req.query_string.nil?
    parse_www_encoded_form(req.body) unless req.body.nil?
    @params.merge!(route_params) unless route_params.nil?

  end

  def [](key)
    params[key]
  end

  #calls permitted on all keys?
  def permit(*keys)
    keys.all? do |key|
      permitted?(key)
    end
  end

  def require(key)
  end

  def permitted?(key)
    !@params[key].nil?
  end

  def to_s
    @params.to_json
  end



  private
  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  def parse_www_encoded_form(www_encoded_form)
  
    decode = URI::decode_www_form(www_encoded_form)
    decode.each do |mult| # each of these the left element is key, right element is value
       nests = mult.first.split("[").flatten.map {|s| s.delete("[]")}
      # nests = mult.first.split(/\]\[|\[|\]/)
      if nests.nil?
       @params[mult.first] = mult.last
      elsif nests.length == 2
        @params[nests[0]][nests[1]]= mult.last
      elsif nests.length == 3
        @params[nests[0]][nests[1]][nests[2]] = mult.last
      elsif nests.length ==1 
        @params[mult.first] = mult.last
      end
  
    end
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.split("/\]\[|\[|\]/")
  end
  
  class AttributeNotFoundError < ArgumentError; end;
end
