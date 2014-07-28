require 'json'
require 'csv'

json_file_path = '../gnip_sample_output/local_test.json'
output_csv_path = 'output.csv'


invalid_json_count = 1

#json_file = File.open(json_file_path).read


def convert_required_fields_from_json_to_hash(json_line)
  data = {}

  begin
    json_hash = JSON.parse(json_line)
    data[:screen_name] = json_hash["actor"]["displayName"]
    data[:user_image_url] = json_hash["actor"]["image"]
    data[:tweet_body] = json_hash["body"]
    data[:matching_rule] = json_hash["gnip"]["matching_rules"][0]["value"]
    if json_hash["actor"]["location"].nil?
      data[:twitter_location] = ' '
    else
      data[:twitter_location] = json_hash["actor"]["location"]["displayName"]
    end
    if json_hash["gnip"]["profileLocations"].nil?
      data[:gnip_location] = ' '
    else
      data[:gnip_location] = json_hash["gnip"]["profileLocations"][0]["address"]["locality"]
    end

    return data
  rescue Exception => e
    puts "Opps! Something went wrong!"
    #puts '###########################################################################'
    #puts data
    #puts '###########################################################################'
    puts '==============================================================='
    puts e
    puts '==============================================================='
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

json_file = File.open(json_file_path)

while(line = json_file.gets)
  if json_valid?(line)
    data_hash = convert_required_fields_from_json_to_hash(line)
    CSV.open(output_csv_path, 'a+') do |csv|

      if data_hash.nil?
      else
        csv << [data_hash[:screen_name], data_hash[:user_image_url], data_hash[:tweet_body], data_hash[:matching_rule], data_hash[:twitter_location], data_hash[:gnip_location], data_hash[:gnip_location]]
      end

    end
  else
    puts "Error in json object: #{invalid_json_count}"
    invalid_json_count = invalid_json_count + 1
  end
end


#json_file.each_line do |line|
#File.readlines(json_file_path).each do |line|

#end
