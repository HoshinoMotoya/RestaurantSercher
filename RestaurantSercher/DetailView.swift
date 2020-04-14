//
//  DetailView.swift
//  RestaurantSercher
//
//  Created by cmStudent on 2020/03/31.
//  Copyright © 2020 19cm0133. All rights reserved.
//

import UIKit

///  検索条件入力画面の詳細条件用
class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let detailList: [String] = ["ランチ営業あり",
                                "禁煙席あり",
                                "カード利用可",
                                "飲み放題あり",
                                "日曜営業あり",
                                "テイクアウトあり",
                                "個室あり",
                                "深夜営業あり",
                                "駐車場あり",
                                "誕生日特典あり",
                                "キッズメニューあり",
                                "食べ放題あり",
                                "14時以降のランチあり",
                                "ランチデザートあり",
                                "ペット同伴可",
                                "デリバリーあり",
                                "電子マネー利用可",
                                "デザートビュッフェあり",
                                "ランチビュッフェあり",
                                "お弁当あり",
                                "ランチサラダバーあり",
                                "Web予約可"]
    
        
    @IBOutlet weak var conditionTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell
        
        cell.conditionLabel.text? = detailList[indexPath.row]
        
        
        return cell
    }
    
    
    
    
///    起動時処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "DetailTableViewCell", bundle: nil)
        self.conditionTableView.register(nib, forCellReuseIdentifier: "detailCell")
    }
}
