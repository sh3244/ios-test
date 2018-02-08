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

public let TEST_CAPTURE_DIR = cachesDirectory.appendingPathComponent("test_capture")
public let TEST_CACHE_DIR = cachesDirectory.appendingPathComponent("test_cache")

public let TEST_CAPTURE_DIR_URL = URL(fileURLWithPath: TEST_CAPTURE_DIR)
public let TEST_CACHE_DIR_URL = URL(fileURLWithPath: TEST_CACHE_DIR)

public extension FileManager {
    public var appGroupContainerURL: URL {

        guard let documentDirectoryPath = containerURL(forSecurityApplicationGroupIdentifier: Constants.AppGroupName) else { fatalError() }
        return documentDirectoryPath
    }

    public func createTempDirectories() {
        [TEST_CAPTURE_DIR, TEST_CACHE_DIR].forEach {
            do {
                try FileManager.default.createDirectory(atPath: $0, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                Logger.shared.error("Could not create tmp directory: \(error)")
            }
        }
    }

    public func clearCaptureDirectory() {
        do {
            try clearContentsOfDirectory(atPath: TEST_CAPTURE_DIR)
        } catch let error {
            Logger.shared.error("Could not clear capture directory. Error: \(error.localizedDescription)")
        }
    }

    public func clearCacheDirectory() {
        do {
            try clearContentsOfDirectory(atPath: TEST_CACHE_DIR)
        } catch let error {
            Logger.shared.error("Could not clear capture directory. Error: \(error.localizedDescription)")
        }
    }

    public func clearContentsOfDirectory(atPath: String) throws {
        let contents = try contentsOfDirectory(atPath: atPath)
        try contents.forEach {
            try removeItem(atPath: $0)
        }
    }

    public class func deleteFileIfExists(url: URL?) {
        let manager = FileManager.default
        guard let deleteURL = url else { return }

        guard manager.fileExists(atPath: deleteURL.path) else { return }
        do {
            try manager.removeItem(at: deleteURL)
        } catch {
            Logger.shared.error(VideoRecordingErrors.deleteError)
        }
    }
}
