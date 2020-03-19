//
//  CartHelpViewController.swift
//  UCheckout
//
//  Created by Nilesh Jha on 04/02/20.
//  Copyright © 2020 Pranav. All rights reserved.
//

import UIKit

class CartHelpViewController: UIViewController {
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var helpImageView: UIImageView!
    
    @IBOutlet weak var helpDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var prevButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Help"
        self.prevButton.isHidden = true
        navigationController?.navigationBar.barTintColor = UIColor.green
        UIApplication.shared.statusBarView?.isHidden = true
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarView?.isHidden = false
        
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        self.prevButton.isHidden = false
        if index == 2 {
            self.dismiss(animated: true, completion: nil)
            
        }
        else {
            index = index + 1
            helpImageView.image = UIImage(named: "cart_help_2")
            self.nextButton.setTitle("Done", for: .normal)
            self.nextButton.setImage(UIImage(), for: .normal)
        }
    }
    
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func prevButtonAction(_ sender: UIButton) {
        if index != 0 {
            self.nextButton.setTitle("Next", for: .normal)
            self.nextButton.setImage(UIImage(named: "rightArrow"), for: .normal)
            index = index - 1
            helpImageView.image = UIImage(named: "cart_help_1")

            if index == 0 {
                self.prevButton.isHidden = true
            }
        }
        else {
            prevButton.isHidden = true
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
