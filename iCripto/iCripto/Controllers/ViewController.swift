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
            let purpleBotoom = UIColor(hex: 0xFF7340F4).cgColor
            viewFirstCoin.setGradient(colorTop: (UIColor(named: "purpleTop")?.cgColor)!, colorBottom: purpleBotoom)
        }
    }
    
    @IBOutlet weak var viewSecondCoin: UIView!{
        didSet {
            let greenTop = UIColor(hex: 0x92FE9D).cgColor
            let greenBottom = UIColor(hex: 0x00C9FF).cgColor
            viewSecondCoin.setGradient(colorTop: greenTop, colorBottom: greenBottom)
        }
    }
    
    @IBOutlet weak var viewThirdCoin: UIView!{
        didSet{
            let pinkTop = UIColor(hex: 0xF15F79).cgColor
            let pinkBottom = UIColor(hex: 0xB24592).cgColor
            viewFourthCoin.setGradient(colorTop: pinkTop, colorBottom: pinkBottom)
        }
    }
    
    @IBOutlet weak var viewFourthCoin: UIView!{
        didSet{
            let orangeTop = UIColor(hex: 0xfe8c00).cgColor
            let orangeBottom = UIColor(hex: 0xf83600).cgColor
            viewThirdCoin.setGradient(colorTop: orangeTop, colorBottom: orangeBottom)
        }
    }
    
    @IBOutlet weak var lblToday: UILabel!{
        didSet{
            lblToday.text = setFormatedDate(date: Date())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initializeUIControls()
        DownloadCoins()
        let tap = UITapGestureRecognizer(target: self, action: #selector(openCoinsView(sender:)))
        viewFirstCoin.addGestureRecognizer(tap)
        /*
         UserDefaults.standard.string(forKey: "firstCoin")
         UserDefaults.standard.string(forKey: "secondCoin")
         UserDefaults.standard.string(forKey: "thirdCoin")
         UserDefaults.standard.string(forKey: "fourthCoin")
         */
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func DownloadCoins()
    {
        //Implementing URLSession
        let urlString = "https://api.coinmarketcap.com/v1/ticker/?limit=0"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let dataFromUrl = data else { return }
            do {
                self.coins = try JSONDecoder().decode(Array<Coin>.self, from: dataFromUrl)
                
                DispatchQueue.main.async {
                    
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
        //End implementing URLSession
    }
    
    func setFormatedDate(date : Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    @objc func openCoinsView(sender: UITapGestureRecognizer) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "destinationVC") as! CoinsViewController
        
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        destVC.coins = self.coins
        
        self.present(destVC, animated: true, completion: nil)
    }
    
    func initializeUIControls(){
    }
}
