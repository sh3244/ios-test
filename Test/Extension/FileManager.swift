//
//  FileManager.swift
//  Test
//
//  Created by Sam on 2/7/18.
//  Copyright © 2018 Sam. All rights reserved.
//

import UIKit

fileprivate var cachesDirectory: NSString {
    return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString
}

public let TEST_CAPTURE_DIR = cachesDirectory.appendingPathComponent("test_capture/")
public let TEST_CACHE_DIR = cachesDirectory.appendingPathComponent("test_cache/")

public let TEST_CAPTURE_DIR_URL = URL(fileURLWithPath: TEST_CAPTURE_DIR)
public let TEST_CACHE_DIR_URL = URL(fileURLWithPath: TEST_CACHE_DIR)

public extension FileManager {

    public func createTempDirectories() {
        [TEST_CAPTURE_DIR, TEST_CACHE_DIR].forEach {
            do {
                try FileManager.default.createDirectory(atPath: $0, withIntermediateDirectories: true, attributes: nil)
            } catch let _ {

            }
        }
    }

    public func emptyDirectories() {
        [TEST_CAPTURE_DIR_URL, TEST_CACHE_DIR_URL].forEach {
            do {
                let contents = try FileManager.default.contentsOfDirectory(at: $0, includingPropertiesForKeys:nil, options: .skipsHiddenFiles)
                for content in contents {
                    FileManager.deleteFileIfExists(url: content)
                }
            } catch {
                print("\(#function) error")
            }
        }
    }

    public class func deleteFileIfExists(url: URL?) {
        let manager = FileManager.default
        guard let deleteURL = url else { return }

        guard manager.fileExists(atPath: deleteURL.path) else { return }
        do {
            try manager.removeItem(at: deleteURL)
        } catch {

        }
    }
}
