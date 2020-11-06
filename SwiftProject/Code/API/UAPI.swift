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



let ApiProvider = MoyaProvider<UApi>(requestClosure: timeOutClosure)
///带加载圈
let ApiLoadingProvider = MoyaProvider<UApi>(requestClosure: timeOutClosure,  plugins: [LoadingPlugin])


enum UApi {
    case boutiqueList(sexType:Int) //推荐列表
    case comicList(argCon: Int, argName:String ,argValue:Int ,page: Int) //漫画列表
    case vipList//VIP列表
    case subscribeList//订阅列表
    case rankList//排行列表
    case cateList//分类列表
    case special(argCon:Int, page:Int)//专题列表
    case detailStatic(comicid: Int)//详情(基本)
    case detailRealtime(comicid: Int)//详情(实时)
    case commentList(object_id: Int, thread_id: Int, page: Int)//评论
    case guessLike//猜你喜欢
    
}

extension UApi: TargetType{//Moya协议
    
    ///域名
    var baseURL: URL {return URL(string: "http://app.u17.com/v3/appV3_3/ios/phone/")!}
    ///路径
    var path: String {
        switch self {
        case .boutiqueList: return "comic/boutiqueListNew"//首页数据
        case .comicList: return "list/commonComicList"//漫画列表
        case .vipList: return "list/vipList"//VIP列表
        case .subscribeList: return "list/newSubscribeList"//订阅列表
        case .rankList: return "rank/list"//排行列表
        case .cateList: return "sort/mobileCateList"//分类列表
        case .special: return "comic/special"//专题列表
        case .detailStatic: return "comic/detail_static_new"//详情(基本)
        case .detailRealtime: return "comic/detail_realtime"//详情(实时)
        case .commentList: return "comment/list"//评论
        case .guessLike: return "comic/guessLike"//猜你喜欢
        }
    }
    ///请求方式
    var method: Moya.Method { return .get}
    ///task
    var task: Task {
        var parameters:[String:Any] = [:]
        switch self {
        case .boutiqueList(let sexType):
            parameters["sexType"] = sexType
            
        case .comicList(let argCon ,let argName,let argValue,let page):
            parameters["argCon"] = argCon
            if argName.count > 0 {parameters["argName"] = argName}
            parameters["argValue"] = argValue
            parameters["page"] = max(1, page)
            
        case .special(let argCon, let page):
            parameters["argCon"] = argCon
            parameters["page"] = page
        case .detailStatic(let comicid),
             .detailRealtime(let comicid):
            parameters["comicid"] = comicid
        case .commentList(let object_id, let thread_id, let page):
            parameters["object_id"] = object_id
            parameters["thread_id"] = thread_id
            parameters["page"] = page
        default: break
        }
        
        ULog("\(baseURL)\(path)?\(parameters)")
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
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
//            ULog("请求地址=\(target.baseURL.appendingPathComponent(target.path).absoluteString) 请求参数=\(String(describing: target))")
            completion(returnData.data?.returnData)
        }
    }
}
