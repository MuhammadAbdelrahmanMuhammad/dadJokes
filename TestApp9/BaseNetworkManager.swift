import Foundation
import Network

class NetworkManager <T: DataModel> {
	
	private var _url: String
	private let _param: [String: String]
	private let _headers: [String: String] = ["Accept":"application/json"]
	
	init (url: String, paramter: [String: String]) {
		_url = url
		_param = paramter
	}
	
	func makeGetCall(onSuccess: @escaping (_ model : T)->Void, onFailure: @escaping (_ error : String)->Void) {
		
		if !ReachabilityTest.isConnectedToNetwork() {
			onFailure("Internet connection not available")
			return
		}
		
		// Set up the URL request
		editURLWithParam(url: &_url, parameters: _param)
		
		guard let url = URL(string: _url) else {
			onFailure("Error: cannot create URL")
			return
		}
		var urlRequest = URLRequest(url: url)
		for header in _headers {
			urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
		}
		
		// set up the session
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config)
		
		// make the request
		let task = session.dataTask(with: urlRequest) {
			(data, response, error) in
			// check for any errors
			guard error == nil else {
				onFailure("error calling \(self._url) \(error!)")
				return
			}
			// make sure we got data
			guard let responseData = data else {
				onFailure("Error: did not receive data")
				return
			}
			// parse the result as JSON, since that's what the API provides
			do {
				guard let dic = try JSONSerialization.jsonObject(with: responseData, options: [])
					as? [String: Any] else {
						onFailure("error trying to convert data to JSON")
						return
				}
				
				let dataModel = T.init(dic)
				onSuccess(dataModel)
				
			} catch  {
				onFailure("error trying to convert data to JSON")
				return
			}
		}
		task.resume()
	}
	
	private func editURLWithParam( url :inout String, parameters: [String: String]) {
		if parameters.count > 0 {
			url += "?"
			for param in parameters {
				url += param.key
				url += "="
				url += param.value
				url += "&"
			}
			url.removeLast()
		}
	}

}
