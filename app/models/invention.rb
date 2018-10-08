class Invention < ApplicationRecord
  BITS = YAML.load_file('lib/assets/bits.yml')

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :bits
  validate :bits_type
  validate :bits_count_and_type
  validate :bits_name

  scope :where_bit_names_are, ->(bit_names) { where('bits ?| array[:keys]', keys: bit_names) }

private

  def bits_type
    unless bits.is_a? Hash
      begin
        JSON.parse(bits.to_s)
      rescue JSON::ParserError
        errors[:validation] << "not in JSON format. Please enter key as a bit name and value as a bit count, e.g. {'led': '1'}"
      end
    end
  end

  def bits_count_and_type
    if bits.is_a? Hash
      bit_counts = bits.values.map {|v| v.to_i} #ensures to convert not number string values to integers
      errors[:validation] << "bits value can't be 0 or not a number. Invention has to have at least 1 bit" if bit_counts.include? 0
    end
  end

  def bits_name
    if bits.is_a? Hash
      invalid_names = bits.keys.select {|b| !BITS.include? b}
      invalid_names_text = invalid_names.length > 1 ? invalid_names.join(', ') : invalid_names.first
      errors[:validation] << "These bit names are not present in our stock: #{invalid_names_text}" unless invalid_names.empty?
    end
  end
end
