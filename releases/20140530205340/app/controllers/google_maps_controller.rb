class GoogleMapsController < ApplicationController
  # GET /google_maps
  # GET /google_maps.json
  def index
    @google_maps = GoogleMap.all

    render json: @google_maps
  end

  # GET /google_maps/1
  # GET /google_maps/1.json
  def show
    @google_map = GoogleMap.find(params[:id])

    render json: @google_map
  end

  # POST /google_maps
  # POST /google_maps.json
  def create
    @google_map = GoogleMap.new(params[:google_map])

    if @google_map.save
      render json: @google_map, status: :created, location: @google_map
    else
      render json: @google_map.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /google_maps/1
  # PATCH/PUT /google_maps/1.json
  def update
    @google_map = GoogleMap.find(params[:id])

    if @google_map.update(params[:google_map])
      head :no_content
    else
      render json: @google_map.errors, status: :unprocessable_entity
    end
  end

  # DELETE /google_maps/1
  # DELETE /google_maps/1.json
  def destroy
    @google_map = GoogleMap.find(params[:id])
    @google_map.destroy

    head :no_content
  end
end
