# frozen_string_literal: true
# This is needed to count up and down the rails of the fence

def initialize_rail_assignments_array(number_of_rails)
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
