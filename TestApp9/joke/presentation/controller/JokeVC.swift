
import UIKit

class JokeVC: UIViewController {

	@IBOutlet weak var segment: UISegmentedControl!
	@IBOutlet weak var randomView: UIView!
	@IBOutlet weak var releventView: UIView!
	@IBOutlet weak var relevantTextView: UITextField!
	@IBOutlet weak var randomJokeLabel: UILabel!
	
	@IBOutlet weak var relevantTextResult: UITextView!
	@IBOutlet weak var nextBtn: UIButton!
	@IBOutlet weak var previousBtn: UIButton!
	
	private var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
	private var _presenter: JokePresenter!
	private var _term: String? = nil
	private var _currentPage = -1
	private var _nextPage = -1
	private var _prevoisPage = -1
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_presenter = JokePresenter(self)
		randomJokeLabel.text = ""
		self.relevantTextView.delegate = self
		// Do any additional setup after loading the view, typically from a nib.
		segment.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
		//segment.
		
	}

	@IBAction func getJokeAction(_ sender: Any) {
		_presenter.getRandomJoke()
	}
	
	@IBAction func searchAction(_ sender: Any) {
		_term = relevantTextView.text
		if let term = _term ,term.isEmpty {
			_term = nil
		}
		_presenter.searchToJoke(_term, page: "1")
	}
	@IBAction func previousAction(_ sender: Any) {
		_presenter.searchToJoke(_term, page: "\(_prevoisPage)")
	}
	@IBAction func nextAction(_ sender: Any) {
		_presenter.searchToJoke(_term, page: "\(_nextPage)")
	}
	@objc func indexChanged (_ sender: UISegmentedControl) {
		
		switch sender.selectedSegmentIndex {
		case 0:
			randomView.isHidden = false
			self.view.bringSubviewToFront(randomView)
		case 1:
			releventView.isHidden = false
			self.view.bringSubviewToFront(releventView)
		default:
			randomView.isHidden = false
			self.view.bringSubviewToFront(randomView)
		}
	}

}

extension JokeVC: JokePresenterDelegate {
	
	func checkInternetConnection() {
		
	}
	
	func showLoadingIndecator() {
		
		let view = self.view!
		activityIndicator.center = CGPoint(x: view.center.x, y: 250)
		activityIndicator.color = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
		view.addSubview(activityIndicator)
		view.bringSubviewToFront(activityIndicator)
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		UIApplication.shared.beginIgnoringInteractionEvents()
	}
	
	func hideLoadingIndecator() {
		activityIndicator.stopAnimating()
		activityIndicator.isHidden = true
		activityIndicator.removeFromSuperview()
		UIApplication.shared.endIgnoringInteractionEvents()
	}
	
	func onSuccessRandom(_ model: JokeModel) {
		DispatchQueue.main.async {
			self.randomJokeLabel.text = model.joke
			self.hideLoadingIndecator()
		}
	}
	
	func onfailureRandom(_ error: String) {
		DispatchQueue.main.async {
			self.randomJokeLabel.text = error
			self.hideLoadingIndecator()
		}
	}
	
	func onSuccessRelevant(_ model: SearchJokeModel) {
		_currentPage = model.currentPage ?? -1
		_nextPage = model.nextPage ?? -1
		_prevoisPage = model.previousPage ?? -1
		var resulet = ""
		for joke in model.results ?? [] {
			resulet += "- \(joke.joke ?? "") \n \n"
		}
		DispatchQueue.main.async {
			self.previousBtn.isHidden = self._prevoisPage == self._currentPage
			self.nextBtn.isHidden = self._nextPage == self._currentPage
			self.relevantTextResult.text = resulet
			self.hideLoadingIndecator()
		}
	}
	
	func onFailureRelevant(_ error: String) {
		DispatchQueue.main.async {
			self.previousBtn.isHidden = true
			self.nextBtn.isHidden = true
			self.relevantTextResult.text = error
			self.hideLoadingIndecator()
		}
	}
	
	
}

extension JokeVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
}
