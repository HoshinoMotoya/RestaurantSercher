//
//  SearchView.swift
//  RestaurantSercher
//
//  Created by cmStudent on 2020/03/31.
//  Copyright © 2020 19cm0133. All rights reserved.
//

import UIKit
import CoreLocation

///  検索条件入力画面用
class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet var radiusTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var locationManager: CLLocationManager!
    var latitudeNow: String = ""        //  緯度
    var longitudeNow: String = ""       //  経度
    var addressNow: String = ""         //  住所
    var radiusText: String = ""         //  半径
    
    var pickerView: UIPickerView = UIPickerView()
    let radiusList = ["300", "500", "1000", "2000", "3000"]    //半径リスト
    
    // PickerView処理
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return radiusList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return radiusList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.radiusTextField.text = radiusList[row]
    }
    
    ///        起動時処理
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupLocationManager()
        
        //  PickerViewの詳細設定
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        radiusTextField.inputView = pickerView
        radiusTextField.inputAccessoryView = toolbar
        
        pickerView.selectRow(0, inComponent: 0, animated: false)
        
        if addressNow == "" {
            searchButton.isEnabled = false
        } else {
            searchButton.isEnabled = true
        }
    }
    
    //  Doneを押した時の処理
    @objc func done() {
        radiusTextField.endEditing(true)
        radiusTextField.text = "\(radiusList[pickerView.selectedRow(inComponent: 0)])"
        radiusText = radiusTextField.text!
    }
    
    /// 位置情報取得処理
    /// 位置情報取得を押したら、ラベルに位置情報をセットする
    /// - Parameter sender: "位置情報取得"ボタン
    @IBAction func getLocationInfo(_ sender: Any) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        //  権限の取得（アプリ使用中のみ）
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        //  権限が得られたら位置情報の取得を開始する
        //  得られていないならアラートを表示
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            showAlert()
        }
    }
    
    /// アラート処理
    /// 位置情報取得の許可を確認する
    func showAlert() {
        let alertTitle = "位置情報取得が許可されていません"
        let alertMessage = "設定アプリの「プライバシー > 位置情報サービス」から変更してください。"
        let alert: UIAlertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        //  OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        //  UIAlertControllerにOKを追加
        alert.addAction(defaultAction)
        //  Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    /// 検索画面遷移処理
    /// 検索ボタンを押すと、検索結果画面へ遷移する
    /// - Parameter sender: "検索"ボタン
    @IBAction func SearchButton(_ sender: Any) {
        if let resultViewController = storyboard?.instantiateViewController(withIdentifier: "result") as? ResultViewController {
            //  必要な情報を送る
            switch radiusText {
            case "300": resultViewController.radius = "1"   //300mのとき、1
                break
            case "500": resultViewController.radius = "2"   //500mのとき、2
                break
            case "1000": resultViewController.radius = "3"  //1kmのとき、3
                break
            case "2000": resultViewController.radius = "4"  //2kmのとき、4
                break
            case "3000": resultViewController.radius = "5"  //5kmのとき、5
                break
            default:
                resultViewController.radius = "2"            //何もないなら、デフォルト値の2
            }
            
            resultViewController.latitude = latitudeNow
            resultViewController.longitude = longitudeNow
            
            present(resultViewController, animated: true, completion: nil)
            
            print("ResultViewへ")
        }
    }

    /// 詳細条件画面遷移処理
    /// 詳細検索ボタンを押すと、詳細条件画面に遷移する
    /// - Parameter Sender: "詳細条件"ボタン
    @IBAction func detailButton(_ sender: Any) {
        if let detailViewCotroller = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            
            present(detailViewCotroller, animated: true, completion: nil)
        }
    }
    // goToTitle処理
    @IBAction func goToTitle(_ segue: UIStoryboardSegue){
        addressLabel.text? = ""
        radiusTextField.text? = ""
        searchButton.isEnabled = false
    }
}

extension SearchViewController: CLLocationManagerDelegate {
    /// 位置情報の取得・更新
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        //  位置情報を格納する
        self.latitudeNow = String(latitude!)
        self.longitudeNow = String(longitude!)
        
        let locationGeo = CLLocation(latitude: Double(latitudeNow) as! CLLocationDegrees, longitude: Double(longitudeNow) as! CLLocationDegrees)
        CLGeocoder().reverseGeocodeLocation(locationGeo) { placemarks, error in
            guard
                let placemark = placemarks?.first, error == nil,
                let administrativeArea = placemark.administrativeArea, // 都道府県
                let locality = placemark.locality, // 市区町村
                let thoroughfare = placemark.thoroughfare, // 地名(丁目)
                let subThoroughfare = placemark.subThoroughfare, // 番地
                let postalCode = placemark.postalCode, // 郵便番号
                let location = placemark.location // 緯度経度情報
                else {
                    self.addressNow = ""
                    return
            }
            
            self.addressNow = """
            〒\(postalCode)\(administrativeArea)\(locality)\(thoroughfare)\(subThoroughfare)
            """     //住所
            
            print("\(self.addressNow)")
            
            self.addressLabel.text = self.addressNow    //住所をラベルにセット
            
            self.searchButton.isEnabled = true
            
            print("latitude:\(latitude!)\nlongitude:\(longitude!)")
        }
    }
}
