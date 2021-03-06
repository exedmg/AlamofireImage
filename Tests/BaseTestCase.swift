// BaseTestCase.swift
//
// Copyright (c) 2015 Alamofire Software Foundation (http://alamofire.org/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Alamofire
import AlamofireImage
import Foundation
import XCTest

class BaseTestCase : XCTestCase {
    let timeout = 5.0
    var manager: Manager!

    // MARK: - Setup and Teardown

    override func setUp() {
        super.setUp()

        manager = {
            let configuration: NSURLSessionConfiguration = {
                let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()

                let defaultHeaders = Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders
                configuration.HTTPAdditionalHeaders = defaultHeaders

                return configuration
            }()

            return Manager(configuration: configuration)
        }()
    }

    override func tearDown() {
        super.tearDown()

        manager.session.finishTasksAndInvalidate()
        manager = nil
    }

    // MARK: - Resources

    func URLForResource(fileName: String, withExtension: String) -> NSURL {
        let bundle = NSBundle(forClass: BaseTestCase.self)
        return bundle.URLForResource(fileName, withExtension: withExtension)!
    }

    func imageForResource(fileName: String, withExtension ext: String) -> Image {
        let URL = URLForResource(fileName, withExtension: ext)
        let data = NSData(contentsOfURL: URL)!
        #if os(iOS)
            let image = Image.af_threadSafeImageWithData(data, scale: UIScreen.mainScreen().scale)!
        #elseif os(OSX)
            let image = Image(data: data)!
        #endif

        return image
    }
}
