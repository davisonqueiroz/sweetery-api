module UniqueStringNormalizer
  extend ActiveSupport::Concern

  class_methods do
    def normalizer(*attributes)
      before_validation(on: :create) do
        attributes.each do |attribute|
          value = read_attribute(attribute)
          write_attribute(attribute, value.downcase) if value.present?
        end
      end
    end
  end
end
