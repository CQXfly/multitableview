//
//  QXDropDownView.h
//  Meituan
//
//  Created by 崇庆旭 on 15/7/19.
//  Copyright (c) 2015年 崇庆旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QXDropDownView;

#pragma mark-QXDropDownViewDataSource
@protocol QXDropDownViewDataSource <NSObject>

/**
 *  主表多少行
 */
- (NSInteger)numberOfRowsInMainTable:(QXDropDownView *)dropdown;

/**
 *  主表的标题
 *
 */
- (NSString *)dropdown:(QXDropDownView *)dropdown titleForRowInMainTable:(NSInteger)row;

/**
 *  主表的子数据
 */
- (NSArray *)dropdown:(QXDropDownView *)dropdown subdataForRowInMainTable:(NSInteger)row;

@optional

/**
 *  主表每一行的图标
 */
- (NSString *)dropdown:(QXDropDownView *)dropdown iconForRowInMainTable:(NSInteger)row;

/**
 *  主表每一行的选中图标
 */
- (NSString *)dropdown:(QXDropDownView *)dropdown selectedIconForRowInMainTable:(NSInteger)row;

@end



#pragma mark-QXDropDownViewDelegate
@protocol QXDropDownViewDelegate <NSObject>

@optional
- (void)dropdown:(QXDropDownView *)dropdown didSelectRowInMainTable:(NSInteger)row;
- (void)dropdown:(QXDropDownView *)dropdown didSelectRowInSubTable:(NSInteger)subrow inMainTable:(NSInteger)mainRow;
@end



@interface QXDropDownView : UIView

@property (nonatomic,strong) UIView *headView;

@property (nonatomic,assign) CGFloat tableHeight;

+ (instancetype)dropdown;

@property (nonatomic, weak) id<QXDropDownViewDataSource> dataSource;
@property (nonatomic, weak) id<QXDropDownViewDelegate> delegate;
@end


