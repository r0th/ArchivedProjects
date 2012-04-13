//
//  RBAudioManager.h
//  TheRapBoard
//
//  Created by Andy Roth on 11/14/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RBRapperAdlib.h"

@interface RBAudioManager : NSObject <AVAudioPlayerDelegate>

+ (RBAudioManager *) sharedManager;

- (void) playAdlib:(RBRapperAdlib *)adlib;

@end
