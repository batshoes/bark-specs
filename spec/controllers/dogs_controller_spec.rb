require 'rails_helper'

RSpec.describe DogsController, :type => :controller do

  let(:test_dog){ create(:dog) }


  describe "GET #new" do
    it "assigns a new dog to @dog" do
      get :new
      expect(assigns(:dog)).to be_an_instance_of Dog
    end
  end

  describe "GET #show" do

    it "assigns the requested dog to @dog" do
      get :show, id: test_dog.id
      expect(assigns(:dog)).to eq(test_dog)
    end
  end

  describe 'PUT #update' do

    before do
      put :update, {id: test_dog.id, dog: {name: 'Barky'}}
    end

    it "redirects to #edit" do
      expect(response).to redirect_to dog_path(test_dog)
    end

    it "updates the dog" do
      expect(assigns(:dog).name).to eq 'Barky'
    end
  end

  it "finding a nonexistant dog raises an error" do
    expect{Dog.find(500)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe 'DELETE #destroy' do
    it "destroys the dog record" do
      test_dog

      Dog.should_receive(:find).
        with(test_dog.id.to_s).
        and_return test_dog

      expect(test_dog).to receive(:destroy)

      delete :destroy, { id: test_dog.id }
    end
  end

  describe 'POST #create' do
    let(:valid_attributes){
      { dog: attributes_for(:dog) }
    }

    let(:invalid_attributes){
      { dog: attributes_for(:dog, email: nil) }
    }

    context 'when valid attributes are submitted' do
      before do
        post :create, valid_attributes
      end

      it "assigns the @dog variable" do
        expect(assigns(:dog)).to be_instance_of Dog
      end

      it "assigns the @dog variable" do
        expect(assigns(:dog)).to be_persisted
      end

      it "redirects to the dog show path" do
        expect(response).to redirect_to dog_path(assigns(:dog))
      end

    end

    context 'when invalid attributes are submitted' do
      before do
        post :create, invalid_attributes
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets errors on the model" do
        expect(assigns(:dog).errors).to be_present
      end

      it "does not get saved to the database" do
        expect(assigns(:dog)).to_not be_persisted
      end

    end

  end

end

