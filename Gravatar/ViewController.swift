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
    let imageCache = AutoPurgingImageCache()
    var avatarCachedImage : UIImage?

    let photoCache = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )


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
            if cachedImage(textField.text!) != nil {
                imageView.image = cachedImage(textField.text!)
                stopLoading()
            }
            else {
                    gravatarAPI.getImageFromGravatar(textField.text!)
                    delay(1.0){
                        self.setImageView()
                        self.cacheImage(self.gravatarAPI.imageFromGravatar!, title: self.textField.text!)
                }
            }
        }
        else {
        stopLoading()
        setAlert("Alert", message: "TextField is Empty")
        return
        }

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


    func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
    func cacheImage(image: Image, title: String) {
        photoCache.addImage(image, withIdentifier: title)
    }
    
    func cachedImage(title: String) -> Image? {
        return photoCache.imageWithIdentifier(title)
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

