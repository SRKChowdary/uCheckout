//
//  ScanHelpBaseViewController.swift
//  UCheckout
//
//  Created by i2i Innovation on 13/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

enum HelpType {
    case PLU
    case Scan
    case Home
}

class ScanHelpBaseViewController: UIViewController {
    
     // MARK: - IB Outlet Connection
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var helpImageView: UIImageView!
    
    @IBOutlet weak var helpDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var prevButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var bottomBarView: UIView!
    
    
    @IBOutlet weak var scanButton: RoundButton!
    
    
    // MARK: - Variable Declaration
    
    var scanHelpBaseViewModel = ScanHelpBaseViewModel()
    var scanhelpModelArray = [ScanHelpModel]()
    var index = 0
    var helpType : HelpType?
    
    // MARK: - View Life Cycle Method


    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        setSwiipeGesture()
        pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .touchUpInside)


       

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
    
    
     // MARK: - Private Methods
    
    @objc  func pageControlTapHandler(sender:UIPageControl) {
        print("currentPage:", sender.currentPage) //currentPage: 1
        if sender.currentPage > index {
            nextButtonAction(UIButton())
        } else if sender.currentPage < index {
            prevButtonAction(UIButton())
        }
    }
    
    private func getData(){
        guard let helpType = self.helpType else {
            fatalError()
        }
        switch helpType {
        case .Home:getHomeHelpScreenData()
        case .PLU:getPLUHelpScreenData()
        case .Scan:getScanHelpScreenData()
        }
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
        prevButton.isHidden = false
        switch gesture.direction {
    
        case UISwipeGestureRecognizer.Direction.right:
            prevButtonAction(UIButton())

        case UISwipeGestureRecognizer.Direction.left:
           nextButtonAction(UIButton())
        default:
            break
        }

    }

    
   
    
    private func getScanHelpScreenData(){
      scanhelpModelArray = scanHelpBaseViewModel.getScanHelpBaseData()
        populateData()
    }
    private func getPLUHelpScreenData(){
        scanhelpModelArray = scanHelpBaseViewModel.getPLUHelpBaseData()
        populateData()
    }
    private func getHomeHelpScreenData(){
        scanButton.isHidden = false
        bottomBarView.isHidden = false
        scanhelpModelArray = scanHelpBaseViewModel.getHomeHelpBaseData()
        populateData()
    }
    
    private func populateData() {
        if scanhelpModelArray.count > 0{
            let scanModelItem = scanhelpModelArray[index]
            self.helpDescriptionLabel.text = scanModelItem.message
            if let image = UIImage(named: scanModelItem.imageName) {
                self.helpImageView.image = image
            }
            self.pageControl.currentPage = index
        }
    }
    
    
    // MARK: - IB Action Methods

    
    @IBAction func nextButtonAction(_ sender: UIButton) {
         self.prevButton.isHidden = false
        if index == self.scanhelpModelArray.count - 1 {
             self.dismiss(animated: true, completion: nil)
           
        }
        else {
            index = index + 1
            if index == self.scanhelpModelArray.count - 1 {
                self.nextButton.setTitle("Done", for: .normal)
                self.nextButton.setImage(UIImage(), for: .normal)

            }
            populateData()
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
            if index == 0 {
                self.prevButton.isHidden = true
            }
            populateData()
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
extension UIBezierPath {
    
    static func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> UIBezierPath {
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(0, tailWidth / 2),
            p(tailLength, tailWidth / 2),
            p(tailLength, headWidth / 2),
            p(length, 0),
            p(tailLength, -headWidth / 2),
            p(tailLength, -tailWidth / 2),
            p(0, -tailWidth / 2)
        ]
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        
        let path = CGMutablePath()
        path.addLines(between: points, transform: transform)
        path.closeSubpath()
        
        return self.init(cgPath: path)
    }
    
}
