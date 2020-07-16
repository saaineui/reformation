namespace :amicus do
  desc 'Update image for amicus submissions by email'
  task :image, [:url, :email] => :environment do |_, args|
    if SubmissionsEntry.where(value: args.email).empty?
      puts "Email #{args.email} not found"
      return
    end
    
    web_form_id = WebForm.where(name: "amicus").first.id
    
    submission_id = SubmissionsEntry.where(value: args.email).first.submission_id
    web_form_field_id = WebFormField.where(web_form_id: web_form_id, name: "Image").first.id
    submissions_entry = SubmissionsEntry.where(web_form_field_id: web_form_field_id, submission_id: submission_id).first
    
    submissions_entry.value = args.url
    
    if submissions_entry.save
      puts "#{args.url} saved as the image for #{args.email}"
    else
      puts "Image could not be saved."
    end
  end
end
