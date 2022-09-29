class AssetWorkdaySumsController < ApplicationController
  before_action :set_asset_workday_sum, only: %i[ show edit update destroy ]

  # GET /asset_workday_sums or /asset_workday_sums.json
  def index
    @asset_workday_sums = AssetWorkdaySum.all
  end

  # GET /asset_workday_sums/1 or /asset_workday_sums/1.json
  def show
  end

  # GET /asset_workday_sums/new
  def new
    @asset_workday_sum = AssetWorkdaySum.new
  end

  # GET /asset_workday_sums/1/edit
  def edit
  end

  # POST /asset_workday_sums or /asset_workday_sums.json
  def create
    @asset_workday_sum = AssetWorkdaySum.new(asset_workday_sum_params)

    respond_to do |format|
      if @asset_workday_sum.save
        format.html { redirect_to asset_workday_sum_url(@asset_workday_sum), notice: "Asset workday sum was successfully created." }
        format.json { render :show, status: :created, location: @asset_workday_sum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @asset_workday_sum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /asset_workday_sums/1 or /asset_workday_sums/1.json
  def update
    respond_to do |format|
      if @asset_workday_sum.update(asset_workday_sum_params)
        format.html { redirect_to asset_workday_sum_url(@asset_workday_sum), notice: "Asset workday sum was successfully updated." }
        format.json { render :show, status: :ok, location: @asset_workday_sum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @asset_workday_sum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /asset_workday_sums/1 or /asset_workday_sums/1.json
  def destroy
    @asset_workday_sum.destroy

    respond_to do |format|
      format.html { redirect_to asset_workday_sums_url, notice: "Asset workday sum was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset_workday_sum
      @asset_workday_sum = AssetWorkdaySum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def asset_workday_sum_params
      params.require(:asset_workday_sum).permit(:account_id, :asset_id, :work_date, :work_minutes, :break_minutes, :ot1_minutes, :ot2_minutes, :sick_minutes, :free_minutes, :deleted_at)
    end
end
