//
//  ViewController.swift
//  iCripto
//
//  Created by Sebastian Ortiz Velez on 18/04/2019.
//  Copyright © 2019 Sebastian Ortiz Velez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var coins : Array<Coin> = []
    
    //UI controls
    @IBOutlet weak var viewFirstCoin: UIView!{
        didSet {
            viewFirstCoin.setGradient(colorTop: (UIColor(named: "purpleTop")?.cgColor)!, colorBottom: (UIColor(named: "purpleBottom")?.cgColor)!)
        }
    }
    
    @IBOutlet weak var viewSecondCoin: UIView!{
        didSet {
            viewSecondCoin.setGradient(colorTop: (UIColor(named: "greenTop")?.cgColor)!, colorBottom: (UIColor(named: "greenBottom")?.cgColor)!)
        }
    }
    
    @IBOutlet weak var viewThirdCoin: UIView!{
        didSet{
            viewThirdCoin.setGradient(colorTop: (UIColor(named: "orangeTop")?.cgColor)!, colorBottom: (UIColor(named: "orangeBottom")?.cgColor)!)
        }
    }
    
    @IBOutlet weak var viewFourthCoin: UIView!{
        didSet{
             viewFourthCoin.setGradient(colorTop: (UIColor(named: "pinkTop")?.cgColor)!, colorBottom: (UIColor(named: "pinkBottom")?.cgColor)!)
        }
    }
    
    @IBOutlet weak var lblToday: UILabel!{
        didSet{
            lblToday.text = setFormatedDate(date: Date())
        }
    }
    
    @IBOutlet weak var lblFirstCoinName: UILabel!
    @IBOutlet weak var lblFirstCoinPrice: UILabel!
    
    @IBOutlet weak var lblSecondCoinName: UILabel!
    @IBOutlet weak var lblSecondCoinPrice: UILabel!
    
    @IBOutlet weak var lblThirdCoinName: UILabel!
    @IBOutlet weak var lblThirdCoinPrice: UILabel!
    
    @IBOutlet weak var lblFourthCoinName: UILabel!
    @IBOutlet weak var lblFourthCoinPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadCoins()
        addGestures()
    }
    
    func addGestures(){
        let views : [UIView] = [viewFirstCoin, viewSecondCoin, viewThirdCoin, viewFourthCoin]
        for i in 0..<views.count{
            let tap = UITapGestureRecognizer(target: self, action: #selector(openCoinsView(sender:)))
            tap.accessibilityLabel = String(i + 1)
            views[i].addGestureRecognizer(tap)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadCoins(coinType: "firstCoin")
//        reloadCoins(coinType: "secondCoin")
//        reloadCoins(coinType: "thirdCoin")
//        reloadCoins(coinType: "fourthCoin")
    }
    
    func reloadCoins(coinType : String){
        
        if let storedObject: Data = UserDefaults.standard.object(forKey: coinType) as? Data {
            let coin: Coin = try! PropertyListDecoder().decode(Coin.self, from: storedObject)
            print("Main view controller \(coin.name)")
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            formatter.currencySymbol = "$"
                    
            let priceString = coin.priceUsd
            var priceNumber : NSNumber = 0
            if let priceInteger = Double(priceString){
                priceNumber = NSNumber(value: priceInteger)
            }
            
            let price = formatter.string(from: priceNumber)
            
            switch coinType {
                case "firstCoin":
                    lblFirstCoinName.text = "\(coin.symbol) - \(coin.name)"
                    lblFirstCoinPrice.text = price
                case "secondCoin":
                    lblSecondCoinName.text = "\(coin.symbol) - \(coin.name)"
                    lblSecondCoinPrice.text = price
                case "thirdCoin":
                    lblThirdCoinName.text = "\(coin.symbol) - \(coin.name)"
                    lblThirdCoinPrice.text = price
                default:
                    lblFourthCoinName.text = "\(coin.symbol) - \(coin.name)"
                    lblFourthCoinPrice.text = price
            }
        }
    }
    
    func downloadCoins()
    {
        let urlString = "https://api.coinmarketcap.com/v1/ticker/?limit=0"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let dataFromUrl = data else { return }
            do {
                self.coins = try JSONDecoder().decode(Array<Coin>.self, from: dataFromUrl)
                
                DispatchQueue.main.async {}
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    func setFormatedDate(date : Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    @objc func openCoinsView(sender: UITapGestureRecognizer) {
        let senderView = sender.accessibilityLabel
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "destinationVC") as! CoinsViewController
        
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        destVC.coins = self.coins
        destVC.senderView = Int(senderView!)!
        
        self.present(destVC, animated: true, completion: nil)
    }
}
