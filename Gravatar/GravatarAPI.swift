//
//  GravatarAPI.swift
//  Gravatar
//
//  Created by Jaskirat Khangoora on 6/30/16.
//  Copyright © 2016 Jaskirat Khangoora. All rights reserved.
//



import UIKit
import Alamofire
import AlamofireImage

class GravatarAPI {
    
    
    let GRAVATAR_URL = "https://www.gravatar.com/avatar/"
    var hashedEmail = ""
    var imageFromGravatar : UIImage?
    
    
    //Trim leading and trailing whitespace from an email address
    //Force all characters to lower-case
    //md5 hash the final string
    func emailHash(email : String) -> String {
        return email.md5
    }
    
    
    func getImageFromGravatar(email:String) {
        
        hashedEmail = email.md5
        Alamofire.request(.GET, GRAVATAR_URL+hashedEmail)
            .responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    self.imageFromGravatar = image
                }
              
        }
    }

}
extension String  {
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.dealloc(digestLen)
        
        return String(format: hash as String)
    }
}

