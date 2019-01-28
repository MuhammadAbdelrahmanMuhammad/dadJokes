
import Foundation

protocol JokePresenterDelegate {
	
	func showLoadingIndecator()
	func hideLoadingIndecator()
	func onSuccessRandom(_ model : JokeModel)
	func onfailureRandom(_ error : String)
	func onSuccessRelevant(_ model : SearchJokeModel)
	func onFailureRelevant(_ error : String)
	func checkInternetConnection ()
}
