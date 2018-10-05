class Invention < ApplicationRecord
  validates_presence_of :title
  validates_uniqueness_of :title

  validate :bits, :validate_bits

  private

  def validate_bits
    self.bits = (bits.to_set & BITS.to_set).to_a

    if bits.empty?
      errors.add(:type, 'must be specified')
    end
  end
end
