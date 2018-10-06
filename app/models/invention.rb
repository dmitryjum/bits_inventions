class Invention < ApplicationRecord
  BITS = YAML.load_file('lib/assets/bits.yml')

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :bits
  validate :bits_type
  validate :bits_count_and_type
  validate :bits_name

private

  def bits_type
    unless bits.is_a? Hash
      begin
        JSON.parse(bits.to_s)
      rescue JSON::ParserError
        errors[:bits] << "not in JSON format. Please enter key as a bit name and value as a bit count, e.g. {led: 1}"
      end
    end
  end

  def bits_count_and_type
    bit_counts = bits.values.map {|v| v.to_i} #ensures to convert not number string values to integers
    errors[:bits] << "bits value can't be 0 or not a number. Invention has to have at least 1 bit" if bit_counts.include? 0
  end

  def bits_name
    invalid_names = bits.keys.select {|b| !BITS.include? b}
    errors[:bits] << "These bit names are not present in our stock: #{invalid_names}" unless invalid_names.empty?
  end
end
