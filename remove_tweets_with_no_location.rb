require 'csv'

path_to_csv_to_cleanup = "output.csv"
path_to_clean_output = "no_location_tweets_removed.csv"

CSV.foreach(path_to_csv_to_cleanup) do |row|
  location = row[4]
  if location == ' '
  else
    CSV.open(path_to_csv_to_cleanup, 'a+') do |csv|
      csv << row
    end
  end
end