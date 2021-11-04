class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # GET /users/me
  def me
    respond_to do |format|
      format.json { render json: current_user }
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      new_role = @user.role != user_params[:role] ? user_params[:role] : nil
      if @user.update(user_params)
        event = {
          event_name: "Users.Updated",
          data: {
            public_id: @user.public_id,
            email: @user.email,
            full_name: @user.full_name,
            role: @user.role
          }
        }
        Producer.call(event.to_json, topic: 'users-stream')
        if new_role
          event = {
            event_name: "Users.RoleChanged",
            data: {
              public_id: @user.public_id,
              role: new_role
            }
          }
          Producer.call(event.to_json, "users")
        end
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    user_public_id = @user.public_id

    if @user.destroy
      event = {
        event_name: "Users.Deleted",
        data: {
          public_id: user_public_id
        }
      }
      Producer.call(event.to_json, "users-stream")
    end

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :full_name, :role)
    end

    def current_user
      if doorkeeper_token
        User.find(doorkeeper_token.resource_owner_id)
      else
        super
      end
    end
end
