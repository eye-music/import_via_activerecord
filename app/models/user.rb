class User < ApplicationRecord
	validates :first_name,:last_name, presence: true
	validates :email, presence: true, uniqueness: true
	validates_format_of :email, :with => /.+@.+\..+/i

	class << self
		def import_file(file) #using active record import because its fast.It will initialize all objects for each row and will put them in single array and after that will save it. 
			spreadsheet = Roo::Spreadsheet.open(file.path)
	    	header = spreadsheet.row(1)
	    	users = []
	    	failed = []
	    	emails = []
	    	(2..spreadsheet.last_row).each do |i|
	        	row = Hash[[header, spreadsheet.row(i)].transpose]
	        	if row["first_name"].blank? || row["last_name"].blank? || row["email"].blank?
	        		failed << row
	        		next
	        	end
	        	if emails.include?(row["email"])
	        		failed << row
	        		next
	        	end
	        	user = User.find_by(email: row["email"])
	        	if user.present?
	        		failed << row
	        		next
	        	end
	        	users << User.new(row.to_hash)
	    		emails << row["email"]
	    	end
	    	User.import users
	  		return users.size,  failed.size
	  	end  
  	end
end
