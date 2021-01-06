//
//  NoticeBoardModel.swift
//  NoticeBoardApp
//
//  Created by Ramesh Madavaram on 05/01/21.
//

import Foundation

//struct NoticeBoardBaseModel :Decodable {
//    let notice : [NoticeBoard]
//}
//struct NoticeBoard :Decodable {
//    let title : String?
//    let description : String?
//    let status : Int?
//    let postdate : String?
//    let id : String?
//    let appartmentId : String?
//}
struct NoticeBoardBaseModel : Codable {

        let appartmentId : String?
        let descriptionField : String?
        let id : String?
        let postdate : String?
        let status : Int?
        let title : String?

        enum CodingKeys: String, CodingKey {
                case appartmentId = "appartmentId"
                case descriptionField = "description"
                case id = "id"
                case postdate = "postdate"
                case status = "status"
                case title = "title"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                appartmentId = try values.decodeIfPresent(String.self, forKey: .appartmentId)
                descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                postdate = try values.decodeIfPresent(String.self, forKey: .postdate)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
                title = try values.decodeIfPresent(String.self, forKey: .title)
        }

}
