import Foundation

struct CurrentWeather {
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    let feelsLikeTemperature: Double
    
    var feelsLikeTemperatureString: String {
        return String(format: "%.0f", feelsLikeTemperature)
    }
    
    let conditionCode: Int
    
    var systemIconNameString: String {
        switch conditionCode {
            case 200...232: return "cloud.bolt.rain.fill"
            case 300...321: return "cloud.drizzle.fill"
            case 500...531: return "cloud.rain.fill"
            case 600...622: return "cloud.snow.fill"
            case 700...781: return "smoke.fill"
            case 800: return "sun.min.fill"
            case 801...804: return "cloud.sun.fill"
            default: return "xmark.icloud.fill"
        }
    }
    
    var mainViewString: String {
        switch systemIconNameString {
            case "cloud.bolt.rain.fill": return "rain"
            case "cloud.drizzle.fill": return "rain"
            case "cloud.rain.fill": return "rain"
            case "cloud.snow.fill": return "snowy"
            case "smoke.fill": return "cloudly"
            case "sun.min.fill": return "sunny"
            case "cloud.sun.fill": return "cloudsun"
            default: return "xmark.icloud.fill"
        }
    }
    
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
    }
}
