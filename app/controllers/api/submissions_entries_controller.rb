module Api
    class SubmissionsEntriesController < ApplicationController
    
        before_action :restrict_access
        after_action :cors_set_access_control_headers
        respond_to? :json
        
        def create
          @code = 500
          @notice = "An unknown error occurred."
            
          @web_form = WebForm.find(params[:id])
          @source = params[:source].to_s.gsub(/\s/,"")
          missing_required = @web_form.web_form_fields.required.select { |field| params[id_to_form_field_name(field.id)].to_s.empty? }
            
          if @source.empty? 
              @code = 404
              @notice = "Your form was missing a source."
          elsif missing_required.count > 0
              @code = 404
              @notice = "You were missing the following required fields: "+missing_required.map(&:name).join(", ")+"."
          else
            @submission = Submission.new(web_form_id: @web_form.id, source: @source)
            
            if @submission.save
                @submission.web_form.web_form_fields.each do |field|
                    if params[id_to_form_field_name(field.id)]
                        SubmissionsEntry.create(submission: @submission, web_form_field: field, value: params[id_to_form_field_name(field.id)].to_s)
                    end
                end
                
                @code = 200
                @notice = "Thanks for your message!"
            end
          end
            
          render json: { code: @code, notice: @notice }
        end
        
      private
        
      def id_to_form_field_name(web_form_field_id)
          ("web_form_field_"+web_form_field_id.to_s).to_sym
      end

      def restrict_access
          head :unauthorized unless params[:token] && params[:id] && User.where(token: params[:token]).count > 0 && WebForm.exists?(params[:id]) && User.where(token: params[:token]).first.id == WebForm.find(params[:id]).user_id
      end

      def cors_set_access_control_headers
          headers['Access-Control-Allow-Origin'] = '*'
          headers['Access-Control-Allow-Methods'] = 'GET'
          headers['Access-Control-Max-Age'] = "1728000"
      end
         
    end
end