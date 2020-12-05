using Soup;
using Json;

struct  weatherInfo{
    string short_discription;
    double temperature;
}

string get_ip(Soup.Session session) {
    string uri = "https://api.ipify.org";
    var message = new Soup.Message("GET", uri);
    session.send_message(message);

    return (string)message.response_body.data;
}

 async void get_weather(string location, string secret_key, Weather.Widgets.DisplayWidget display_widget) {

    //Init the session.
    var session = new Soup.Session ();
    var info = weatherInfo();

    string loc_uri = "http://api.ipstack.com/" + get_ip(session) + "?access_key=34cfe6a6834b9c4d58cf47dabca7495c";

    string uri = "https://api.openweathermap.org/data/2.5/weather?";
    //  string uri = "https://api.openweathermap.org/data/2.5/onecall?";

    // Get Location.
    double lat=0, lon=0;
    var query_location = new Soup.Message ("GET", loc_uri);
    session.send_message (query_location);

    try {
        var parser = new Json.Parser();

        parser.load_from_data((string) query_location.response_body.flatten().data, -1);

        var root_object = parser.get_root().get_object();
        lat = root_object.get_double_member("latitude");
        lon = root_object.get_double_member("longitude");
        var city = root_object.get_string_member("city");

        stderr.printf("Location : lat : %g, lon : %g \n", lat, lon);
        stderr.printf("Location : City: %s \n", city);
        stderr.printf("API Key: %s\n",secret_key);
        stderr.printf("IP: %s\n", get_ip(session));

    }catch (Error e){
        stderr.printf(" Unable to get location\n");
       // return;// info ;
    }


    //  var weather_uri = uri + "lat=" + lat.to_string() + "&lon=" + lon.to_string() + "&appid=" + secret_key;
    var weather_uri = uri + "lat=" + lat.to_string() + "&lon=" + lon.to_string() + "&units=metric" + "&appid=" + secret_key;
    var message = new Soup.Message ("GET", weather_uri);
    session.send_message (message);

    try {
        var parser = new Json.Parser ();

        parser.load_from_data ((string) message.response_body.flatten().data, -1);

        var root_object = parser.get_root ().get_object ();
        //  var currently = root_object.get_object_member ("currently");
        //  var summary = currently.get_string_member ("summary");
        //  var temp = currently.get_double_member("temperature");

        var currently = root_object.get_array_member("weather");
        var currently1 = currently.get_object_element(0);
        var summary = currently1.get_string_member ("main");
        var temp_module = root_object.get_object_member("main");
        var temp = temp_module.get_double_member("temp");

        stderr.printf("current : %s\n", summary);
        stderr.printf("temp: %s\n", temp.to_string());

        info.short_discription = summary;
        info.temperature = temp;


    } catch (Error e) {
        stderr.printf ("I guess something is not working... %s \n", e.message);
    }
    display_widget.update_state(info.short_discription,info.temperature);

    return;
}
