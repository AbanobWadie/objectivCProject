//
//  AddAndUpdateViewController.h
//  objectivCProject
//
//  Created by Abanob Wadie on 4/5/21.
//  Copyright © 2021 Abanob Wadie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddAndUpdateViewController : UIViewController<UIDocumentPickerDelegate, UINavigationControllerDelegate>

@property NSMutableArray *tasks;
@property int addOrUpdate;
@property int index;

@end

NS_ASSUME_NONNULL_END
