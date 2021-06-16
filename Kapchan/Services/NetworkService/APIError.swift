//
//  APIError.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 15.06.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation

enum APIError: Int, Decodable {
    case ErrorForbidden = 403
    case ErrorInternal = 666
    case ErrorNotFound = 667
    case ErrorNoBoard = -2
    case ErrorNoThread = -3
    case ErrorNoPost = -31
    case ErrorNoAccess = -4
    case ErrorBoardClosed = -41
    case ErrorBoardOnlyVIP = -42
    case ErrorCaptchaNotValid = -5
    case ErrorBanned = -6
    case ErrorThreadClosed = -7
    case ErrorPostingToFast = -8
    case ErrorFieldTooBig = -9
    case ErrorFileSimilar = -10
    case ErrorFileNotSupported = -11
    case ErrorFileTooBig = -12
    case ErrorFilesTooMuch = -13
    case ErrorTripBanned = -14
    case ErrorWordBanned = -15
    case ErrorSpamList = -16
    case ErrorEmptyOp = -19
    case ErrorEmptyPost = -20
    case ErrorPasscodeNotExist = -21
    case ErrorLimitReached = -22
    case ErrorFieldTooSmall = -23
    case ErrorReportTooManyPostsm = -50
    case ErrorReportEmpty = -51
    case ErrorReportExist = -52
    case ErrorAppNotExist = -300
    case ErrorAppIDWrong = -301
    case ErrorAppIDExpired = -302
    case ErrorAppIDSignature = -303
    case ErrorAppIDUsed = -304
    case ErrorWrongStickerID = -24
    case ErrorStickerNotFound = -25
}
