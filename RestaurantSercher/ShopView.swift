//
//  ShopView.swift
//  RestaurantSercher
//
//  Created by cmStudent on 2020/03/31.
//  Copyright © 2020 19cm0133. All rights reserved.
//

import UIKit
import MapKit

///  店舗詳細画面用
class ShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopImageView1: UIImageView!
    @IBOutlet weak var shopImageView2: UIImageView!
    
    @IBOutlet weak var shopTableView: UITableView!
    
    var shopDetailList: [String] = []
    
    var shopName: String = ""           //店舗名
    var latitude: String = ""           //緯度
    var longitude: String = ""          //経度
    var nowLatitude: String = ""        //現在地の緯度
    var nowLongitude: String = ""       //現在地の経度
    var address: String = ""            //住所
    var phoneNumber: String = ""        //電話番号
    var time: String = ""               //営業時間
    var mapURLString: String = ""       //地図アプリのURL格納用変数
    var imageURL1: String = ""          //shopImageView用のURL
    var imageURL2: String = ""          //shopImageView用のURL
    
    //tableView処理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopDetailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShopTableViewCell
        
        ///indexPath.rowに応じて住所などを表示する処理
        //  0 -> 住所
        //  1 -> 電話番号
        //  2 -> 営業時間
        //  3 -> 休業日
        //  4 -> PR文
        //  5 -> フリーワードカテゴリー
        //  当てはまらないときは、データがありませんと表示
        switch indexPath.row {
        case 0:
            cell.categoryLabel.text? = "住所"
            cell.detailLabel.text? = shopDetailList[indexPath.row]
            break
        case 1:
            cell.categoryLabel.text? = "電話番号"
            cell.detailLabel.text? = shopDetailList[indexPath.row]
            break
        case 2:
            cell.categoryLabel.text? = "営業時間"
            cell.detailLabel.text? = shopDetailList[indexPath.row]
            break
        case 3:
            cell.categoryLabel.text? = "休業日"
            cell.detailLabel.text? = shopDetailList[indexPath.row]
            break
        case 4:
            cell.categoryLabel.text? = "PR"
            cell.detailLabel.text? = shopDetailList[indexPath.row]
            break
        case 5:
            cell.categoryLabel.text? = "種類"
            cell.detailLabel.text? = shopDetailList[indexPath.row]
        default:
            cell.detailLabel.text? = "データがありません"
        }
        
        return cell
    }
    
    /// セルをタップした時の処理
    //  indexPath.rowが0の時、地図アプリを開く
    //  indexPath.rowが1の時、電話をかける
    //  このとき、どちらの場合もAlertDialogを挟む
    //  それ以外のときは処理なし
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //  AlertDialog
            let alertTitle = "地図アプリを開きますか？"
            let alertMessage = ""
            let alert: UIAlertController = UIAlertController(
                title: alertTitle,
                message: alertMessage,
                preferredStyle: .alert
            )
            
            let ok = UIAlertAction(title: "開く",
                                   style: .default,
                                   handler: {(action: UIAlertAction) in
                //  ジオコーディング
                CLGeocoder().geocodeAddressString(self.address) { placemarks , error in
                    if let latitude = placemarks?.first?.location?.coordinate.latitude {
                        self.latitude = String(latitude)
                        print("緯度：\(latitude)")
                    }
                    if let longitude = placemarks?.first?.location?.coordinate.longitude {
                        self.longitude = String(longitude)
                        print("緯度：\(longitude)")
                        }
                    }
                //  外部の地図アプリを開く処理
                if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                    self.mapURLString = "comgooglemaps://?center=\(self.latitude),\(self.longitude)&views=traffic&mapmpde=standard&zoom=14"
                } else {
                    self.mapURLString = "http://maps.apple.com/?daddr=\(self.latitude),\(self.longitude)&dirflg=w"
                }
                if let url = URL(string: self.mapURLString) {
                    UIApplication.shared.open(url)
                }
            })
            
            
            let cancel = UIAlertAction(title: "戻る",
                                       style: .cancel,
                                       handler: nil)
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            //AlertDialog
            let alertTitle = "電話をかけますか？"
            let alertMessage = ""
            let alert: UIAlertController = UIAlertController(
                title: alertTitle,
                message: alertMessage,
                preferredStyle: .alert
            )
            let ok = UIAlertAction(title: "かける",
                                   style: .default,
                                   handler: {(action: UIAlertAction) in
                                    let url = NSURL(string: "tel://09012345678")!
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(url as URL)
                                    } else {
                                        UIApplication.shared.openURL(url as URL)
                                    }
            })
            
            let cancel = UIAlertAction(title: "戻る",
                                       style: .cancel,
                                       handler: nil)
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        } else {
            return
        }
    }
    
    ///    起動時処理
    override func viewDidLoad() {
        super.viewDidLoad()
        //  店舗名をラベルにセット
        shopNameLabel.text? = shopName
        
        //  shopImageView1に画像をセット
        if imageURL1 == "" {
            let forkspoonImagePath = Bundle.main.path(forResource: "fork_spoon", ofType: "png")
            shopImageView1.image = UIImage(contentsOfFile: forkspoonImagePath!)
            print("URLなし")
        } else {
            let url = URL(string: imageURL1)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    self.shopImageView1.image = UIImage(data: data!)
                }
            }).resume()
        }
        //  shopImageView2に画像をセット
        if imageURL2 == "" {
            let forkspoonImagePath = Bundle.main.path(forResource: "fork_spoon", ofType: "png")
            shopImageView2.image = UIImage(contentsOfFile: forkspoonImagePath!)
            print("URLなし")
        } else {
            let url = URL(string: imageURL2)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    self.shopImageView2.image = UIImage(data: data!)
                }
            }).resume()
        }
        //  nib処理
        let nib = UINib(nibName: "ShopTableViewCell", bundle: nil)
        self.shopTableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    /// 検索結果画面へ
    /// - Parameter Sender: "検索結果へ"ボタン
    @IBAction func BackButton(_ sender: Any) {
        if let resultViewController = storyboard?.instantiateViewController(withIdentifier: "result") as? ResultViewController {
            
            //  現在地を渡す
            resultViewController.latitude = nowLatitude
            resultViewController.longitude = nowLongitude
            
            present(resultViewController, animated: true, completion: nil)
        }
    }
    
    /// 検索条件画面へ
    /// - Parameter Sender: "検索条件へ＂ボタン
    /// goToTitleで設定しているためこちらには処理の記述なし
}
