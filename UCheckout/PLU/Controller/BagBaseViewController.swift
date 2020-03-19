//
//  BagBaseViewController.swift
//  UCheckout
//
//  Created by i2i Innovation on 02/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit


protocol BagCallBackProtocol {
    func bagAddedWithBagNumber(_ bagItem : Int)
    func ownBagSelected()
}

class BagBaseViewController: UIViewController {
    
    @IBOutlet weak var dropDownButton: RoundButton!
    
    // MARK: - IB Outlet Connection
    
    @IBOutlet weak var qtyLabel: UILabel!
    
    @IBOutlet weak var pickerViewContainer: UIView!
    @IBOutlet weak var qtyView: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var ownBagOutlet: UIButton!
    
    
    @IBOutlet weak var updateButtonOutlet: UIButton!
    
    
    
    // MARK: - Variable Declration
    
    var quant = 0
    var prevQuant : Int?
    var newQuant = 0
    var finalPrevQuant = 0
    var itemLookUpViewModel = ItemLookUpViewModel()
    var bagCallBackProtocol : BagCallBackProtocol?
    var isUpdateButtonTapped : Bool = false
    
    
    // MARK: - View Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        dropDownButton.layer.borderColor = UIColor.gray.cgColor
        dropDownButton.layer.borderWidth = 1.0
        
        
        if let prevQuant = prevQuant {
            pickerView.selectRow(prevQuant, inComponent: 0, animated: true)
            pickerView(pickerView, didSelectRow: prevQuant, inComponent: 0)
            self.qtyLabel.text = "Qty : \(prevQuant)"
            quant = prevQuant
        }
        
        
        // getViewCartData
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Private Methods
    
    private func  getAddPramaDict() -> [String:Any] {
       
        if quant == 0 {
            let parameters = [
                "item_id": "0000000022147",
                "quantity": quant ,
                "upc_type":  "plu",
                "scan_code":  "22147",
                "bag_item" :false,
                ] as [String : Any]
            return parameters
        }
        else {
            let parameters = [
                "item_id": "0000000022147",
                "quantity": quant ,
                "upc_type":  "plu",
                "scan_code":  "22147",
                "bag_item" :true,
                ] as [String : Any]
            return parameters
        }
   
    }
    
    private func addButtonAction(){
        // UcheckoutManager.getScanAndGoDevJSCompleteURl
        // UcheckoutManager.getCompleteURl
        itemLookUpViewModel.addItemToCart(strUrl: UcheckoutManager.getScanAndGoDevJSCompleteURl("/addItemToCart"), params: getAddPramaDict(), parentViewController: self) { (success, response, message) in
            DispatchQueue.main.async {
                if success {
                    if let response = response {
                        if let ack = response.ack {
                            if ack == "0" {
                                self.navigationController?.popViewController(animated: true)
                                self.bagCallBackProtocol?.bagAddedWithBagNumber(self.quant)
                            }
                            else if ack == "1"{
                                if let errors = response.errors {
                                    if errors.count > 0 {
                                        if let message = errors.first?.message {
                                            SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                else {
                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message! , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                }
            }
            
        }
        
    }
    
    // MARK: - IB Action Methods
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pickerViewCloseAction(_ sender: UIButton) {
        self.pickerViewContainer.isHidden = true
    }
    
    @IBAction func removeButtonAction(_ sender: UIButton) {
        quant = pickerView.selectedRow(inComponent: 0)
        self.pickerViewContainer.isHidden = true
        self.qtyLabel.text = "Qty : \(quant)"
        newQuant = quant
    }
    
    @IBAction func qtyBtnAction(_ sender: RoundButton) {
        self.pickerViewContainer.isHidden = false
        if let prevQuant = prevQuant {
            pickerView.selectRow(prevQuant, inComponent: 0, animated: true)
            pickerView(pickerView, didSelectRow: prevQuant, inComponent: 0)
            self.qtyLabel.text = "Qty : \(prevQuant)"
            
        }
    }
    
    //&& prevQuant != 0
    @IBAction func enterButtonAction(_ sender: UIButton)
    {
        
        
        if let prevQuant = prevQuant {
            if prevQuant == quant {
                addButtonAction()
                
            }
                
            else if newQuant != 0
            {
                quant = newQuant
                addButtonAction()
            }
                
            else if newQuant == 0 && quant == 0
            {
                addButtonAction()
            }
                
            else if quant == 0 {
                myOwnBagAction(UIButton())
            } else {
                addButtonAction()
            }
            
        } else {
            if quant == 0 {
                myOwnBagAction(UIButton())
            }
            else {
                addButtonAction()
                
            }
        }
        
    }
    
    
    @IBAction func myOwnBagAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
        if prevQuant != nil {
            
            if ownBagOutlet.isSelected == false
            {
                quant = 0
                addButtonAction()
            }
            
        } else {
            //ownBagOutlet.isEnabled = true
            self.bagCallBackProtocol?.ownBagSelected()
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

extension BagBaseViewController : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 11
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //        if quant == 0
        //        {
        //            self.qtyLabel.text = "Qty : \(pickerView.selectedRow(inComponent: 0))"
        //        }
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
    }
    
}
