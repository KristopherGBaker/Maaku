//
//  Maaku.h
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
@import UIKit;
#else
@import AppKit;
#endif

//! Project version number for Maaku.
FOUNDATION_EXPORT double MaakuVersionNumber;

//! Project version string for Maaku.
FOUNDATION_EXPORT const unsigned char MaakuVersionString[];
