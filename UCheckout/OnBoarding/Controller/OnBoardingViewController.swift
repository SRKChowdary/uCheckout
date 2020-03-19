//
//  OnBoardingViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 08/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class OnBoardingViewController: WhiteStatusBaseViewController {
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var onBoardingImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    
    
    var onBoardingViewModel = OnBoardingViewModel()
    var onBoardingModelArray = [OnBoardingModel]()
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        getOnBoardingData()
        setSwiipeGesture()

        // Do any additional setup after loading the view.
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        index = 0
        populateData()
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setSwiipeGesture(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view!.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view!.addGestureRecognizer(swipeRight)

    }
    
  @objc func handleGesture(gesture: UISwipeGestureRecognizer)  {
    switch gesture.direction {
    case UISwipeGestureRecognizer.Direction.right:
        if index == 0 {
            return
        }
        else {
            index = index - 1
            populateData()
        }
        //PreSignInViewController
    case UISwipeGestureRecognizer.Direction.left:
        if index == 2
        {
            if let scanVC = UIStoryboard.authentification.instantiateViewController(withIdentifier: "LoginSDKViewController") as? LoginSDKViewController {
                self.navigationController?.pushViewController(scanVC, animated: true)
            }
        }
        else {
            index = index + 1
            populateData()
        }
    default:
        break
    }
    
    }
    
    private func getOnBoardingData(){
        onBoardingModelArray = onBoardingViewModel.getOnBoardingBaseData()
        populateData()
    }
    
    private func populateData() {
        if onBoardingModelArray.count > 0{
            let onBoardingItem = onBoardingModelArray[index]
            self.descriptionLabel.text = onBoardingItem.message
            if let image = UIImage(named: onBoardingItem.imageName) {
                self.onBoardingImageView.image = image
            }
            self.headerLabel.text = onBoardingItem.header
            self.pageControl.currentPage = index
            if index < onBoardingModelArray.count - 1 {
               actionButton.setTitle("Next", for: .normal)
                actionButton.layer.borderWidth = 2.0
                actionButton.layer.borderColor = GlobalColor.kSolidGreyOutColor.cgColor
                actionButton.backgroundColor = UIColor.white
                actionButton.setTitleColor(UIColor.black, for: .normal)
            }
            else {
                actionButton.layer.borderWidth = 0.0
                actionButton.setTitle("Get Started!", for: .normal)
                actionButton.backgroundColor = UIColor.black
                actionButton.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if index == onBoardingModelArray.count - 1 {
            if let scanVC = UIStoryboard.authentification.instantiateViewController(withIdentifier: "PreSignInViewController") as? PreSignInViewController {
                self.navigationController?.pushViewController(scanVC, animated: true)
            }
        }
        else {
            index = index + 1
            populateData()
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
