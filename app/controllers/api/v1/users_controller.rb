class Api::V1::UsersController < ApplicationController

    skip_before_action :require_login, only: [:create] #, :show, :index]

    def create
        user = User.create(user_params)
        if user.valid?
            @token = encode_token(user_id: user.id)
            render json: { user: UserSerializer.new(user) }, status: :created
        else
            render json: { error: 'failed to create user' }, status: :not_acceptable
        end
    end

    def show
        user = User.find_by(id: params[:id])
        if user
            render json: user, serializer: UserSerializer, status: :ok
        else
            render json: { error: 'user not found' }, status: :not_acceptable
        end
    end

    def index
        users = User.all
        render json: users, each_serializer: UserSerializer, status: :ok
    end

    private

    def user_params
        params.require(:user).permit(
            :username,
            :email,
            password_authentication_attributes: [
                :password,
                :password_confirmation
            ]
        )
    end

end
