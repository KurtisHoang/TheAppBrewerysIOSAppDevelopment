//
//  WeatherManager.swift
//  WeatherApi
//
//  Created by Kurtis Hoang on 4/4/21.
//
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=YOUR_API_KEY&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    //complete weather URL for request
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    /*
     1.Create a URL
     2.Create URLSession
     3.Give the session a task
     4.Start the task
     */
    
    //Request
    func performRequest(with urlString: String)
    {
        //1
        if let url = URL(string: urlString) {
            //2
            let session = URLSession(configuration: .default)
            //3
            
            //old code
            //let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            
            //closure version
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
        
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        delegate?.didUpdateWeather(self ,weather: weather)
                    }
                }
            }
            //4
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?
    {
        let decoder = JSONDecoder() //decode json
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let cityName = decodedData.name
            let temperature = decodedData.main.temp
            let weatherId = decodedData.weather[0].id
            
            return WeatherModel(conditionId: weatherId, cityName: cityName, temperature: temperature)
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    //old code
//    func handle(data: Data?, response: URLResponse?, error: Error?) {
//        if error != nil {
//            print(error!)
//            return
//        }
//
//        if let safeData = data {
//            let dataString = String(data: safeData, encoding: .utf8) //.utf8 standardize protocol for encoding data types
//            print(dataString)
//        }
//    }
}
