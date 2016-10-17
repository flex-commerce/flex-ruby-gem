require "e2e_spec_helper"
RSpec.describe "Variants API end to end spec", vcr: true do
  # As the "before context" blocks cannot access let vars, the "context store" simply defines a method called "context_store"
  # that stores whatever you want - it is an "OpenStruct" so you can just write anything to it and read it back at any time
  # This is cleared at the start of the context, but the idea is so that you can share stuff between examples.
  # This obviously means that the examples are tied together - in terms of the read, update and delete methods all rely
  # on having created an object in the first place.
  # This also means that this test suite must be run in the order defined, not random.
  include_context "context store"

  # We define the model in advance, mainly allowing the code in the examples to be fairly generic and can be copied / pasted
  # into other tests without changing the model all over the place.
  let(:model) { FlexCommerce::Variant }

  # A few convenience lets just to avoid writing context_store.uuid for example
  let(:uuid) { context_store.uuid }
  let(:created_resource) { context_store.created_resource }
  let(:created_product) { context_store.foreign_resources[:product] }

  # As setting up for testing can be very expensive, we do it only at the start of then context
  # it is then our responsibility to tidy up at the end of the context.
  before(:context) do
    context_store.uuid = SecureRandom.uuid
    context_store.foreign_resources = OpenStruct.new
    context_store.foreign_resources[:product] = FlexCommerce::Product.create! title: "Title for product 1 for variant #{context_store.uuid}",
                                                                              reference: "reference for product 1 for variant #{context_store.uuid}",
                                                                              content_type: "markdown"
  end
  # Clean up time - delete stuff in the reverse order to give us more chance of success
  after(:context) do
    context_store.created_resource.destroy unless context_store.created_resource.nil? || !context_store.created_resource.persisted?
    context_store.foreign_resources.values.reverse.each do |resource|
      resource.destroy if resource.persisted?
    end
  end

  context "#create" do
    it "should not persist and have errors when invalid attributes are used" do

    end
    it "should persist when valid attributes are used" do
      context_store.created_resource = subject = model.create title: "Title for Test Variant #{uuid}",
                                                              description: "Description for Test Variant #{uuid}",
                                                              reference: "reference_for_test_variant_#{uuid}",
                                                              price: 5.50,
                                                              price_includes_taxes: false,
                                                              sku: "sku_for_test_variant_#{uuid}",
                                                              product_id: created_product.id
      expect(subject.errors).to be_empty
      expect(http_request_tracker.first[:response]).to match_response_schema("jsonapi/schema")
      expect(http_request_tracker.first[:response]).to match_response_schema("shift/v1/documents/member/variant")
    end
  end
  context "#read" do
    context "collection" do
    end
    context "member" do

      it "should have the correct default relationships included" do
        subject = model.find(context_store.created_resource.id)
        http_request_tracker.clear
        subject.product
        subject.asset_files
        subject.markdown_prices
        expect(http_request_tracker.length).to eql 0
      end

      context "product relationship" do
        it "should exist" do
          subject = model.find(created_resource.id)
          expect(subject.relationships.product).to be_present
        end
        it "should be loadable using compound documents" do
          subject = model.includes("product").find(created_resource.id).first
          expect(subject.product).to have_attributes created_product.attributes.slice(:id, :title, :reference, :content_type)
          expect(http_request_tracker.length).to eql 1
          expect(http_request_tracker.first[:response]).to match_response_schema("jsonapi/schema")
          expect(http_request_tracker.first[:response]).to match_response_schema("shift/v1/documents/member/variant")
        end
        it "should be loadable using links" do
          subject = model.includes("").find(created_resource.id).first
          expect(subject.product).to have_attributes created_product.attributes.slice(:id, :title, :reference, :content_type)
          expect(http_request_tracker.length).to eql 2
          expect(http_request_tracker.first[:response]).to match_response_schema("jsonapi/schema")
          expect(http_request_tracker.first[:response]).to match_response_schema("shift/v1/documents/member/variant")
        end
      end

      context "asset_files relationship" do
        before(:context) do
          # Create an asset file for use by the test
          asset_file_fixture_file = File.expand_path("../support_e2e/fixtures/asset_file.png", File.dirname(__FILE__))
          uuid = context_store.uuid
          context_store.foreign_resources.asset_folder = FlexCommerce::AssetFolder.create! name: "asset folder for Test Variant #{uuid}",
                                                                                           reference: "reference_for_asset_folder_1_for_variant_#{uuid}"
          context_store.foreign_resources.asset_file = FlexCommerce::AssetFile.create! name: "name for Asset file 1 for Test Variant #{uuid}",
                                                                                       reference: "reference_for_asset_file_1_for_variant_#{uuid}",
                                                                                       asset_file: "data:image/png;base64,#{Base64.encode64(File.read(asset_file_fixture_file))}",
                                                                                       asset_folder_id: context_store.foreign_resources.asset_folder.id
          context_store.foreign_resources.product.add_asset_files([context_store.foreign_resources.asset_file])
        end
        it "should exist" do
          subject = model.find(created_resource.id)
          expect(subject.relationships.asset_files).to be_present
        end
        it "should be loadable using compound documents" do
          subject = model.includes("asset_files").find(created_resource.id).first
          expect(subject.asset_files).to contain_exactly an_object_having_attributes context_store.foreign_resources.asset_file.attributes.slice(:id, :title, :reference, :content_type)
          expect(http_request_tracker.length).to eql 1
          expect(http_request_tracker.first[:response]).to match_response_schema("jsonapi/schema")
          expect(http_request_tracker.first[:response]).to match_response_schema("shift/v1/documents/member/variant")
        end
        it "should be loadable using links" do
          subject = model.includes("").find(created_resource.id).first
          expect(subject.asset_files).to contain_exactly an_object_having_attributes context_store.foreign_resources.asset_file.attributes.slice(:id, :title, :reference, :content_type)
          expect(http_request_tracker.length).to eql 2
          expect(http_request_tracker.first[:response]).to match_response_schema("jsonapi/schema")
          expect(http_request_tracker.first[:response]).to match_response_schema("shift/v1/documents/member/variant")
        end
      end

      context "markdown prices relationship" do
        before(:context) do
          # Create a markdown price for use by the test
          context_store.foreign_resources.markdown_price = ::FlexCommerce::MarkdownPrice.create price: 99.0,
                                                                                                start_at: 1.day.since,
                                                                                                end_at: 11.days.since,
                                                                                                variant_id: context_store.created_resource.id
        end
        it "should exist" do
          subject = model.find(created_resource.id)
          expect(subject.relationships.markdown_prices).to be_present
        end
        it "should be loadable using compound documents" do
          subject = model.includes("markdown_prices").find(created_resource.id).first
          expect(subject.markdown_prices).to contain_exactly an_object_having_attributes context_store.foreign_resources.markdown_price.attributes.slice(:id, :price, :start_at, :end_at)
          expect(http_request_tracker.length).to eql 1
          expect(http_request_tracker.first[:response]).to match_response_schema("jsonapi/schema")
          expect(http_request_tracker.first[:response]).to match_response_schema("shift/v1/documents/member/variant")
        end
        it "should be loadable using links" do
          subject = model.includes("").find(created_resource.id).first
          expect(subject.markdown_prices).to contain_exactly an_object_having_attributes context_store.foreign_resources.markdown_price.attributes.slice(:id, :price, :start_at, :end_at)
          expect(http_request_tracker.length).to eql 2
          expect(http_request_tracker.first[:response]).to match_response_schema("jsonapi/schema")
          expect(http_request_tracker.first[:response]).to match_response_schema("shift/v1/documents/member/variant")
        end

      end
    end
  end

  context "#update" do
    it "should persist changes to core attributes with valid values" do
      result = created_resource.update_attributes title: "Title for product 1 for variant #{context_store.uuid} changed",
                                                  reference: "reference for product 1 for variant #{context_store.uuid} changed",
                                                  content_type: "html"
      expect(result).to be true
      expect(created_resource.errors).to be_empty
    end
    it "should not persist changes and have errors when invalid attributes are used" do
      # Note that we create our own resource here as modifying the created one would leave it in an error state
      # causing confusion for when other tests begin.
      aggregate_failures do
        resource = model.create title: "Temp Variant #{uuid}",
                                description: "Temp Variant #{uuid}",
                                reference: "reference_for_temp_variant_#{uuid}",
                                price: 5.50,
                                price_includes_taxes: false,
                                sku: "sku_for_temp_variant_#{uuid}",
                                product_id: created_product.id
        result = resource.update_attributes sku: nil
        expect(result).to be false
        expect(resource.errors).to be_present
        resource.destroy
      end
    end
    it "should accept updates containing mirrored attributes" do
      # Read the created resource again to create a recorded request for us to grab the mirrored attributes from
      resource = model.includes("").find(created_resource.id).first
      result = created_resource.update_attributes resource.attributes.except("id", "type")
      expect(result).to be true
      expect(created_resource.errors).to be_empty

    end
    it "should not make any changes when updated with mirrored attributes" do
      found = model.find(context_store.created_resource.id) # Load it so we can grab the raw json
      data = Oj.load(http_request_tracker.first[:response].body)["data"].except("relationships", "links", "meta")
      url = "#{model.site}/#{found.links.self}"
      result = model.connection.run(:patch, found.links.self, data.to_json)
      expect(true).to eql false #TODO Test the status code and re fetch to ensure no changes
    end

    context "product relationship" do
      it "should persist additions to the relationship"
      it "should not persist an addition to the relationship if it already exists"
      it "should replace entire relationship"
      it "should remove from the existing relationship"
    end

    context "asset_files relationship" do
      it "should persist additions to the relationship"
      it "should not persist an addition to the relationship if it already exists"
      it "should replace entire relationship"
      it "should remove from the existing relationship"
    end

    context "markdown_prices relationship" do
      it "should be able to add a new markdown price" do
        result = created_resource.update_attributes(markdown_prices_resources: [FlexCommerce::MarkdownPrice.new(price: 1.10, start_at: 2.days.ago, end_at: 10.days.since)])
        expect(result).to be_truthy
        resource = model.includes("markdown_prices").find(created_resource.id).first
        expect(resource.markdown_prices).to include(an_object_having_attributes price: 1.10)
      end
      it "should persist additions to the relationship" do
        # This is not possible as the markdown price cannot exist without a variant id
        # but I am leaving it in here to keep the structure in place for now.
      end
      it "should not persist an addition to the relationship if it already exists" do
        context_store.foreign_resources[:markdown_price] = FlexCommerce::MarkdownPrice.create!(variant_id: created_resource.id, price: 1.10, start_at: 2.days.ago, end_at: 10.days.since)
        operation = -> { created_resource.add_markdown_prices([context_store.foreign_resources[:markdown_price]]) }
        expect(operation).to raise_error(FlexCommerceApi::Error::BadRequest)
      end
      it "should replace entire relationship"
      it "should remove from the existing relationship"
    end
  end

  context "#delete" do
    it "should delete"
  end

end