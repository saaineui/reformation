module Api
    class SubmissionsEntriesController < ApplicationController
    
        before_action :restrict_access
        after_action :cors_set_access_control_headers
        respond_to? :json
        
        def create
          if params[:source]
            @submission = Submission.new(web_form_id: params[:id], source: params[:source].to_s)
            entries = []
            
            if @submission.save
                @submission.web_form.web_form_fields.each do |field|
                    if params[("web_form_field_"+field.id.to_s).to_sym]
                        SubmissionsEntry.create(submission: @submission, web_form_field_id: field.id, value: params[("web_form_field_"+field.id.to_s).to_sym])
                    end
                end
                @submission.reload
                @output = @submission.submissions_entries.count

            end
          end
            
          render json: @output
        end
        
      private

      def restrict_access
        head :unauthorized unless params[:token] && params[:id] && User.where(token: params[:token]).count > 0 && User.where(token: params[:token]).first.id == WebForm.find(params[:id]).user_id
      end

      def cors_set_access_control_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'GET'
        headers['Access-Control-Max-Age'] = "1728000"
      end
         
    end
end