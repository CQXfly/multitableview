//
//  QXDropDownView.m
//  Meituan
//
//  Created by 崇庆旭 on 15/7/19.
//  Copyright (c) 2015年 崇庆旭. All rights reserved.
//

#import "QXDropDownView.h"
#import "DropDownMainCell.h"
#import "DropDownSubCell.h"
@interface QXDropDownView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *mainTable;

@property (nonatomic,strong) UITableView *subTable;

/** 左边主表选中的行号 */
@property (nonatomic, assign) NSInteger selectedMainRow;

@end

@implementation QXDropDownView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
      
        
        [self setUpTables];
        
    }
    return self;
}

#pragma mark- get
- (UITableView *)mainTable
{
    if (!_mainTable) {
        _mainTable = [[UITableView alloc] init];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
    }
    return _mainTable;
}

- (UITableView *)subTable
{
    if (!_subTable) {
        _subTable = [[UITableView alloc] init];
        _subTable.dataSource = self;
        _subTable.delegate  =self;
    }
    return _subTable;
}

#pragma mark -set

+ (instancetype)dropdown
{
    return [[QXDropDownView alloc] init];
}

- (void)setUpTables
{
    [self addSubview:self.mainTable];
    self.mainTable.backgroundColor = [UIColor whiteColor];

    [self addSubview:self.subTable];
    self.subTable.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat mainX = 0;
    CGFloat mainY = 0;
    CGFloat mainW = self.frame.size.width / 2;
    CGFloat mainH = self.tableHeight;
    
    
    CGFloat subX = mainW;
    CGFloat subY = 0;
    CGFloat subW = mainW;
    CGFloat subH = mainH;
    
    if (self.headView) {
        
        CGFloat mainY = CGRectGetMaxY(self.headView.frame);
        
        self.mainTable.frame = CGRectMake(mainX, mainY, mainW, mainH);
        
        self.subTable.frame = CGRectMake(subX, mainY, subW, subH);
        
    }
   
    self.mainTable.frame = CGRectMake(mainX, mainY, mainW, mainH);

    self.subTable.frame = CGRectMake(subX, subY, subW, subH);
    
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainTable) {
        
        return [self.dataSource numberOfRowsInMainTable:self];
    } else {
        return [self.dataSource dropdown:self subdataForRowInMainTable:self.selectedMainRow].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == self.mainTable) {
        cell = [DropDownMainCell cellWithTbaleView:tableView];
        
        // 取出模型数据
        cell.textLabel.text = [self.dataSource dropdown:self titleForRowInMainTable:indexPath.row];
        //数据源有没有设置图片
        if ([self.dataSource respondsToSelector:@selector(dropdown:iconForRowInMainTable:)]) {
            cell.imageView.image = [UIImage imageNamed:[self.dataSource dropdown:self iconForRowInMainTable:indexPath.row]];
            
        }
        //数据源有没实现给图片高亮设置
        if ([self.dataSource respondsToSelector:@selector(dropdown:selectedIconForRowInMainTable:)]) {
            
            [self.dataSource dropdown:self selectedIconForRowInMainTable:indexPath.row];
        }
        
        //如果数据源返回值 说明从表有数据源
        NSArray *subdata = [self.dataSource dropdown:self subdataForRowInMainTable:indexPath.row];
        if (subdata.count) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else { // 从表
        cell = [DropDownSubCell cellWithTableView:tableView];
        
        NSArray *subdata = [self.dataSource dropdown:self subdataForRowInMainTable:self.selectedMainRow];
        cell.textLabel.text = subdata[indexPath.row];
    }
    
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTable) {
        // 被点击的数据
        self.selectedMainRow = indexPath.row;
        // 刷新右边的数据
        [self.subTable reloadData];
        
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(dropdown:didSelectRowInMainTable:)]) {
            [self.delegate dropdown:self didSelectRowInMainTable:indexPath.row];
        }
    } else {
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(dropdown:didSelectRowInSubTable:inMainTable:)]) {
            [self.delegate dropdown:self didSelectRowInSubTable:indexPath.row inMainTable:self.selectedMainRow];
        }
    }
}



@end

