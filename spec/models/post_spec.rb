require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "Validations" do
    it "validate presence of required fields" do
      should validate_presence_of(:title)
      should validate_presence_of(:content)
      should validate_presence_of(:user)
    end
  end
end
