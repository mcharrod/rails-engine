require 'rails_helper'


describe "Merchant API" do

  # let blocks for actions to do when their name is called
  # let! will do the specified action immediately
  let(:parsed) { JSON.parse(response.body, symbolize_names: true)}
  let(:data) { parsed[:data] }
  let!(:merchants) { create_list(:merchant, 3) }


# shared examples is tests that can be re-used between different contexts
  shared_examples 'Adheres to JSON API spec' do
    it 'it adheres to JSON API spec' do
      expect(parsed).to have_key(:data)
      expect(data).to be_a(klass)
    end

    it "returns status 200" do
      expect(response).to be_successful
    end
  end

# contexts are describes basically
  context 'GET #index' do

    # creating the variable for use in the shared example
    let(:klass) {Array}
    before do
      get api_v1_merchants_path
    end

     # calling teh shared behavior
    it_behaves_like 'Adheres to JSON API spec'
    it 'returns proper data' do
      (0..2).all? do |num|
        data[num][:id] == merchants[num].id &&
          data[num][:attributes][:name] == merchants[num].name
      end
    end
  end

  context 'GET #show' do
    let(:klass) {Hash}
    let(:merchant) {merchants.first}
    before do
      get api_v1_merchant_path(merchant.id)
    end
    it_behaves_like 'Adheres to JSON API spec'

    it 'has a merchant name' do
      expect(data[:attributes][:name]).to eq(merchant.name)
    end

    # it 'returns a single resource' do
    #   expect(data).to be_an(Hash)
    #
    # end
  end
end
