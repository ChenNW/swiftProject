//
//  UAPI.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/30.
//

import Result

///自定义超时时间
let timeOutClosure = {(endPoint:Endpoint,closure:MoyaProvider<UApi>.RequestResultClosure) -> Void in
    
    if var urlRequest = try? endPoint.urlRequest() {
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
        
    }else{
        closure(.failure(MoyaError.requestMapping(endPoint.url)))
    }
    
}

let LoadingPlugin = NetworkActivityPlugin{ (type ,target) in
    
    guard let vc = topVC else {return}
    switch type {
    case .began:
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: vc.view, animated: true)
        }
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: vc.view, animated: true)
        }
    case .ended:
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: vc.view, animated: true)
        }
    }
    
}




let ApiLoadingProvider = MoyaProvider<UApi>(requestClosure: timeOutClosure,  plugins: [LoadingPlugin])


enum UApi {
    case boutiqueList(sexType:Int) //推荐列表
}

extension UApi: TargetType{//Moya协议
    
    ///域名
    var baseURL: URL {return URL(string: "http://app.u17.com/v3/appV3_3/ios/phone/")!}
    ///路径
    var path: String {
        switch self {
        case .boutiqueList: return "comic/boutiqueListNew"
            
        }
    }
    ///请求方式
    var method: Moya.Method { return .get}
    ///task
    var task: Task {
        var parmeters:[String:Any] = [:]
        switch self {
        case .boutiqueList(let sexType):
            parmeters["sexType"] = sexType
       
        }
        
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    
    var sampleData: Data{
        return "".data(using: String.Encoding.utf8)!
    }
    ///请求头
    var headers: [String : String]? { return nil }

}

///结果回调
extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        
        let jsonString = String(data: data, encoding: .utf8)
        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            throw MoyaError.jsonMapping(self)
        }
        return model
        
    }
}

extension MoyaProvider {
    @discardableResult
    open func request<T: HandyJSON>(_ target: Target,
                                    model: T.Type,
                                    completion: ((_ returnData: T?) -> Void)?) -> Cancellable? {
        
        return request(target) { (result) in
            guard let completion = completion else { return }
            guard let returnData = try? result.value?.mapModel(ResponseData<T>.self) else {
                completion(nil)
                return
            }
            completion(returnData.data?.returnData)
        }
    }
}