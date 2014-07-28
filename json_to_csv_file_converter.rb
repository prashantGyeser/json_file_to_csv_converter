require 'json'
require 'csv'

json_file_path = 'curl_output.json'
output_csv_path = 'output.csv'


invalid_json_count = 1

json_file = File.open(json_file_path).read


def convert_required_fields_from_json_to_hash(json_line)
  data = {}

  begin
    json_hash = JSON.parse(json_line)
    data[:screen_name] = json_hash["actor"]["displayName"]
    data[:user_image_url] = json_hash["actor"]["image"]
    data[:tweet_body] = json_hash["body"]
    data[:matching_rule] = json_hash["gnip"]["matching_rules"][0]["value"]

    return data
  rescue
    puts "Opps! Something went wrong!"
    puts "The tweet is:"
    puts '###########################################################################'
    puts json_line
    puts '###########################################################################'
  end

end

def json_valid?(json_line)
  begin
    !!JSON.parse(json_line, :quirks_mode => true)
  rescue
    #puts JSON.parse(json_line, :quirks_mode => true)
    false
  end
end


json_file.each_line do |line|
  if json_valid?(line)
    data_hash = convert_required_fields_from_json_to_hash(line)
    CSV.open(output_csv_path, 'a+') do |csv|
      csv << [data_hash[:screen_name], data_hash[:user_image_url], data_hash[:tweet_body], data_hash[:matching_rule]]
    end
  else
    puts "Error in json object: #{invalid_json_count}"
    invalid_json_count = invalid_json_count + 1
  end
end
