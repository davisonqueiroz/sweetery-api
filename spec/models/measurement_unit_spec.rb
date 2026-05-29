require 'rails_helper'

RSpec.describe MeasurementUnit, type: :model do
  describe "create measurement unit" do
    let!(:measurement_unit) { create(:measurement_unit) }
    context "when creation is sucessfull" do
      it "creates a measurement unit" do
        expect(measurement_unit).to be_valid
      end

      it "creates a measurement unit with uppercase in code" do
        measurement_unit = create(:measurement_unit, code: "Ml")

        expect(measurement_unit).to be_valid

        expect(measurement_unit.code).to match("ml")
      end

      it "creates a measurement unit with uppercase in name" do
        measurement_unit = create(:measurement_unit, name: "MiliLiteRs")

        expect(measurement_unit).to be_valid

        expect(measurement_unit.name).to match("mililiters")
      end

      it "creates a measurement unit with is_base true" do
        measurement_unit = create(:measurement_unit, is_base: true)

        expect(measurement_unit).to be_valid
      end

      it "creates a measurement unit with active is false" do
        measurement_unit = create(:measurement_unit, active: false)

        expect(measurement_unit).to be_valid
      end
    end

    context "when creation is invalid" do
      it "code already exists" do
        invalid_measurement = build(:measurement_unit, code: measurement_unit.code)

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:code]).to include("has already been taken")
      end

      it "name already exists" do
        invalid_measurement = build(:measurement_unit, name: measurement_unit.name)

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:name]).to include("has already been taken")
      end

      it "name is equal in downcase " do
        create(:measurement_unit, name: "microgram")

        invalid_measurement = build(:measurement_unit, name: "MicRogRAm")

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:name]).to include("has already been taken")
      end

      it "code is equal in downcase" do
        create(:measurement_unit, code: "mcg")

        invalid_measurement = build(:measurement_unit, code: "McG")

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:code]).to include("has already been taken")
      end

      it "name and code combination already exists" do
        invalid_measurement = build(:measurement_unit, name: measurement_unit.name, code: measurement_unit.code)

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:name]).to include("has already been taken")
        expect(invalid_measurement.errors[:code]).to include("has already been taken")
      end

      it "conversion_factor less than 0" do
        invalid_measurement = build(:measurement_unit, conversion_factor: -1)

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:conversion_factor]).to include("must be greater than 0")
      end

      it "conversion_factor equal to 0" do
        invalid_measurement = build(:measurement_unit, conversion_factor: 0)

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:conversion_factor]).to include("must be greater than 0")
      end

      it "conversion_factor non number value" do
        invalid_measurement = build(:measurement_unit, conversion_factor: "test")

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:conversion_factor]).to include("is not a number")
      end

      it "already exists dimension active with is_base true" do
        measurement_unit.update(is_base: true)

        invalid_measurement = build(:measurement_unit, is_base: true)

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:dimension]).to include("already exists base from this dimension.")
      end
    end

    context "creation is invalid because nil values" do
      it "active is nil" do
        invalid_measurement = build(:measurement_unit, active: nil)

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:active]).to include("is not included in the list")
      end

      it "is_base is nil" do
        invalid_measurement = build(:measurement_unit, is_base: nil)

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:is_base]).to include("is not included in the list")
      end

      it "code is nil" do
        invalid_measurement = build(:measurement_unit, code: nil)

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:code]).to include("can't be blank")
      end

      it "name is nil" do
        invalid_measurement = build(:measurement_unit, name: nil)

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:name]).to include("can't be blank")
      end

      it "dimension is nil" do
        invalid_measurement = build(:measurement_unit, dimension: nil)

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:dimension]).to include("can't be blank")
      end

      it "conversion_factor is nil" do
        invalid_measurement = build(:measurement_unit, conversion_factor: nil)

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:conversion_factor]).to include("can't be blank")
      end

      it "created_by is nil" do
        invalid_measurement = build(:measurement_unit, created_by: nil)

        expect(invalid_measurement).to be_invalid
        expect(invalid_measurement.errors[:created_by]).to include("can't be blank")
      end
    end
  end

  describe "update measurement_unit" do
    let!(:measurement_unit) { create(:measurement_unit) }
    context "when update is valid" do
      it "update active" do
        expect { measurement_unit.update(active: false) }.to change(measurement_unit, :active).from(true).to(false)
      end

      it "update is_base" do
        expect { measurement_unit.update(is_base: true) }.to change(measurement_unit, :is_base).from(false).to(true)
      end

      it "update conversion_factor" do
        expect { measurement_unit.update(conversion_factor: 100.00) }.to change(measurement_unit, :conversion_factor).from(measurement_unit.conversion_factor).to(100.00)
      end
    end

    context "when update to attribute is invalid" do
      it "update created_by" do
        other_user = create(:user)
        expect { measurement_unit.update(created_by_id: other_user.id) }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "update code" do
        expect { measurement_unit.update(code: "l") }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "update name" do
        expect { measurement_unit.update(name: "liter") }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end

      it "update dimension" do
        expect { measurement_unit.update(dimension: "volume") }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      end
    end

    context "when update transition is invalid" do
      it "already exists dimension active with is_base true" do
        measurement_unit.update(is_base: true)

        other_measurement = create(
          :measurement_unit,
          dimension: measurement_unit.dimension
          )

        other_measurement.is_base = true

        expect(other_measurement).to be_invalid
        expect(other_measurement.errors[:dimension]).to include("already exists base from this dimension.")
      end

      it "reactive measurement with is_base true" do
        measurement_unit.update(is_base: true)

        other_measurement = create(
          :measurement_unit,
          dimension: measurement_unit.dimension,
          is_base: true,
          active: false
          )

        other_measurement.active = true

        expect(other_measurement).to be_invalid
        expect(other_measurement.errors[:dimension]).to include("already exists base from this dimension.")
      end
    end

    context "when update required attributes to nil" do
      it "update is_base" do
        measurement_unit.is_base = nil

        expect(measurement_unit).to be_invalid
        expect(measurement_unit.errors[:is_base]).to include("is not included in the list")
      end

      it "update active" do
        measurement_unit.active = nil

        expect(measurement_unit).to be_invalid
        expect(measurement_unit.errors[:active]).to include("is not included in the list")
      end

      it "update conversion_factor" do
        measurement_unit.conversion_factor = nil

        expect(measurement_unit).to be_invalid
        expect(measurement_unit.errors[:conversion_factor]).to include("can't be blank")
      end
    end
  end
end
