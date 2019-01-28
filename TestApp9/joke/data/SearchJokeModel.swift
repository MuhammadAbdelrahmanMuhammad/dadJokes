
import Foundation

public final class SearchJokeModel: DataModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let status = "status"
    static let limit = "limit"
    static let results = "results"
    static let nextPage = "next_page"
    static let previousPage = "previous_page"
    static let totalPages = "total_pages"
    static let totalJokes = "total_jokes"
    static let searchTerm = "search_term"
    static let currentPage = "current_page"
  }

  // MARK: Properties
  public var status: Int?
  public var limit: Int?
  public var results: [JokeModel]?
  public var nextPage: Int?
  public var previousPage: Int?
  public var totalPages: Int?
  public var totalJokes: Int?
  public var searchTerm: String?
  public var currentPage: Int?

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
	public required init(_ dic: [String: Any]) {
    status = dic[SerializationKeys.status] as? Int
    limit = dic[SerializationKeys.limit] as? Int
		if let items = dic[SerializationKeys.results] as? Array<[String : Any]> {
			results = items.map { JokeModel($0) }
			
		}
    nextPage = dic[SerializationKeys.nextPage] as? Int
    previousPage = dic[SerializationKeys.previousPage] as? Int
    totalPages = dic[SerializationKeys.totalPages] as? Int
    totalJokes = dic[SerializationKeys.totalJokes] as? Int
    searchTerm = dic[SerializationKeys.searchTerm] as? String
    currentPage = dic[SerializationKeys.currentPage] as? Int
  }

}
