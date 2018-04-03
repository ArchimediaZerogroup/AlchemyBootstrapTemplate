class FormNewsletter < UserSiteRegistration
  store :serialized_data, accessors: [:check_privacy], coder: JSON

  attribute :check_privacy, :boolean

  validates :check_privacy, inclusion: [true, '1']
end