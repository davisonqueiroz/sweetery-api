class Supplier < ApplicationRecord
  include UniqueStringNormalizer
  normalizer :name, :company_name, :fantasy_name

  require "cpf_cnpj"

  attr_readonly :created_by_id, :document, :type_supplier

  validate :attributes_match_supplier_type
  validate :attribute_values_valid
  validates :type_supplier, presence: true
  validates :document, presence: true, uniqueness: true
  validates :active, inclusion: { in: [ true, false ] }
  validates :created_by, presence: true
  enum :type_supplier, { pf: 0, pj: 1 }
  validates :name, uniqueness: true, allow_nil: true
  validates :fantasy_name, uniqueness: true, allow_nil: true
  validates :company_name, uniqueness: true, allow_nil: true

  belongs_to :created_by, class_name: "User"

  private

  def attributes_match_supplier_type
    if pj? && (company_name.blank? || name.present?)
      errors.add(:type_supplier, "to supplier 'pj' type, at least company_name is required")
    end
    if pf? && (name.blank? || company_name.present? || fantasy_name.present?)
      errors.add(:type_supplier, "from pf supplier, only name is required")
    end
  end

  def attribute_values_valid
    if pf? && !CPF.valid?(document)
      errors.add(:document, "must be a valid CPF")
    elsif pj? && !CNPJ.valid?(document)
      errors.add(:document, "must be a valid CNPJ")
    end
  end
end
