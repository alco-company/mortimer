class PunchClocksController < ApplicationController
  before_action :set_punch_clock, only: %i[ show edit update destroy ]

  # GET /punch_clocks or /punch_clocks.json
  def index
    @punch_clocks = PunchClock.all
  end

  # GET /punch_clocks/1 or /punch_clocks/1.json
  def show
  end

  # GET /punch_clocks/new
  def new
    @punch_clock = PunchClock.new
  end

  # GET /punch_clocks/1/edit
  def edit
  end

  # POST /punch_clocks or /punch_clocks.json
  def create
    @punch_clock = PunchClock.new(punch_clock_params)

    respond_to do |format|
      if @punch_clock.save
        format.html { redirect_to punch_clock_url(@punch_clock), notice: "Punch clock was successfully created." }
        format.json { render :show, status: :created, location: @punch_clock }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @punch_clock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /punch_clocks/1 or /punch_clocks/1.json
  def update
    respond_to do |format|
      if @punch_clock.update(punch_clock_params)
        format.html { redirect_to punch_clock_url(@punch_clock), notice: "Punch clock was successfully updated." }
        format.json { render :show, status: :ok, location: @punch_clock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @punch_clock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /punch_clocks/1 or /punch_clocks/1.json
  def destroy
    @punch_clock.destroy

    respond_to do |format|
      format.html { redirect_to punch_clocks_url, notice: "Punch clock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_punch_clock
      @punch_clock = PunchClock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def punch_clock_params
      params.require(:punch_clock).permit(:location, :ip_addr, :last_punch_at, :deleted_at)
    end
end
