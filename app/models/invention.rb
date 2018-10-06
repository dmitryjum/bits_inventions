class Invention < ApplicationRecord
  validates_presence_of :title
  validates_uniqueness_of :title
  # validate :bits, :validate_bits

  BITS = YAML.load_file('lib/assets/bits.yml')

  private

  def validate_bits
    # binding.pry
    # self.bits = (bits.to_set & BITS.to_set).to_a

    # if bits.empty?
    #   errors.add(:bits, 'must be specified')
    # end
  end
end
