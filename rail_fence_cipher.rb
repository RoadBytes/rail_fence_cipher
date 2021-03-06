require 'pry'

# TODO: consider FenceDecoder and FenceEncoder
class Fence
  # Groups up rails
  # adds char to appropriate rail
  # knows about assignment_array (alternating rails pattern)

  # A fence should know about how many letters there are per rail

  attr_reader   :rail_assignments_array, :number_of_rails
  # TODO: TODO First!!!! consider renaming to alternating_rail_array
  # TODO: TODO First!!!! have a method get_rail_for(char_number)
  attr_accessor :rails_hash

  def initialize(number_of_rails)
    @number_of_rails = number_of_rails
    @rail_assignments_array = set_rail_assignments_array(
      number_of_rails
    )
    @rails_hash = set_rails_hash(number_of_rails)
  end

  def set_rail_assignments_array(number_of_rails)
    # counts up to last rail and back down to 1
    # [0, 1, 2, ... n, n - 1, ..., 1]
    # for 4 rails => [0, 1, 2, 3, 2, 1]
    return [0] if number_of_rails == 1

    array      = []
    last_rail  = number_of_rails - 1
    array_size = 2 * last_rail - 1
    (0..array_size).each do |value|
      if value < number_of_rails
        array << value
      else
        offset = value % last_rail
        array << (last_rail - offset)
      end
    end

    array
  end

  def add_characters_of(message)
    # break message into chars
    message.split('').each_with_index do |letter, index|
      # add char into fence depending on index
      rail_index = index % self.rail_assignments_array.size
      rail_key = rail_assignments_array[rail_index]
      binding.pry if rails_hash[rail_key].nil?
      self.rails_hash[rail_key] << letter
    end
  end

  # TODO: reverse add_characters_of
  def read_off_rails
    @message = ''
    # read off of rail depending on index
    @message_size.times do |index|
      rail_index  = index % self.rail_assignments_array.size
      rail_number = rail_assignments_array[rail_index]
      @message << rails_hash[rail_number].shift
    end
    @message
  end


  def add_chunks_to_rails(encrypted_message)
    temp_encripted_message = encrypted_message.split('')
    rail_number = 0
    rails_chunk_sizes(encrypted_message).each do |rail_size|
      rail_size.times do
        rails_hash[rail_number] << temp_encripted_message.shift
      end
      rail_number += 1
    end
  end

  def rails_chunk_sizes(message)
    temp_fence = Fence.new(number_of_rails)
    temp_fence.add_characters_of(message)
    temp_rails_hash = temp_fence.rails_hash
    temp_rails_hash.values.map {|rail_chunk| rail_chunk.size}
  end

  def set_rails_hash(number_of_rails)
    hash = {}
    number_of_rails.times do |number|
      hash[number] = []
    end
    hash
  end

  def encrypted_message
    rails_hash.values.join
  end

  def encode(message)
    add_characters_of(message)
    encrypted_message
  end

  def decode(encrypted_message)
    @message_size = encrypted_message.size
    add_chunks_to_rails(encrypted_message)
    read_off_rails
  end

  def rails_hash_not_empty
    rails_hash.any? {|rail_number, value_array| value_array.size > 0}
  end
end


class RailFenceCipher
  def self.encode(message, number_of_rails)
    fence = Fence.new(number_of_rails)
    fence.encode(message)
  end

  def self.decode(message, number_of_rails)
    fence = Fence.new(number_of_rails)
    fence.decode(message)
  end
end
