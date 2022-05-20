require 'rails_helper'


describe "Item API" do
  let(:parsed) { JSON.parse(response.body, symbolize_names: true)}
  let(:data) { parsed[:data] }
  let!(:items) { create_list(:item, 3) }

  shared_examples 'Adheres to JSON API spec' do
    it 'it adheres to JSON API spec' do
      expect(parsed).to have_key(:data)
      expect(data).to be_a(klass)
    end

    it "returns status 200" do
      expect(response).to be_successful
    end
  end

  context 'GET #index' do
    let(:klass) {Array}

    before do
      get api_v1_items_path
    end

    it_behaves_like 'Adheres to JSON API spec'

    it 'returns proper data' do
      # grab the first 3 resources
      (0..2).all? do |index|
        # maybe this could be refactored with an each_with_index.

        # confirm each one of the attributes from response
        data[index][:id] == items[index].id
        data[index][:type] == "item"
        data[index][:attributes][:unit_price] == items[index].unit_price
        data[index][:attributes][:name] == items[index].description
        data[index][:attributes][:merchant_id] == items[index].merchant_id
      end
    end
  end

  context 'GET#show' do
    # expected data type for 1 resource is hash vs an array
    let(:klass) {Hash}

    # we'll use the first item we created for this test
    let(:item) {items.first}

    # JSON documentation compliant
    it_behaves_like 'Adheres to JSON API spec'

    before do
      get api_v1_item_path(item.id)
    end

    it 'returns proper data' do
      expect(data[:id]).to eq(item.id.to_s)
      expect(data[:type]).to eq("item")
      expect(data[:attributes][:unit_price]).to eq(item.unit_price)
      expect(data[:attributes][:name]).to eq(item.name)
      expect(data[:attributes][:description]).to eq(item.description)
      expect(data[:attributes][:merchant_id]).to eq(item.merchant_id)
    end
  end

  context 'POST #create' do
    let(:klass) {Hash}
    let(:merchant) {create(:merchant)}

    context 'happy path' do
      # valid data here
      let(:item_params) do
        {
          item: {
            name: "hairbrush",
            description: "evil",
            unit_price: 100.99,
            merchant_id: merchant.id }
        }
      end

      it 'creates an item' do
        expect {
          post api_v1_items_path(item_params)
        }.to change { Item.where(**item_params[:item]).count }.by 1
      end
    end

    context "given invalid data" do
      # invalid data here
      let(:invalid_item_params) do
        {
          item: {
            description: 5,
            unit_price: "no",
            merchant_id: merchant.id }
        }
      end

      it 'does not create an item' do
        expect {
          post api_v1_items_path(invalid_item_params)
        }.not_to change { Item.count }
      end

      it 'returns validation error messages' do
        post api_v1_items_path(invalid_item_params)
        expect(parsed).to include(message: "Validation failed")
        expect(parsed).to include(errors: hash_including(
          unit_price: ["is not a number"],
          name: ["can't be blank"]
        ))
      end

      it 'returns 422 status' do
        expect(post api_v1_items_path(invalid_item_params)).to eq(422)
      end
    end
  end

  context 'DELETE #destroy' do
    let!(:item) {create(:item)}

    it 'deletes the item' do
      expect {
        delete api_v1_item_path(item.id)
      }.to change { Item.count }.by -1
    end
  end
end
