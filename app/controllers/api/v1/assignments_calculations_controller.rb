module Api
  module V1
    class AssignmentsCalculationsController < AuthenticatedApiController
      include CorsSupport

      def create
        if fingerprint = calculator_params[:fingerprint]
          render json: AssignmentsCalculation.new(fingerprint,
                                                  calculator_params[:user_id],
                                                  current_app.identifier_types.first.id).call,
                 status: 201
        else
          render json: { "error": "fingerprint required" }, status: 422
        end
      end

      private

      def calculator_params
        params.permit(:fingerprint, :user_id)
      end
    end
  end
end
