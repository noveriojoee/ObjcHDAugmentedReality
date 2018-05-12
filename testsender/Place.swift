/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import CoreLocation

public class Place: ARAnnotation {
  @objc public let reference: String
  @objc public let placeName: String
  @objc public let address: String
  @objc public var phoneNumber: String?
  @objc public var website: String?
  
  var infoText: String {
    get {
      var info = "Address: \(address)"
      
      if phoneNumber != nil {
        info += "\nPhone: \(phoneNumber!)"
      }
      
      if website != nil {
        info += "\nweb: \(website!)"
      }
      return info
    }
  }
  
  init(location: CLLocation, reference: String, name: String, address: String) {
    placeName = name
    self.reference = reference
    self.address = address
    
    super.init(identifier: address, title: name, location: location)!
    
    self.location = location
  }
  
  @objc override public var description: String {
    return placeName
  }
}
