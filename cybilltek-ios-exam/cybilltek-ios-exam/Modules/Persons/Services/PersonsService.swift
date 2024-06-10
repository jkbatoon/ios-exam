//
//  PersonsService.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import Foundation
import RxSwift
import Alamofire

enum PersonsServiceState {
    case idle
    case success(_ data: [PersonDetails]?)
    case error(_ error: APIError)
}

struct PersonsService {
    typealias ObservablePersonsData = Observable<PersonsServiceState>
    
    func getPersonsData(page: Int?) -> ObservablePersonsData? {
        return ObservablePersonsData.create { observer -> Disposable in
            
            observer.onNext(.idle)

            let rootUrl = "https://randomuser.me/api/"
            let params = [
                "page": page ?? 1,
                "results": 10 // count of results per request
            ]
            
            guard let convertedRootUrl = URL(string: rootUrl) else {
                observer.onNext(.error(APIError.apiFailure(message: ErrorType.unreachable.message)))
                return Disposables.create()
            }
            
            let targetUrl = convertedRootUrl.appendingQueryItems(params)

            AF.request(targetUrl,
                       method: .get,
                       encoding: JSONEncoding.default,
                       headers: nil)
              .validate(statusCode: 200..<500)
              .responseJSON(completionHandler: { (response) in
                  switch response.result {
                  case .success(let data):
                      let decoder = JSONDecoder()
                      switch response.response?.statusCode {
                      case 200, 204:
                          /// Handle success, parse JSON data
                          if let responseData = response.data {
                              do {
                                  let users = try decoder.decode(PersonsModel.self, 
                                                                 from: JSONSerialization.data(withJSONObject: data.self))
                                  observer.onNext(.success(users.results))
                              } catch {
                                  /// Handle json decode error
                                  print(error)
                                  observer.onNext(.error(APIError.apiFailure(message: ErrorType.unknown.message)))
                              }
                          } else {
                              observer.onNext(.error(APIError.apiFailure(message: ErrorType.unknown.message)))
                          }
                          
                      case 429:
                          /// Handle 429 error
                          observer.onNext(.error(APIError.apiFailure(message: ErrorType.unknown.message)))
                      default:
                          /// Handle unknown error
                          observer.onNext(.error(APIError.apiFailure(message: ErrorType.unknown.message)))
                      }
                  case .failure(let failure):
                      /// Handle request failure
                      print(failure.localizedDescription)
                      observer.onNext(.error(APIError.apiFailure(message: ErrorType.unknown.message)))
                  }
              })
            return Disposables.create()
        }
    }
}
