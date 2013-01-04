class UserMailer < ActionMailer::Base
	include ApplicationHelper

	def new_submission(user, collection)
		recipients create_to_list_with_editors(user.email)
		from MASTER_EDITOR_EMAIL
		subject "[#{PROGRAM_NAME}] New Submission Received"
		body :name => user.real_name, :project_info => project_info_with_notes(collection)
	end

	def resubmit(user, collection)
		recipients create_to_list_with_editors(user.email)
		from MASTER_EDITOR_EMAIL
		subject "[#{PROGRAM_NAME}] Project Resubmitted"
		body :name => user.real_name, :project_info => project_info(collection)
	end

	def denied(user, collection, comment)
		recipients MASTER_EDITOR_EMAIL
		from MASTER_EDITOR_EMAIL
		subject "[#{PROGRAM_NAME}] Submission Denied"
		body :contributor => user.real_name, :email => user.email, :project_info => project_info(collection), :comment => comment
	end

	def in_progress(user, collection)
		recipients user.email
		from MASTER_EDITOR_EMAIL
		subject "[#{PROGRAM_NAME}] Submission review in progress"
		body :name => user.real_name, :project_info => project_info(collection)
	end

	def in_peer_review(user, collection)
		recipients create_to_list_with_editors_and_board(user.email, collection.classification)
		from MASTER_EDITOR_EMAIL
		subject "[#{PROGRAM_NAME}] Submission now in peer review"
		body :name => user.real_name, :project_info => project_info(collection), :main_editor => main_editor_link_clear,
			:classification => Collection.to_classification_string(collection.classification)
	end

	def is_staged(user, collection)
		recipients create_to_list_with_editors(user.email)
		from MASTER_EDITOR_EMAIL
		subject "[#{PROGRAM_NAME}] Submission is staged"
		body :name => user.real_name, :main_editor => main_editor_link_clear, :project_info => project_info(collection)
	end

	def in_production(user, collection)
		recipients user.email
		from MASTER_EDITOR_EMAIL
		subject "[#{PROGRAM_NAME}] Submission is now in production"
		body :name => user.real_name, :project_info => project_info(collection), :classification => Collection.to_classification_string(collection.classification)
	end

	def editor_deletes(user, collection)
		recipients user.email
		from MASTER_EDITOR_EMAIL
		subject "[#{PROGRAM_NAME}] Submission deleted by editor"
		body :name => user.real_name, :main_editor => main_editor_link_clear, :project_info => project_info(collection)
	end

	def editor_changed_note(user, collection)
		recipients user.email
		from MASTER_EDITOR_EMAIL
		subject "[#{PROGRAM_NAME}] Editor changed note"
		body :name => user.real_name, :project_info => project_info_with_notes(collection)
	end

	def contributor_deletes(collection)
		recipients create_editor_list()
		from MASTER_EDITOR_EMAIL
		subject "[#{PROGRAM_NAME}] Submission deleted by contributor"
		body :project_info => project_info(collection)
	end

	def contributor_changed_note(collection)
		recipients create_editor_list()
		from MASTER_EDITOR_EMAIL
		subject "[#{PROGRAM_NAME}] Contributor changed note"
		body :project_info => project_info_with_notes(collection)
	end

	def user_account_changed(user, old_real_name, old_email, old_institution)
		if user.email == old_email
			recipients user.email
		else
			recipients [old_email, user.email]
		end
		from MASTER_EDITOR_EMAIL
		subject "[#{PROGRAM_NAME}] Account information on record has changed"
		body :name => user.real_name, :old_email => old_email, :new_email => user.email, :main_editor => main_editor_link_clear, :old_real_name => old_real_name,
			:new_real_name => user.real_name, :old_institution => old_institution, :new_institution => user.institution
	end

	def new_password(user, new_password)
		recipients user.email
		from MASTER_EDITOR_EMAIL
		subject "[#{PROGRAM_NAME}] Account Password Changed"
		body :name => user.real_name, :main_editor => main_editor_link_clear, :password => new_password
	end

	def account_deleted(user)
		recipients create_to_list_with_editors(user.email)
		from MASTER_EDITOR_EMAIL
		subject "[#{PROGRAM_NAME}] Account Disabled"
		body :name => user.real_name, :main_editor => main_editor_link_clear
	end

	def signup_notification(user, password)
		@user = user
		@password = password
		@url = ActionMailer::Base.default_url_options[:host]

		mail(to: @user.email, from: MASTER_EDITOR_EMAIL, subject: "[#{PROGRAM_NAME}] Account Created")
	end

	private
	def create_to_list_with_editors_and_board(user_email, classification_int)
		to_list = create_to_list_with_editors(user_email)
		board_list = EditorialBoardMember.find(:all, :conditions => [ "classification = ?", classification_int ])
		board_list.each { |member|
			to_list.insert(-1, member.email)
		}
		return to_list
	end

	def create_to_list_with_editors(user_email)
		to_list = create_editor_list
		to_list.insert(0, user_email) unless user_email == ""
		return to_list
	end

	def create_editor_list
		editor_list = User.find(:all, :conditions => [ "role = ?", User.to_role_int("Editor") ] )
		to_list = Array.new
		editor_list.each { |user|
			to_list.insert(-1, user.email)
		}
		return to_list
	end

	def project_info(collection)
		"Project name: #{collection.project_name}\n" +
			"Project URL: #{collection.project_url}\n" +
			"Default Thumbnail: #{collection.default_thumbnail}\n" +
			"Filename: #{collection.get_orig_filename()}\n" +
			"Uploaded Path: #{collection.get_new_filename()}"
	end

	def project_info_with_notes(collection)
		str = project_info(collection)
		str += "\n\nNotes:\n\n#{collection.notes}"
	end


	# def activation(user)
	#   setup_email(user)
	#   @subject    += 'Your account has been activated!'
	#   @body[:url]  = "http://YOURSITE/"
	# end

	protected
	def setup_email(user)
		@recipients  = "#{user.email}"
		@from        = "ADMINEMAIL"
		@subject     = "[YOURSITE] "
		@sent_on     = Time.now
		@body[:user] = user
	end
end
