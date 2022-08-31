//  Created by Eyup Selek on 18.03.2022.
//

import Foundation

enum PBError: String, Error {
    case invalidURL            = "The URL created an invalid request. Please try again."
    case invalidResponse       = "Invalid response from the server. Please try again."
    case invalidData           = "The data received from the server was invalid. Please try again."
    case unableToComplete      = "Unable to complete."
    case errorDownloadingImage = "Error while downloading image"
}
