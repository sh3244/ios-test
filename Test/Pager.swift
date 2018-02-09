//
//  Pager.swift
//  Test
//
//  Created by Sam on 2/7/18.
//  Copyright © 2018 Sam. All rights reserved.
//

import UIKit
import Alamofire
import Arrow
import AVFoundation
import PromiseKit

let movieURL = "https://github.com/mediaelement/mediaelement-files/blob/master/big_buck_bunny.mp4"
let targetURL = "http://techslides.com/demos/sample-videos/small.mp4"

var index = 0

func downloadMovie(videoView: VideoView) {
    DispatchQueue.global(qos: .background).async {

        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let url = TEST_CACHE_DIR_URL.appendingPathComponent("video" + index.description).appendingPathExtension("mp4")
            index += 1
            return (url, [.removePreviousFile, .createIntermediateDirectories])
        }

        Alamofire.download(targetURL, to: destination).response { response in
            if response.destinationURL != nil {
                let asset = AVURLAsset(url: response.destinationURL!)
                videoView.playerItem = AVPlayerItem(asset: asset)
                DispatchQueue.main.async {
                    videoView.play()
                }
            }
        }
    }
}

//func downloadMovie() -> Promise<Void> {
//    Alamofire.download(targetURL, to: destination).response { response in
//        if response.destinationURL != nil {
//            let asset = AVURLAsset(url: response.destinationURL!)
//            videoView.playerItem = AVPlayerItem(asset: asset)
//            DispatchQueue.main.async {
//                videoView.play()
//            }
//        }
//    }
//}

class Pager: NSObject {
    var books = [Book]()

    var loadingSpeed = 5

    func loadBooks() {
        fetchBooks { (books) in
            self.books = books
        }
    }
}

struct Book: Equatable {
    static func ==(lhs: Book, rhs: Book) -> Bool {
        return lhs.title == rhs.title && lhs.key == rhs.key
    }

    var pagination = ""
    var weight = ""
    var title = ""
    var url = ""
    var notes = ""
    var number_of_pages = 0
    var cover = Cover()
    var publish_date = ""
    var key = ""
    var by_statement = ""
}

extension Book: ArrowParsable {
    mutating func deserialize(_ json: JSON) {
        title <-- json["title"]
//        publishers <-- json["publishers"]
//        pagination <-- json["pagination"]
//        identifiers <-- json["identifiers"]
//        table_of_contents <-- json["table_of_contents"]
//        links <-- json["links"]
//        weight <-- json["weight"]
        title <-- json["title"]
        url <-- json["url"]
//        classifications <-- json["classifications"]
//        notes <-- json["notes"]
        number_of_pages <-- json["number_of_pages"]
        cover <-- json["cover"]
//        subjects <-- json["subjects"]
        publish_date <-- json["publish_date"]
        key <-- json["key"]
//        authors <-- json["authors"]
//        by_statement <-- json["by_statement"]
//        publish_places <-- json["publish_places"]
//        ebooks <-- json["ebooks"]
    }
}

struct Cover {
    var small = ""
    var medium = ""
    var large = ""
}

extension Cover: ArrowParsable {
    mutating func deserialize(_ json: JSON) {
        small <-- json["small"]
        medium <-- json["medium"]
        large <-- json["large"]
    }
}

func fetchBooks(completion: @escaping (([Book]) -> Void)) {
    /**
     Request
     get https://openlibrary.org/api/books
     */

    // Add URL parameters
    let urlParams = [
        "bibkeys":"ISBN:9780980200447,ISBN:0451526538,ISBN:0061964360,ISBN:0199535566,ISBN:0143105426,ISBN:1604501480,ISBN:1905921055",
        "jscmd":"data",
        "format":"json",
        ]

    // Fetch Request
    Alamofire.request("https://openlibrary.org/api/books", method: .get, parameters: urlParams)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            var books = [Book]()

            guard let json = JSON(response.value) else {
                completion([])
                return
            }

            let keys = ["ISBN:9780980200447", "ISBN:0451526538", "ISBN:0061964360", "ISBN:0199535566", "ISBN:0143105426", "ISBN:1604501480", "ISBN:1905921055"]

            for key in keys {
                guard let j = json[key] else { continue }
                var b = Book()
                b.deserialize(j)
                books.append(b)
            }

            completion(books)

            if (response.result.error == nil) {
                debugPrint("HTTP Response Body: \(response.data!)")
            }
            else {
                debugPrint("HTTP Request failed: \(response.result.error!)")
            }
    }
}
