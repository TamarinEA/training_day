module SearchInFile
 @queue = :search

  def self.perform(file)
    puts "Start"
    new_path = DataFile.search(file["name"], file["word"])
    FileMailer.result_file_email(new_path, file["email"]).deliver
    puts "Job is done!!"
  end 
end
