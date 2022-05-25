class DashboardsController < ApplicationController
  before_action :set_dashboard, only: %i[ show edit update destroy landing ]

  #
  # when someone accesses the application with no endpoint
  # they should go here
  #
  def landing
    if @dashboard
      render inline: @dashboard.body, layout: @dashboard.layout, locals: {dashboard: @dashboard }
    end
  end

  # GET /dashboards or /dashboards.json
  def index
    @dashboards = Dashboard.all
  end

  # GET /dashboards/1 or /dashboards/1.json
  def show
  end

  # GET /dashboards/new
  def new
    @dashboard = Dashboard.new
  end

  # GET /dashboards/1/edit
  def edit
  end

  # POST /dashboards or /dashboards.json
  def create
    @dashboard = Dashboard.new(dashboard_params)

    respond_to do |format|
      if @dashboard.save
        format.html { redirect_to dashboard_url(@dashboard), notice: "Dashboard was successfully created." }
        format.json { render :show, status: :created, location: @dashboard }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dashboards/1 or /dashboards/1.json
  def update
    respond_to do |format|
      if @dashboard.update(dashboard_params)
        format.html { redirect_to dashboard_url(@dashboard), notice: "Dashboard was successfully updated." }
        format.json { render :show, status: :ok, location: @dashboard }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dashboards/1 or /dashboards/1.json
  def destroy
    @dashboard.destroy

    respond_to do |format|
      format.html { redirect_to dashboards_url, notice: "Dashboard was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dashboard
      @dashboard = Dashboard.find(params[:id]) rescue nil
      #
      # TODO use find_landing once the User Model has been introduces
      #
      @dashboard ||= Dashboard.new(
        layout: "application", 
        name: "dashboard not found!", 
        body: %(
          <div style='margin: 2rem'>
            <h1>Requested Dashboard Was Not Found!</h1>
            <p>Fix this <a style='color: #345678' href='/dashboards'>here</a> if you like</p>
            <p>This is the "<%= dashboard.name %>" dashboard generated by the system in the event that no dashboard was found</p>
          </div>
        )
      )
    end

    # Only allow a list of trusted parameters through.
    def dashboard_params
      params.require(:dashboard).permit(:name, :layout, :body)
    end


    # Find the proper landing for this request - when possible
    def find_landing
      unless user_signed_in?
        @dashboard = Dashboard.find params[:lid] rescue nil
        @dashboard ||= Dashboard.new layout: "application", name: "default landing", body: "<div style='margin: 2rem'><h1>Standard instrumentpanel</h1><p>Ret det <a style='color: #345678' href='/dashboards'>her</a></p></div>"
      else
        if current_account != current_user.account
          @dashboard = current_account.dashboard rescue Dashboard.new( name: "N/A", layout: "application")
        else
          @dashboard = (current_user.profile.dashboard rescue false) || (current_user.account.dashboard rescue false) || Dashboard.new( name: "N/A", layout: "application")
        end
      end
    end

end
