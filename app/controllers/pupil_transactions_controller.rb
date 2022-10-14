class PupilTransactionsController < ApplicationController
  before_action :set_pupil_transaction, only: %i[ show edit update destroy ]

  # GET /pupil_transactions or /pupil_transactions.json
  def index
    @pupil_transactions = PupilTransaction.all
  end

  # GET /pupil_transactions/1 or /pupil_transactions/1.json
  def show
  end

  # GET /pupil_transactions/new
  def new
    @pupil_transaction = PupilTransaction.new
  end

  # GET /pupil_transactions/1/edit
  def edit
  end

  # POST /pupil_transactions or /pupil_transactions.json
  def create
    @pupil_transaction = PupilTransaction.new(pupil_transaction_params)

    respond_to do |format|
      if @pupil_transaction.save
        format.html { redirect_to pupil_transaction_url(@pupil_transaction), notice: "Pupil transaction was successfully created." }
        format.json { render :show, status: :created, location: @pupil_transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pupil_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pupil_transactions/1 or /pupil_transactions/1.json
  def update
    respond_to do |format|
      if @pupil_transaction.update(pupil_transaction_params)
        format.html { redirect_to pupil_transaction_url(@pupil_transaction), notice: "Pupil transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @pupil_transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pupil_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pupil_transactions/1 or /pupil_transactions/1.json
  def destroy
    @pupil_transaction.destroy

    respond_to do |format|
      format.html { redirect_to pupil_transactions_url, notice: "Pupil transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pupil_transaction
      @pupil_transaction = PupilTransaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pupil_transaction_params
      params.require(:pupil_transaction).permit(:asset_id, :pupil_id, :work_minutes)
    end
end
