class SystemParametersController < SpeicherController

  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:system_parameter).permit(:account_id, :name, :system_key, :position, :value, :deleted_at)
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      SystemParameter.search SystemParameter.all, params[:q]
      # get <selectize> lookups
      # if request.format.symbol==:json
      #   Dashboard.search Dashboard.all, params[:q]
      # else
      #   Dashboard.search Dashboard.all, params[:q]
      # end
    end
end


# class SystemParametersController < ApplicationController
#   before_action :set_system_parameter, only: %i[ show edit update destroy ]

#   # GET /system_parameters or /system_parameters.json
#   def index
#     @system_parameters = SystemParameter.all
#   end

#   # GET /system_parameters/1 or /system_parameters/1.json
#   def show
#   end

#   # GET /system_parameters/new
#   def new
#     @system_parameter = SystemParameter.new
#   end

#   # GET /system_parameters/1/edit
#   def edit
#   end

#   # POST /system_parameters or /system_parameters.json
#   def create
#     @system_parameter = SystemParameter.new(system_parameter_params)

#     respond_to do |format|
#       if @system_parameter.save
#         format.html { redirect_to system_parameter_url(@system_parameter), notice: "System parameter was successfully created." }
#         format.json { render :show, status: :created, location: @system_parameter }
#       else
#         format.html { render :new, status: :unprocessable_entity }
#         format.json { render json: @system_parameter.errors, status: :unprocessable_entity }
#       end
#     end
#   end

#   # PATCH/PUT /system_parameters/1 or /system_parameters/1.json
#   def update
#     respond_to do |format|
#       if @system_parameter.update(system_parameter_params)
#         format.html { redirect_to system_parameter_url(@system_parameter), notice: "System parameter was successfully updated." }
#         format.json { render :show, status: :ok, location: @system_parameter }
#       else
#         format.html { render :edit, status: :unprocessable_entity }
#         format.json { render json: @system_parameter.errors, status: :unprocessable_entity }
#       end
#     end
#   end

#   # DELETE /system_parameters/1 or /system_parameters/1.json
#   def destroy
#     @system_parameter.destroy

#     respond_to do |format|
#       format.html { redirect_to system_parameters_url, notice: "System parameter was successfully destroyed." }
#       format.json { head :no_content }
#     end
#   end

#   private
#     # Use callbacks to share common setup or constraints between actions.
#     def set_system_parameter
#       @system_parameter = SystemParameter.find(params[:id])
#     end

#     # Only allow a list of trusted parameters through.
#     def system_parameter_params
#       params.require(:system_parameter).permit(:account_id, :name, :system_key, :position, :value, :deleted_at)
#     end
# end
