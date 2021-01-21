//
//  ImgurAPI.swift
//  glosss
//
//  Created by Mauricio Lorenzetti on 20/01/21.
//

import Foundation

class ImgurAPI {
    static let authorization = "Client-ID 2b025e4ea62397f"
    static private let endpoint = "https://api.imgur.com/3/"

    enum resourceURL {

        enum Section: String {
            case hot = "hot"
            case top = "top"
            case user = "user"

            var key: String {
                return "section"
            }
        }

        enum Sort: String {
            case viral = "viral"
            case top = "top"
            case time = "time"
            case rising = "rising"

            var key: String {
                return "sort"
            }
        }

        enum Window: String {
            case day = "day"
            case week = "week"
            case month = "month"
            case year = "year"
            case all = "all"

            var key: String {
                return "window"
            }
        }

        case gallery(section: Section, sort: Sort, window: Window, showViral: Bool, mature: Bool, albumPreviews: Bool)

        private var stringValue: String {
            var value = endpoint

            switch self {
            case .gallery(let section, let sort, let window, let showViral, let mature, let albumPreviews):
                value = value.appending("gallery")
                value = value.appending("/\(section.rawValue)")
                value = value.appending("/\(sort.rawValue)")
                value = value.appending("/\(window.rawValue)")

                value = value.appending("?") //end of the URL composing

                value = value.appending("&showViral=\(showViral)")
                value = value.appending("&mature=\(mature)")
                value = value.appending("&album_previews=\(albumPreviews)")
            }

            return value
        }

        var URLValue: URL {
            guard let url = URL(string: self.stringValue) else {
                fatalError("URLs MUST be valid at \(String(describing: self))")
            }
            return url
        }

        func URLValue(page: Int) -> URL {
            let pagedString = self.stringValue + "&page=\(page)"
            guard let url = URL(string: pagedString) else {
                fatalError("URLs MUST be valid at \(String(describing: self))")
            }
            return url
        }
    }
}

