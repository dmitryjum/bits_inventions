require 'rails_helper'
require 'json_web_token'

describe Api::V1::InventionsController do
  before do
    invention1 = FactoryBot.create :invention, title: "robot1", bits: {"power" => 1, "pulse" => 2, "servo-motor" => 1}
    invention2 = FactoryBot.create :invention, title: "robot2", bits: {"power" => 3}
    invention3 = FactoryBot.create :invention, title: "robot3"
    @valid_auth_header = "Bearer #{JsonWebToken.encode({valid_user: 'true'})}"
    @invalid_auth_header = 'sdf'
    host! 'api.example.com'
  end

  it 'fails auth with any request, for example index' do
    # it would be nice to test every single route with it
    get api_v1_inventions_path, headers: { "Authorization": '@valid_auth_header' }
    expect(json_response['error']).to eq 'Unauthorized request'
  end

  context 'requests the list of all inventions with no params and gets it in json' do
    before :each do
      get api_v1_inventions_path, headers: { "Authorization": @valid_auth_header }
      @json_body = json_response
    end

    it 'receives success status' do
      expect(response).to be_success
    end

    it 'receives response with total of 3 school objects' do
      expect(@json_body.length).to eq 3
    end

    it 'receives response with list of schools that are in DB' do
      invnetion_titles = Invention.pluck(:title)
      returned_titles = @json_body.map {|s| s["title"]}
      expect(invnetion_titles).to eq returned_titles
    end
  end

  context 'it looks up inventions' do
    it 'found by id' do
      first_invention = Invention.first
      get api_v1_invention_path(id: first_invention.id), headers: { "Authorization": @valid_auth_header }
      expect(json_response['title']).to eq first_invention.title
    end

    it 'found by title' do
      invention = Invention.find_by_title('robot3')
      get find_by_title_api_v1_inventions_path(title: 'robot3'), headers: { "Authorization": @valid_auth_header }
      expect(response.status).to eq 200
      expect(json_response['user_name']).to eq invention.user_name
    end

    it 'found by bit names' do
      get where_bit_names_are_api_v1_inventions_path(bit_names: ['power']), headers: { "Authorization": @valid_auth_header }
      returned_titles = json_response.map {|s| s["title"]}
      expect(returned_titles).to eq ['robot1', 'robot2']
    end
  end

  context 'it deletes an invention' do
    it 'found by id' do
      first_invention = Invention.first
      delete api_v1_invention_path(id: first_invention.id), headers: { "Authorization": @valid_auth_header }
      expect(response.status).to be 204
      expect(Invention.where(id: first_invention.id).length).to be 0
    end

    it 'found by title' do
      delete destroy_by_title_api_v1_inventions_path(title: 'robot3'), headers: { "Authorization": @valid_auth_header }
      expect(response.status).to be 204
      expect(Invention.where(title: 'robot3').length).to be 0
    end
  end

  context 'it updates invention' do
    before :each do
      @first_invention = Invention.first
    end
    it 'found by id' do
      patch api_v1_invention_path(id: @first_invention.id, invention: {title: 'robot44'}), headers: { "Authorization": @valid_auth_header }
      expect(response.status).to be 201
      expect(json_response['title']).to eq(Invention.find(@first_invention.id).title)
    end

    it 'found by title' do
      patch update_by_title_api_v1_inventions_path(title: @first_invention.title, invention: {title: 'robot44'}), headers: { "Authorization": @valid_auth_header }
      expect(response.status).to be 201
      expect(json_response['title']).to eq(Invention.find(@first_invention.id).title)
    end

    it 'fails to update an invention' do
      #needs similar validation tests as create
      #once similar tests are implemented, needs refactoring of the test suit to avoid duplication
    end
  end

  describe 'it creates a new invention' do
    it 'successfuly creates a new invention' do
      new_invention = {
        title: 'invention_66',
        description: 'lights up like christmas tree',
        user_name: 'Bright Lantern',
        user_email: 'blan@gmail.com',
        bits: {'power' => 1, 'uv-led' => 1},
        materials: ['wires']
      }
      post api_v1_inventions_path(invention: new_invention), headers: { "Authorization": @valid_auth_header }
      expect(response.status).to be 201
      expect(json_response['title']).to eq(Invention.find_by_title('invention_66').title)
    end

    context 'fails to create a new invention' do
      it 'fails bits count validation' do
        new_invention = {
          title: 'invention_66',
          description: 'lights up like christmas tree',
          user_name: 'Bright Lantern',
          user_email: 'blan@gmail.com',
          bits: {'power' => 1, 'uv-led' => 0},
          materials: ['wires']
        }
        post api_v1_inventions_path(invention: new_invention), headers: { "Authorization": @valid_auth_header }
        expect(response.status).to be 422
        expect(json_response['validation'].first).to eq "bits value can't be 0 or not a number. Invention has to have at least 1 bit"
      end

      it 'fails bits value type validation' do
        new_invention = {
          title: 'invention_66',
          description: 'lights up like christmas tree',
          user_name: 'Bright Lantern',
          user_email: 'blan@gmail.com',
          bits: {'power' => 1, 'uv-led' => 'A'},
          materials: ['wires']
        }
        post api_v1_inventions_path(invention: new_invention), headers: { "Authorization": @valid_auth_header }
        expect(response.status).to be 422
        expect(json_response['validation'].first).to eq "bits value can't be 0 or not a number. Invention has to have at least 1 bit"
      end

      it 'fails bits attribute type validation' do
        new_invention = {
          title: 'invention_66',
          description: 'lights up like christmas tree',
          user_name: 'Bright Lantern',
          user_email: 'blan@gmail.com',
          bits: 'power',
          materials: ['wires']
        }
        post api_v1_inventions_path(invention: new_invention), headers: { "Authorization": @valid_auth_header }
        expect(response.status).to be 422
        expect(json_response['validation'].first).to eq "not in JSON format. Please enter key as a bit name and value as a bit count, e.g. {'led': '1'}"
      end

      it 'fails bits name(key) validation' do
        new_invention = {
          title: 'invention_66',
          description: 'lights up like christmas tree',
          user_name: 'Bright Lantern',
          user_email: 'blan@gmail.com',
          bits: {'bicycle' => 3},
          materials: ['wires']
        }
        post api_v1_inventions_path(invention: new_invention), headers: { "Authorization": @valid_auth_header }
        expect(response.status).to be 422
        expect(json_response['validation'].first).to eq "These bit names are not present in our stock: bicycle"
      end
    end
  end

end