class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  
  def self.import(file)
      CSV.foreach(file.path, headers: true) do |row|
          Product.create! row.to_hash
          end
      end
end