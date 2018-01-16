Spree::Address.class_eval do
  validates :address3, presence: true, if: Proc.new { |a| a.country.name == 'México' }
end
