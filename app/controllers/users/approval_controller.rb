class Users::ApprovalController < Devise::RegistrationsController
  # before_action :set_user, only: [:approve_writer]
  # before_filter :authenticate_user!

  def approve_writer
    @user = User.find(params[:id])
    respond_to do |format|
      unless params[:wflag].nil?
        if @user.approve_writer(params[:wflag])
          format.html { redirect_to root_path, notice: 'Admins have been Notified.' }
        else
          format.html { redirect_to root_path, notice: 'Please Try Again.' }
        end
      end
    end
  end

end
