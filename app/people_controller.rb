require 'date'

 # "Los Angeles" is not present in Sample data and according to instruction I have no right to update or add sample data and app_spec.rb
 # so I have to use hard coded name of cites.
CITIES = {"LA" => "Los Angeles", "NYC" => "New York City"}

class PeopleController
  def initialize(params)
    @params = params
  end

  def normalize
    doller_array = []
    percent_array = []
    desired_format = ["first_name", "city", "birthdate"]

    doller_format = params[:dollar_format].split("\n").map{|x| x.split(" $ ")}
    percent_format = params[:percent_format].split("\n").map{|x| x.split(" % ")}

    doller_format.drop(1).each do |x|
      doller_array << {
                        doller_format[0][0] => x[0],
                        doller_format[0][1] => x[1],
                        doller_format[0][2] => x[2],
                        doller_format[0][3] => x[3]
                      }
    end
    percent_format.drop(1).each do |x|
      percent_array << {
                          percent_format[0][0] => x[0],
                          percent_format[0][1] => x[1],
                          percent_format[0][2] => x[2]
                        }
    end

    data = doller_array + percent_array
    final_result = data.map do |x|
      [
        x[desired_format[0]],
        (CITIES[x[desired_format[1]]] || x[desired_format[1]]),
        Date.parse(x[desired_format[2]]).strftime("%-m/%-d/%Y")
      ]
    end

    return final_result.sort_by{|x| x[desired_format.find_index(params[:order].to_s)]}.map{|x| x.join(", ")}
  end

  private

  attr_reader :params
end