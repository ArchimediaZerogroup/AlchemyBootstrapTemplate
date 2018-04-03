class ContactForm < UserSiteRegistration
  store :serialized_data, accessors: [
    :check_privacy,
    :first_name,
    :last_name,
    :address,
    :city,
    :telephone,
    :message
  ], coder: JSON

  attribute :first_name, :string
  attribute :last_name, :string
  attribute :address, :string
  attribute :city, :string
  attribute :telephone, :string
  attribute :message, :string
  attribute :check_privacy, :boolean

  validates :first_name,
            :last_name,
            :message,
            :presence => { allow_blank: false }

  validates :check_privacy, inclusion: [true, '1']

end