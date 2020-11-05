//
//  UModel.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/2.
//

///首页model
struct BoutiqueListModel:HandyJSON {
//    var galleryItems = <#value#>
//    var textItems = <#value#>
    var comicLists:[ComicListsModel]?
    var editTime: TimeInterval = 0
}
enum UComicType: Int ,HandyJSONEnum {
    case none = 0
    case update = 3
    case thematic = 5
    case animation = 9
    case billboard = 11
}

struct spinnerListModel:HandyJSON {
    var argCon:Int = 0
    var name:String?
    var conTag:String?
}
struct defaultParametersModel:HandyJSON {
    var defaultSelection:Int = 0
    var defaultArgCon:Int = 0
    var defaultConTagType:String?
}

struct VipListModel:HandyJSON {
    var newVipList:[ComicListsModel]?
}
struct SubscribeListModel:HandyJSON {
    var newSubscribeList:[ComicListsModel]?
}

struct ComicListsModel: HandyJSON {
    var comics:[ComicModel]?
    var canedit: Bool = false
    var sortId: Int = 0
    var titleIconUrl: String?
    var newTitleIconUrl: String?
    var description: String?
    var itemTitle: String?
    var argCon: Int = 0
    var argName: String?
    var argValue: Int = 0
    var argType: Int = 0
    var comicType: UComicType = .none
    var maxSize: Int = 0
    var canMore: Bool = false
    var hasMore: Bool = false
    var page: Int = 0
    var spinnerList:[spinnerListModel]?
    var defaultParameters:defaultParametersModel?
    
}
struct ComicModel: HandyJSON {
    var comicId: Int = 0
    var comic_id: Int = 0
    var cate_id: Int = 0
    var name: String?
    var title: String?
    var itemTitle: String?
    var subTitle: String?
    var author_name: String?
    var author: String?
    var cover: String?
    var wideCover: String?
    var content: String?
    var description: String?
    var short_description: String?
    var affiche: String?
    var tag: String?
    var tags: [String]?
    var group_ids: String?
    var theme_ids: String?
    var url: String?
    var read_order: Int = 0
    var create_time: TimeInterval = 0
    var last_update_time: TimeInterval = 0
    var deadLine: TimeInterval = 0
    var new_comic: Bool = false
    var chapter_count: Int = 0
    var cornerInfo: Int = 0
    var linkType: Int = 0
    var specialId: Int = 0
    var specialType: Int = 0
    var argName: String?
    var argValue: Int = 0
    var argCon: Int = 0
    var flag: Int = 0
    var conTag: Int = 0
    var isComment: Bool = false
    var is_vip: Bool = false
    var isExpired: Bool = false
    var canToolBarShare: Bool = false
    var ext: [ExtModel]?
}

struct ExtModel:HandyJSON {
    var key:String?
    var val:String?
    
}

///排行
struct RankingModel: HandyJSON {
    var argCon: Int = 0
    var argName: String?
    var argValue: Int = 0
    var canEdit: Bool = false
    var cover: String?
    var isLike: Bool = false
    var sortId: Int = 0
    var sortName: String?
    var title: String?
    var subTitle: String?
    var rankingType: Int = 0
}

struct RankinglistModel: HandyJSON {
    var rankinglist: [RankingModel]?
}

///分类
struct CategoryModel:HandyJSON {
    var recommendSearch: String?
    var rankingList:[RankingModel]?
}


///详情model
struct DetailStaticModel: HandyJSON {
    var comic: ComicStaticModel?
    var chapter_list: [ChapterStaticModel]?
    var otherWorks: [OtherWorkModel]?
}

struct ComicStaticModel: HandyJSON {
    var name: String?
    var comic_id: Int = 0
    var short_description: String?
    var accredit: Int = 0
    var cover: String?
    var is_vip: Int = 0
    var type: Int = 0
    var ori: String?
    var theme_ids: [String]?
    var series_status: Int = 0
    var last_update_time: TimeInterval = 0
    var description: String?
    var cate_id: String?
    var status: Int = 0
    var thread_id: Int = 0
    var last_update_week: String?
    var wideCover: String?
    var classifyTags: [ClassifyTagModel]?
    var is_week: Bool = false
    var comic_color: String?
    var author: AuthorModel?
    var is_dub: Bool = false
}
struct ClassifyTagModel: HandyJSON {
    var name: String?
    var argName: String?
    var argVal: Int = 0
}
struct AuthorModel: HandyJSON {
    var id: Int = 0
    var avatar: String?
    var name: String?
}

struct ImHightModel: HandyJSON {
    var height: Int = 0
    var width: Int = 0
}

struct ChapterStaticModel: HandyJSON {
    var chapter_id: Int = 0
    var name: String?
    var image_total: Int = 0
    var type: Int = 0
    var price:String?
    var size: Int32 = 0
    var pass_time: TimeInterval = 0
    var release_time: TimeInterval = 0
    var zip_high_webp: Int = 0
    var is_new: Bool = false
    var has_locked_image: Bool = false
    var imHightArr: [[ImHightModel]]?
    var countImHightArr: Int = 0
}
struct OtherWorkModel: HandyJSON {
    var comicId: Int = 0
    var coverUrl: String?
    var name: String?
    var passChapterNum: Int = 0
}
///猜你喜欢
struct GuessYouLikeModel:HandyJSON {
    var normal:Bool = false
    var last_modified:Int = 0
    var comics:[ComicModel]?
}

///详情实时数据

struct ComicRealtimeModel: HandyJSON {
    var comic_id: Int = 0
    var user_id: Int = 0
    var status: Int = 0
    var click_total: String?
    var total_ticket: String?
    var comment_total: String?
    var total_tucao: String?
    var favorite_total: String?
    var gift_total: String?
    var monthly_ticket: String?
    var vip_discount: Double = 0
    var is_vip_free: Bool = false
    var is_free: Bool = false
    var is_vip_buy: Bool = false
    var is_auto_buy: Bool = false
}

struct ChapterRealtimeModel: HandyJSON {
    var vip_images: Int = 0
    var is_view: Bool = false
    var chapter_id: Int = 0
    var buyed: Bool = false
    var buy_price: String?
    var read_state: Int = 0
    var is_free: Bool = false
}
struct DetailRealtimeModel:HandyJSON {
    var comic:ComicRealtimeModel?
    var chapter_list:[ChapterRealtimeModel]?
    
    
}








struct ReturnData<T: HandyJSON> :HandyJSON {
    var message: String?
    var returnData: T?
    var stateCode: Int = 0
}

struct ResponseData<T: HandyJSON> : HandyJSON{
    var code: Int = 0
    var data: ReturnData<T>?
}
