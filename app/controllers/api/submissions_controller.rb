module Api
  class SubmissionsController < ApplicationController
    protect_from_forgery except: :create
    skip_before_action :require_login
    skip_before_action :require_admin
    before_action :restrict_access
    after_action :cors_set_access_control_headers
    respond_to? :json
    
    def initialize
      @output = { status: 400, json: { notice: 'An unknown error occurred.' } }
    end

    def create
      if source.empty?
        @output[:json][:notice] = 'Your form was missing a source.'
      elsif missing_required.count.positive?
        @output[:json][:notice] = missing_required_message
      else
        @submission = Submission.new(web_form: @web_form, source: source)

        add_entries_and_update_output if @submission.save
      end
      
      render @output
    end

    private
    
    def source
      params[:source].to_s.strip
    end
    
    def missing_required
      @web_form.web_form_fields.required.select { |field| missing?(field.id) }
    end

    def missing?(web_form_field_id)
      params[key_name(web_form_field_id)].to_s.strip.empty?
    end
    
    def key_name(web_form_field_id)
      ('web_form_field_' + web_form_field_id.to_s).to_sym
    end
    
    def missing_required_message
      prefix = 'You were missing the following required fields: '
      prefix + missing_required.map(&:name).join(', ') + '.'
    end
    
    def add_entries_and_update_output
      create_submissions_entries
      @output = { status: 201, json: { notice: 'Thanks for your message!' } }
    end
    
    def create_submissions_entries
      @web_form.web_form_fields.each do |field|
        next unless params[key_name(field.id)]
        
        SubmissionsEntry.create(
          submission: @submission, 
          web_form_field: field, 
          value: params[key_name(field.id)].to_s.strip
        )
      end
    end

    # Filters and filter helpers
    def restrict_access
      head :unauthorized unless find_form && token_matches?
    end
    
    def find_form
      return false unless WebForm.exists?(params[:web_form_id])
      @web_form = WebForm.find(params[:web_form_id])
      true
    end
    
    def token_matches?
      return false if params[:token].nil? 
      user = User.find_by(token: params[:token]) 
      user && user.eql?(@web_form.user)
    end

    def cors_set_access_control_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST'
      headers['Access-Control-Max-Age'] = '1728000'
    end
  end
end
