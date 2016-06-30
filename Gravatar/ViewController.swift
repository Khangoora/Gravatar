//
//  ViewController.swift
//  Gravatar
//
//  Created by Jaskirat Khangoora on 6/30/16.
//  Copyright © 2016 Jaskirat Khangoora. All rights reserved.
//

import UIKit
import MBProgressHUD
import AlamofireImage

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    var imageReturned : UIImage?
    var previousTextFieldString: String = ""
    let imageCache = AutoPurgingImageCache()
    var avatarCachedImage : UIImage?


    var gravatarAPI = GravatarAPI()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!Reachability.isConnectedToNetwork())
        {
            setAlert("Alert", message: "Your internet is not working")
        }


    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        startLoading()
        
        if(textField.text != "" ){
            if ((textField.text != previousTextFieldString) && (imageView.image == nil) ) {
                gravatarAPI.getImageFromGravatar(textField.text!)
                previousTextFieldString = textField.text!
                setImageView()
                
            }
            else{
                //no need to make additional network request
                setAlert("Alert", message: "You are making the same search again.")
                stopLoading()
                return
            }
        }
        else {
        stopLoading()
        setAlert("Alert", message: "TextField is Empty")
        return
        }
        setImageView()
        stopLoading()

    }

    func setCachedData() {
        
     
    }
    
    func setAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    func setImageView()
    {

        imageView.image = gravatarAPI.imageFromGravatar
        stopLoading()
    }

    
    func startLoading(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        
    }
    
    func stopLoading(){
        
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
    }



}

