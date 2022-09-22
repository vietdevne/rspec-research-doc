class ArrayWithOneElement < Array
  def initialize(*)
    super
    unshift "first element"
  end
end

RSpec.describe Array do
  describe ArrayWithOneElement do
    context "referenced as subject" do
      it "contains one element" do
        expect(subject).to include("first element")
      end
    end
  end
end
