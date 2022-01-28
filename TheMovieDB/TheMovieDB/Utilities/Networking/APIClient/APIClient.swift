//
//  APIClient.swift
//  TheMovieDB
//
//  Created by Ahmed Tarek on 28/01/2022.
//

import Foundation
import Alamofire
import RxSwift

class APIClient<T: TargetType> {
    
    func fetchData<X: Decodable>(target: T) -> Observable<Result<X, NSError>>{
        return Observable.create { observer in
            let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
            let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
            let params = self.buildParams(task: target.task)
            print(params)
            AF.request(target.baseURL + target.path, method: method, parameters: params.0, encoding: params.1, headers: headers).responseDecodable (decoder: JSONDecoder()) { (response: DataResponse<X, AFError>) in
                if let data = response.value{
                    observer.onNext(.success(data))
                }else{
                    let statusCode = response.response?.statusCode
                    let error = NSError(domain: target.baseURL, code: statusCode ?? 0, userInfo: [NSLocalizedDescriptionKey: response.error?.localizedDescription ?? ErrorMessage.genericError])
                    observer.onNext(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    private func buildParams(task: Task) -> ([String:Any]?, ParameterEncoding) {
        switch task {
        case .requestPlain:
            return (nil, URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        }
    }
}
