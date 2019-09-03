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
    
    @IBOutlet weak var viewFirstCoin: UIView!
    @IBOutlet weak var viewSecondCoin: UIView!
    @IBOutlet weak var viewThirdCoin: UIView!
    @IBOutlet weak var viewFourthCoin: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DownloadCoins()
        let tap = UITapGestureRecognizer(target: self, action: #selector(setGender(sender:)))
        viewFirstCoin.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let purpleTop = UIColor(hex: 0xFF7340F5).cgColor
        let purpleBotoom = UIColor(hex: 0xFF7340F4).cgColor
        
        let greenTop = UIColor(hex: 0x92FE9D).cgColor
        let greenBottom = UIColor(hex: 0x00C9FF).cgColor
        
        let orangeTop = UIColor(hex: 0xfe8c00).cgColor
        let orangeBottom = UIColor(hex: 0xf83600).cgColor
        
        let pinkTop = UIColor(hex: 0xF15F79).cgColor
        let pinkBottom = UIColor(hex: 0xB24592).cgColor
        
        viewFirstCoin.setGradient(colorTop: purpleTop, colorBottom: purpleBotoom)
        viewSecondCoin.setGradient(colorTop: greenTop, colorBottom: greenBottom)
        viewThirdCoin.setGradient(colorTop: orangeTop, colorBottom: orangeBottom)
        viewFourthCoin.setGradient(colorTop: pinkTop, colorBottom: pinkBottom)
        
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
    
    @objc func setGender(sender: UITapGestureRecognizer) {
        print("tap")
        let view = sender.view as? UIView
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "destinationVC") as! CoinsViewController
        
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        self.present(destVC, animated: true, completion: nil)
    }
}
