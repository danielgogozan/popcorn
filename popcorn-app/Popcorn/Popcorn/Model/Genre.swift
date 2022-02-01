//
//  Genre.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 19.11.2021.
//

import Foundation
import UIKit

struct Genre: Codable, Equatable {
    let id: Int
    let name: String
    
    var posterPath: String {
        genrePosters[self.name] ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    var poster: UIImage?
}

struct Genres: Codable {
    var genres: [Genre]
}

let genrePosters = ["Action": "https://www.small-screen.co.uk/wp-content/uploads/2019/05/john-wick-3-1050x450.jpg",
                    "Adventure": "https://unitingartists.org/wp-content/uploads/2020/06/Adventure-Genre.jpg",
                    "Animation": "https://static2.srcdn.com/wordpress/wp-content/uploads/2020/07/dreamworks-animated-movies-2000s-featured.jpg?q=50&fit=crop&w=960&h=500&dpr=1.5",
                    "Comedy": "https://cdn.mos.cms.futurecdn.net/6He2d8gxpPbs3arPQCTY3m-1024-80.jpg",
                    "Crime": "https://img.buzzfeed.com/buzzfeed-static/static/2017-04/18/6/asset/buzzfeed-prod-fastlane-01/sub-buzz-31866-1492512155-3.jpg?downsize=700%3A%2A&output-quality=auto&output-format=auto",
                    "Documentary": "https://www.kids-world-travel-guide.com/images/xsouthafricanlion_andrewpauldeer_ssk-2.jpg.pagespeed.ic.M_VzZvrRaA.jpg",
                    "Drama": "https://thecinemaholic.com/wp-content/uploads/2013/12/her-joaquin-phoenix-03-600-370.jpg",
                    "Family": "https://cdn.mos.cms.futurecdn.net/Bi26TV92dGx83eTvizH3sf-1024-80.jpg",
                    "Fantasy": "https://media.timeout.com/images/49482/1372/772/image.jpg",
                    "History": "https://img.theculturetrip.com/1440x807/smart/wp-content/uploads/2016/03/435823-ranveer-bajirao-new.jpg",
                    "Horror": "https://www.slashfilm.com/img/gallery/the-15-best-japanese-horror-movies-of-all-time/intro-1628539252.webp",
                    "Music": "https://i.guim.co.uk/img/media/9396731ef15df2e8ac442e1b0a47960fc763ebdb/0_689_1983_1189/master/1983.jpg?width=620&quality=45&auto=format&fit=max&dpr=2&s=73522b22c2127f009ec7acb1659eeeff",
                    "Mystery": "https://media.glamour.com/photos/5ef2657e2cc0e95781b03d03/master/w_2580%2Cc_limit/MCDKNOU_LG002.jpg",
                    "Romance": "https://www.lifewire.com/thmb/7yD7CobTsM_zEwzjN8xr7N76kYM=/650x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/002_the-best-romantic-movies-on-netflix-5082536-3fa429584bd749bc832ea017c10ee511.jpg",
                    "Science Fiction": "https://www.looper.com/img/gallery/the-best-sci-fi-movies-of-2021/intro-1623093620.webp",
                    "TV Movie": "https://www.whats-on-netflix.com/wp-content/webp-express/webp-images/uploads/2021/08/best-new-tv-series-on-netflix-this-week-australia-27th-2021-1280x720-1.jpg.webp",
                    "Thriller": "https://media.timeout.com/images/105168146/1372/772/image.jpg",
                    "War": "https://cdn.onebauer.media/one/media/5ed8/fb3f/e87a/c881/dd21/825c/saving-private-ryan-main.jpg?format=jpg&quality=80&width=1800&ratio=16-9&resize=aspectfill",
                    "Western": "https://cdn.theatlantic.com/thumbor/lU-_OLx6v1CXiECwi9AuRyr0nJo=/0x42:1673x983/976x549/media/img/mt/2016/10/the_searchers_original1/original.jpg"]
