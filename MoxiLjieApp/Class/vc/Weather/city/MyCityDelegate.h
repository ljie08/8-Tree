//
//  GYZChooseCityDelegate.h
//  GYZChooseCityDemo
//  选择城市相关delegate
//  Created by wito on 15/12/29.
//  Copyright © 2015年 gouyz. All rights reserved.
//

@class MyCity;
@class MyCityTableViewController;

@protocol MyCityDelegate <NSObject>

- (void) cityPickerController:(MyCityTableViewController *)chooseCityController
                didSelectCity:(MyCity *)city;

- (void) cityPickerControllerDidCancel:(MyCityTableViewController *)chooseCityController;

@end

@protocol MyCityGroupCellDelegate <NSObject>

- (void) cityGroupCellDidSelectCity:(MyCity *)city;

@end
