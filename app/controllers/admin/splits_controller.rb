class Admin::SplitsController < AuthenticatedAdminController
  def new
    @split = Split.new(owner_app_id: App.first.id)
  end

  def create
    operation = ::CreateSplit.new(split_params).call
    if operation[:success]
      redirect_to admin_split_path(operation[:split]), notice: "Split successfully created."
    else
      @split = operation[:split]
      render :new
    end
  end

  def index
    @splits = Split.active.order(:name)
  end

  def show
    @split = Split.find(params[:id])
  end

  def split_params
    params[:split].permit!
  end
end
