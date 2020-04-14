//
//  ResultView.swift
//  RestaurantSercher
//
//  Created by cmStudent on 2020/03/31.
//  Copyright © 2020 19cm0133. All rights reserved.
//

import UIKit

///  検索結果画面用
class ResultViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var CountLabel: UILabel!
    @IBOutlet weak var ResultCollectionView: UICollectionView!
    
    var shopList: [Rest] = []   //APIから取得した店舗の一覧
    //  別のViewControllerから渡された値を格納する変数
    var latitude: String = ""       //緯度
    var longitude: String = ""      //経度
    var radius: String = ""         //半径○m圏内
    public static var latitudeStatic: String = ""   //緯度
    public static var longitudeStatic: String = ""  //経度
    public static var radiusStatic: String = ""     //半径○m圏内
    
    //  CollectionView処理
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if shopList.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ResultCollectionViewCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ResultCollectionViewCell
        
        cell.ShopName.text? = shopList[indexPath.row].name!
        cell.ShopAddress.text? = shopList[indexPath.row].address!
        cell.shopAccess.text? = "\(shopList[indexPath.row].access.line!)\(shopList[indexPath.row].access.station!)\(shopList[indexPath.row].access.station_exit!)から\(shopList[indexPath.row].access.walk!)分"
        
        //  cellのshopImageに画像をセット
        if let image = shopList[indexPath.row].image_url?.shop_image1 {
            let url = URL(string: image)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    cell.ShopImage.image = UIImage(data: data!)
                }
            }).resume()
        } else {
            let forkspoonImagePath = Bundle.main.path(forResource: "fork_spoon", ofType: "png")
            cell.ShopImage.image = UIImage(contentsOfFile: forkspoonImagePath!)
            print("URLなし")
        }
        
        return cell
    }
    
    /// 店舗の詳細画面へ
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let shopViewController = storyboard?.instantiateViewController(withIdentifier: "shop") as? ShopViewController {
            //  必要な情報を送る
            shopViewController.shopName = shopList[indexPath.row].name!
            shopViewController.latitude = shopList[indexPath.row].latitude!
            shopViewController.longitude = shopList[indexPath.row].longitude!
            shopViewController.address = shopList[indexPath.row].address!
            shopViewController.phoneNumber = shopList[indexPath.row].tel!
            shopViewController.time = shopList[indexPath.row].opentime!
            
            //  shopDetailListへの追加
            shopViewController.shopDetailList.append(shopList[indexPath.row].address!)
            shopViewController.shopDetailList.append(shopList[indexPath.row].tel!)
            shopViewController.shopDetailList.append(shopList[indexPath.row].opentime!)
            shopViewController.shopDetailList.append(shopList[indexPath.row].holiday!)
            shopViewController.shopDetailList.append((shopList[indexPath.row].pr?.pr_short!)!)
            shopViewController.shopDetailList.append(shopList[indexPath.row].category!)
            
            if let image1 = shopList[indexPath.row].image_url?.shop_image1 {
                shopViewController.imageURL1 = (self.shopList[indexPath.row].image_url?.shop_image1!)!
            } else {
                shopViewController.imageURL1 = ""
                print("URLなし")
            }
            
            if let image2 = shopList[indexPath.row].image_url?.shop_image2 {
                shopViewController.imageURL2 = (self.shopList[indexPath.row].image_url?.shop_image2!)!
            } else {
                shopViewController.imageURL2 = ""
                print("URLなし")
            }
            
            shopViewController.nowLatitude = latitude
            shopViewController.nowLongitude = longitude
            
            present(shopViewController, animated: true, completion: nil)
        }
    }
    
    ///    起動時処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ResultViewController.latitudeStatic = latitude
        ResultViewController.longitudeStatic = longitude
        ResultViewController.radiusStatic = radius
        
        //  API呼び出し
        shopList = getGuruNaviAPI()
        
        if shopList.count == 0 {
            CountLabel.text? = "検索結果がみつかりませんでした\n検索条件を変えて再度検索してください"
        } else {
            CountLabel.text? = "\(shopList.count)軒見つかりました"
        }
        //  CollectionViewのlayoutを設定
        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 390, height: 390)
        layout.minimumInteritemSpacing = ResultCollectionView.bounds.height
//        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        ResultCollectionView.dataSource = self
        ResultCollectionView.isScrollEnabled = false
        ResultCollectionView.backgroundColor = .gray
        
        let nib = UINib(nibName: "ResultCollectionViewCell", bundle: nil)
        self.ResultCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        
        ResultCollectionView.collectionViewLayout = layout
    }
    
    /// API取得処理
    /// API取得処理
    public final func getGuruNaviAPI() -> [Rest] {
        
        let APIURL: String = "https://api.gnavi.co.jp/RestSearchAPI/v3/"    //APIURL
        let APIKey: String = "666195555c9e0caa8dd1d2bdeb7f42b7"             //APIKey
        
        var latitude: String = ""   //緯度
        var longitude: String = ""  //経度
        var radius: String = ""     //半径○m圏内
        
        latitude = ResultViewController.latitudeStatic
        longitude = ResultViewController.longitudeStatic
        radius = ResultViewController.radiusStatic
        
        let APIList: [String] = [APIURL,                //URL
            "?keyid=",             //keyid
            APIKey,                //APIKey
            "&latitude=",
            latitude,              //緯度
            "&longitude=",
            longitude,             //経度
            "&range=",
            radius,                //何m圏内
            "&offset_page=",       //初期開始位置
            "&hit_per_page=50",    //最大取得数(50)
        ]
        
        var API: String = ""    //APIURL格納
        //  APIListの中身を取り出す
        for api in APIList {
            API += api
        }
        
        var shopList: [Rest] = []
        
        print(API)
        //  API取得
        guard let url: URL = URL(string: API) else { return [] }
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: url, completionHandler:{data,response,error in
            do{
                guard let response = response as? HTTPURLResponse else { return }
                if response.statusCode != 200 {
                    print("サイトからのレスポンスコードが異常\(response.statusCode)")
                    return
                }
                let jsonRest = try JSONDecoder().decode(JSONRest.self, from: data!)
                shopList = jsonRest.rest
                semaphore.signal()
                print("処理終了")
                dump(shopList)
            }catch (let message) {
                shopList = []
                print("エラーが発生しました。")
                print(message)
                return
            }
        })
        task.resume()
        semaphore.wait()
        return shopList
    }
    
    /// 検索条件画面へ
    /// - Parameter Sender: "検索条件へ"ボタン
    /// goToTitleで設定しているためこちらには処理の記述なし
}

