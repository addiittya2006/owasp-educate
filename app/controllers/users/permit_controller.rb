class Users::PermitController < Devise::RegistrationsController
  # before_filter :configure_sign_up_params, only: [:create]
  # before_filter :configure_account_update_params, only: [:update]
  # before_filter :update_sanitized_params, if: :devise_controller?
  before_filter :authenticate_user!
  before_filter :is_admin?

  # def index
    # @users = User.all
  # end

  # GET /resource/sign_up
  # def new
    # super
  # end

  # POST /resource
  # def create
  #   super
  # end

  def permit
    @users = User.all
    # @user = User.find(params[:user])
    # if @user.update_attributes(params[:user])
    #   flash[:notice] = "Successfully updated User."
    #   redirect_to root_path
    # else
    #   render :action => 'permit'
    # end
  end

  def permit_edit
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_permit_path, notice: 'Permission was successfully updated.' }
      else
        format.html { redirect_to users_permit_path, notice: 'Permission was not successfully updated.' }
      end
    end
  end

  # GET /resource/edit
  # def edit
    #super
  # end

  # PUT /resource
  # def update
    # @user = User.find(params[:id])
    # respond_to do |format|
    #   if @user.update(user_params)
    #     format.html { redirect_to users_permit_path, notice: 'Permission was successfully updated.' }
    #   else
    #     format.html { redirect_to articles_path, notice: 'Permission was not successfully updated.' }
    #   end
    # end
    # super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end


  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :name
    # devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :email, :password, :password_confirmation)}
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  # devise_parameter_sanitizer.for(:account_update) << [:admin, :writer]
  # devise_parameter_sanitizer.for(:update) {|u| u.permit(:user, :commit, :name, :email, :admin, :writer)}
  # devise_parameter_sanitizer.for(:edit) {|u| u.permit(:user, :commit, :name, :email, :admin, :writer)}
  # devise_parameter_sanitizer.for(:permit) {|u| u.permit(:user, :commit, :name, :email, :admin, :writer)}
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end


  private
  def set_user
    @user = User.find(params[:user])
  end

  def user_params
    params.require(:user).permit(:admin, :writer)
  end

  def is_admin?
    redirect_to(root_path, :alert => 'You can\'t access this Page.') and return unless current_user && current_user.admin?
  end

end
