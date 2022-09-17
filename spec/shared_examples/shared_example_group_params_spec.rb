RSpec.shared_examples "a measurable object" do |measurement, measurement_methods|
  measurement_methods.each do |measurement_method|
    it "should return #{measurement} from ##{measurement_method}" do
      expect(subject.send(measurement_method)).to eq(measurement)
    end
  end
end

RSpec.describe Array, "with 3 items" do
  subject { [1, 2, 3] }
  it_should_behave_like "a measurable object", 3, [:size, :length]
end

RSpec.describe String, "of 6 characters" do
  subject { "FooBar" }
  it_should_behave_like "a measurable object", 6, [:size, :length]
end
  