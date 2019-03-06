//
//  StartScreenViewController.swift
//  QRObjectApp
//
//  Created by Jonas Lundvall on 2019-02-27.
//  Copyright © 2019 Jonas Lundvall. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonPressed(_ sender: Any) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
            //self.logo.rotate360Degrees(duration: 1)
            self.logo.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.logo.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.logo.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.logo.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.performSegue(withIdentifier: "segueToQRScan", sender: nil)
        }) { (success: Bool) in
            
        }
        
    }
    
    var isFirstRun = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.button.alpha = 0.0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFirstRun {
            let oldLogoCenter = logo.center
            let newLogoCenter = CGPoint(x: oldLogoCenter.x , y: oldLogoCenter.y - 130)
            
            let oldLabelCenter = label.center
            let newLabelCenter = CGPoint(x: oldLabelCenter.x, y: oldLabelCenter.y - 130)
            
            UIView.animate(withDuration: 1, delay: 1, options: .curveLinear, animations: {
                self.logo.center = newLogoCenter
                self.label.center = newLabelCenter
            }) { (success: Bool) in
                
            }
            
            UIView.animate(withDuration: 1.5, delay: 1, options: .curveLinear, animations: {
                self.button.alpha = 1.0
            }) { (success: Bool) in
                
            }
            
            isFirstRun = false
        }
    }

}
