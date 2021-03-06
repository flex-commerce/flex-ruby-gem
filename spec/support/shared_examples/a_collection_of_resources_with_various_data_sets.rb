#
# A range of examples for a collection of resources
#
# Expects the resource type to be passed as a parameter in singular form (e.g. :product)
# Then, it expects shared examples to be defined for "a collection of #{resource_type}"
shared_examples_for("a collection of resources with various data sets") do |resource_type: ""|
  resource_type = resource_type.to_s.humanize.downcase.pluralize
  #
  # Using a small data set (10 records)
  #
  context "with a small data set" do
    let(:quantity) { 10 }
    let(:current_page) { nil }
    context "finding multiple resources" do
      it_should_behave_like "a collection of #{resource_type}"
    end
  end
  #
  # Using a medium data set (50 records)
  #
  context "with a medium data set" do
    let(:quantity) { 50 }
    context "on undefined page" do
      let(:current_page) { nil }
      it_should_behave_like "a collection of #{resource_type}"
    end
    context "on page 1" do
      let(:current_page) { 1 }
      it_should_behave_like "a collection of #{resource_type}"
    end
    context "on page 2" do
      let(:current_page) { 2 }
      it_should_behave_like "a collection of #{resource_type}"
    end
  end
  #
  # Using a large data set (100 records)
  #
  context "with a large data set" do
    let(:quantity) { 100 }
    let(:current_page) { 2 }
    it_should_behave_like "a collection of #{resource_type}"
  end
end
