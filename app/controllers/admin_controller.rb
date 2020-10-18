class AdminController < ApplicationController

	def index
		@invoices = Invoice.where(is_invoice_valid: [nil, false])
	end

	def members
		data = {}
		users_where = "(lower(users.name) LIKE :search) OR (lower(users.position) LIKE :search) OR (lower(users.phone_number) LIKE :search)"
	    users_where_values = {}
	    search = params[:search].to_s.downcase if params[:search].present?
	    users_where_values.merge!(search: "%#{search}%")  
	    if params[:start_date].present? && params[:end_time].present?
		    @users = User.where([users_where, users_where_values]).where('created_at BETWEEN ? AND ?', params[:start_date], params[:end_time])
		else
			@users = User.where([users_where, users_where_values])
		end

	    session[:search] = {}
	end

	def pair_details
		data = {}
		users_where = " (lower(users.sponser_id) LIKE :search) OR(lower(users.name) LIKE :search) OR (lower(users.position) LIKE :search) OR (lower(users.phone_number) LIKE :search)"
	    users_where_values = {}
	    search = params[:search].to_s.downcase if params[:search].present?
	    users_where_values.merge!(search: "%#{search}%")  
	    if params[:start_date].present? && params[:end_time].present?
		    @users = User.where(role_id: nil).where([users_where, users_where_values]).where('created_at BETWEEN ? AND ?', params[:start_date], params[:end_time])
		else
			@users = User.where(role_id: nil).where([users_where, users_where_values])
		end


		if params[:range].present?
			@pairs = Pair.where(user_id: @users.pluck(:id)).where.not(left_user_id: nil, right_user_id: nil).pluck(:user_id)
			@users = User.where(id: @pairs.uniq)
			@users.limit(params[:range])
		end

		session[:search] = {}
		session[:range] = {}
	end


	def manage_members
		@users = User.all
		@users = User.where(is_invoice_valid: params[:is_invoice_valid]) if params[:is_invoice_valid].present?
		@user = User.new
	end

	def user_detail_update
	end

	def contact_us
		@contacts = Contact.all
	end

	def invoices

	end

	def invoice_operation
		invoice = Invoice.find(params[:id])
		if invoice.present? 
			invoice.is_invoice_valid = params[:status].eql?("accept") ? true : false
			if invoice.save
				user = invoice.try(:user)
				user.is_invoice_valid = params[:status].eql?("accept") ? true : false
				user.save(validate: false)
				redirect_to admin_index_path
			end
		end
	end
end