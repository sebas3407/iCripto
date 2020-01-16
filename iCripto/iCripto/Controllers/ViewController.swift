//
//  ViewController.swift
//  iCripto
//
//  Created by Sebastian Ortiz Velez on 18/04/2019.
//  Copyright © 2019 Sebastian Ortiz Velez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
    @IBOutlet weak var lblFirstCoinQuantity: UILabel!
    
    
    @IBOutlet weak var lblSecondCoinName: UILabel!
    @IBOutlet weak var lblSecondCoinPrice: UILabel!
    @IBOutlet weak var lblSecondCoinQuantity: UILabel!

    
    @IBOutlet weak var lblThirdCoinName: UILabel!
    @IBOutlet weak var lblThirdCoinPrice: UILabel!
    @IBOutlet weak var lblThirdCoinQuantity: UILabel!


    @IBOutlet weak var lblFourthCoinName: UILabel!
    @IBOutlet weak var lblFourthCoinPrice: UILabel!
    @IBOutlet weak var lblFourthCoinQuantity: UILabel!
    

    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblDifference: UILabel!
    
    @IBOutlet weak var imgTapFirstCoin: UIImageView!
    
    @IBOutlet weak var imgTapSecondCoin: UIImageView!
    
    @IBOutlet weak var imgTapThirdCoin: UIImageView!
    
    @IBOutlet weak var imgTapFourthCoin: UIImageView!
    
    var coins : Array<Coin> = []
    let coinsTittle : [String] = ["firstCoin", "secondCoin", "thirdCoin", "fourthCoin"]
    var coinsQuantity = [2,3,4,5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadCoins()
        addGestures()
        calculateBalance()
        calculateDifference()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for coin in coinsTittle{
            reloadCoins(coinType: coin)
        }
    }
    
    func addGestures(){
        let views : [UIView] = [viewFirstCoin, viewSecondCoin, viewThirdCoin, viewFourthCoin]
        for i in 0..<views.count{
            let tap = UITapGestureRecognizer(target: self, action: #selector(openCoinsView(sender:)))
            tap.accessibilityLabel = String(i + 1)
            views[i].addGestureRecognizer(tap)
        }
    }
    
    func reloadCoins(coinType : String){
        
        if let storedObject: Data = UserDefaults.standard.object(forKey: coinType) as? Data {
            let coin: Coin = try! PropertyListDecoder().decode(Coin.self, from: storedObject)
            
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
                    lblFirstCoinName.isHidden = false
                    lblFirstCoinName.text = "\(coin.symbol) - \(coin.name)"
                    
                    lblFirstCoinQuantity.isHidden = false
                    lblFirstCoinQuantity.text = "\(coinsQuantity[0])"
                    
                    lblFirstCoinPrice.isHidden = false
                    lblFirstCoinPrice.text = price
                
                    imgTapFirstCoin.isHidden = true
                
                case "secondCoin":
                    lblSecondCoinName.isHidden = false
                    lblSecondCoinName.text = "\(coin.symbol) - \(coin.name)"
                    
                    lblSecondCoinQuantity.isHidden = false
                    lblSecondCoinQuantity.text = "\(coinsQuantity[1])"
                    
                    lblSecondCoinPrice.isHidden = false
                    lblSecondCoinPrice.text = price
                
                    imgTapSecondCoin.isHidden = true

                case "thirdCoin":
                    lblThirdCoinName.isHidden = false
                    lblThirdCoinName.text = "\(coin.symbol) - \(coin.name)"
                    
                    lblThirdCoinQuantity.isHidden = false
                    lblThirdCoinQuantity.text = "\(coinsQuantity[2])"
                    
                    lblThirdCoinPrice.isHidden = false
                    lblThirdCoinPrice.text = price
                
                    imgTapThirdCoin.isHidden = true
                
                default:
                    lblFourthCoinName.isHidden = false
                    lblFourthCoinName.text = "\(coin.symbol) - \(coin.name)"
                    
                    lblFourthCoinQuantity.isHidden = false
                    lblFourthCoinQuantity.text = "\(coinsQuantity[3])"
                    
                    lblFourthCoinPrice.isHidden = false
                    lblFourthCoinPrice.text = price
                
                    imgTapFourthCoin.isHidden = true
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

    func calculateBalance(){
        var result : Double = 0
        
        for i in 0..<coinsTittle.count{
            if let storedObject: Data = UserDefaults.standard.object(forKey: coinsTittle[i]) as? Data {
                let coin: Coin = try! PropertyListDecoder().decode(Coin.self, from: storedObject)
                result += Double(coin.priceUsd)! * Double(coinsQuantity[i])
            }
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        let resultString =  formatter.string(from: NSNumber(value: result))
        lblBalance.text = resultString
    }

    func calculateDifference(){
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.percentSymbol = "%"
        
        let oldValue : Double = 3
        let newValue : Double = 6
        var differenceType = ""
        
        if (newValue > oldValue){
            differenceType = "+"
            lblDifference.textColor = UIColor(named: "mainGreen")
        }
        else{
            differenceType = "-"
            lblDifference.textColor = UIColor(named: "mainRed")
        }
        var difference : Double = (oldValue - newValue) / oldValue
        difference *= 100
        difference = abs(difference)
        
        let differenceNumber = NSNumber(value: difference)
        let differenceString = formatter.string(from: differenceNumber)!

        lblDifference.text = "\(differenceType)\(differenceString)%"
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
