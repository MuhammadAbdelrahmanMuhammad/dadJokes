
import Foundation
class JokePresenter {
	
	var _view: JokeVC
	
	init(_ view: JokeVC) {
		_view = view
		
	}
	
	func getRandomJoke() {
		
		_view.showLoadingIndecator()
		
		let manager =
			NetworkManager<JokeModel>(url: "https://icanhazdadjoke.com/", paramter: [:])
		
		manager.makeGetCall(onSuccess: _view.onSuccessRandom,
							   onFailure: _view.onfailureRandom)
		
	}
	
	func searchToJoke(_ term: String?, page: String) {
		
		_view.showLoadingIndecator()
		
		var param = ["page": page, "limit": "10"]
		if let term = term {
			param["term"] = term
		}
		let manager =
			NetworkManager<SearchJokeModel>(url: "https://icanhazdadjoke.com/search", paramter: param)
		
		manager.makeGetCall(onSuccess: _view.onSuccessRelevant,
							onFailure: _view.onFailureRelevant)
		
	}
	
	
}
