
import Foundation

public final class JokeModel: DataModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let id = "id"
    static let joke = "joke"
    static let status = "status"
  }

  // MARK: Properties
  public var id: String?
  public var joke: String?
  public var status: Int?
  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
	public required init(_ dic: [String: Any]) {
    id = dic[SerializationKeys.id] as? String
    joke = dic[SerializationKeys.joke] as? String
    status = dic[SerializationKeys.status] as? Int
  }

}

