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
    var count = 0
    
    
    func getImage(email: String, completionHandler: (responseObject: UIImage?, error: NSError?) -> ()) {
        makeImageCall(email, completionHandler: completionHandler)
    }
    
    func makeImageCall(email : String, completionHandler: (responseObject: UIImage?,
        error: NSError?) -> ()) {
        Alamofire.request(.GET, GRAVATAR_URL+email.md5)
            .responseImage { response in
                
                if response.result.value != nil {
                    completionHandler(responseObject: response.result.value as UIImage!, error: response.result.error)
                }
                else{
                    if (self.count)<=3{
                        self.makeImageCall(email, completionHandler: completionHandler)
                        self.count += 1
                    }
                }
                completionHandler(responseObject: response.result.value as UIImage!, error: response.result.error)
        }
    }
    
    func emailHash(email : String) -> String {
        return email.md5
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

