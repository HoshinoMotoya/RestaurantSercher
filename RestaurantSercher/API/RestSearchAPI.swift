//
//  RestSearchAPI.swift
//  RestaurantSercher
//
//  Created by cmStudent on 2020/03/31.
//  Copyright © 2020 19cm0133. All rights reserved.
//

import UIKit

struct JSONRest: Codable {
    var total_hit_count: Int
    var hit_per_page: Int
    var page_offset: Int
    var rest: [Rest]
}

struct Rest: Codable {
    var id: String?
    var update_date: String?
    var name: String?
    var name_kana: String?
    var latitude: String?
    var longitude: String?
    var category: String?
    var url: String?
    var url_mobile: String?
    var coupon_url: CouponUrl?
    var image_url: ImageUrl?
    var address: String?
    var tel: String?
    var tel_sub: String?
    var fax: String?
    var opentime: String?
    var holiday: String?
    var access: Access
//    var parking_lots: Int?
    var pr: PR?
    var code: Code?
//    var budget: Int?
//    var party: Int?
//    var lunch: Int?
    var credit_card: String?
    var e_money: String?
    var flags: Flags?
    
}

struct CouponUrl: Codable {
    var pc: String?
    var mobile: String?
}

struct ImageUrl: Codable {
    var shop_image1: String?
    var shop_image2: String?
    var qrcode: String?
}

struct Access: Codable {
    var line: String?
    var station: String?
    var station_exit: String?
    var walk: String?
    var note: String?
}

struct PR: Codable {
    var pr_short: String?
    var pr_long: String?
}

struct Code: Codable {
    var areacode: String?
    var areaname: String?
    var prefcode: String?
    var prefname: String?
    var areacode_s: String?
    var areaname_s: String?
    var category_code_l: [String]
    var category_name_l: [String]
    var category_code_s: [String]
    var category_name_s: [String]
}

struct Flags: Codable {
    var mobile_site: Int
    var mobile_coupon: Int
    var pc_coupon: Int
}
