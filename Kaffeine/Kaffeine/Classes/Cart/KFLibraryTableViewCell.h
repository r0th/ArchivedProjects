//
//  KFCartTableViewCell.h
//  Kaffeine
//
//  Created by Andy Roth on 10/19/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFPhoto.h"

@interface KFLibraryTableViewCell : UITableViewCell <UIActionSheetDelegate>

@property (nonatomic, retain) KFPhoto *photo;

@end
