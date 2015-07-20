//
//  ViewController.m
//  Meituan
//
//  Created by 崇庆旭 on 15/7/19.
//  Copyright (c) 2015年 崇庆旭. All rights reserved.
//

#import "ViewController.h"
#import "QXDropDownView.h"
#import "MJExtension.h"
#import "category.h"

@interface ViewController () <QXDropDownViewDataSource,QXDropDownViewDelegate>

@property (nonatomic,strong) UIView *funView;

@property (nonatomic,strong) QXDropDownView *dropdownView;

/**
 *  数据源
 */
@property (nonatomic,strong) NSMutableArray *foods;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titles = [NSArray arrayWithObjects:@"美食",@"大保健",@"地区",@"筛选", nil];
    
    [self setUpModelViewWithTitle:titles];
    
}

- (NSMutableArray *)foods
{
    if (!_foods) {
        
//        NSMutableArray *array = [category objectArrayWithFile:@"categories"];
        
        NSMutableArray *array = [NSMutableArray array];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"categories.plist" ofType:nil];
        NSMutableArray *tmpArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        
        for (NSDictionary *dict in tmpArray) {
            
            category *cat = [category catrgoryWithDictionary:dict];
            [array addObject:cat];
            
        }
        
        _foods = array;
    }
    return _foods;
}
-(QXDropDownView *)dropdownView
{
    if (!_dropdownView) {
        _dropdownView = [QXDropDownView dropdown];
        _dropdownView.delegate = self;
        _dropdownView.dataSource = self;
    }
    return _dropdownView;
}

- (void)setUpModelViewWithTitle:(NSArray *) titles
{
    NSInteger count = titles.count;
    
    CGFloat funviewX = 0;
    CGFloat funviewY = 66;
    CGFloat funviewW = self.view.frame.size.width;
    CGFloat funviewH = 44;
    UIView *funView = [[UIView alloc] initWithFrame:CGRectMake(funviewX, funviewY, funviewW, funviewH)];

    self.funView = funView;
    [self.view addSubview:funView];
    
    CGFloat btnW = self.view.frame.size.width / count;
    CGFloat btnH = funView.frame.size.height;
    for (int i = 0; i < count; i ++) {
        UIButton *btn = [[UIButton alloc] init];
        
        NSString *title = titles[i];
        
        [btn  setTitle:title forState:UIControlStateNormal];
        CGFloat btnX = i * btnW;
        CGFloat btnY = 0;
        btn.tag = i;
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [funView addSubview:btn];
                     
    }
    
}

- (void)dropDown
{
    [UIView  animateWithDuration:2 animations:^{
           CGFloat dropDownY = CGRectGetMaxY(self.funView.frame);
    CGFloat dropDownH = self.view.frame.size.height - dropDownY -100;
    self.dropdownView.frame = CGRectMake(0, dropDownY, self.view.frame.size.width, dropDownH);
    self.dropdownView.tableHeight = 400;
        

    [self.view addSubview:self.dropdownView];
        self.dropdownView.transform = CGAffineTransformIdentity;
        self.dropdownView.alpha = 1;
    }];

    
}


- (void)btnClicked:(UIButton *)btn
{
   
    btn.selected = !btn.selected;
    if (btn.selected) {
//        NSLog(@"selected");
        [self dropDown];
    }else{
//     NSLog(@"%@",btn.titleLabel.text);
    [self dropDownViewHidden];
    }
   
    
}


-(void)dropDownViewHidden
{
    
    [UIView animateWithDuration:2 animations:^{
       
//        self.dropdownView.transform = CGAffineTransformMakeTranslation(0, -self.dropdownView.tableHeight);
        
        CGRect frame = self.dropdownView.frame;
        frame.origin.y = frame.origin.y - self.dropdownView.tableHeight;
        self.dropdownView.frame = frame;
        self.dropdownView.alpha = 0.0;
    }];
}

#pragma mark dropdownDatasource
- (NSInteger)numberOfRowsInMainTable:(QXDropDownView *)dropdown
{
    NSLog(@"number %zd",self.foods.count);
    return self.foods.count;
}

- (NSString *)dropdown:(QXDropDownView *)dropdown titleForRowInMainTable:(NSInteger)row
{
    category *category = self.foods[row];
    return category.name;
}

- (NSString *)dropdown:(QXDropDownView *)dropdown iconForRowInMainTable:(NSInteger)row
{
    category *category = self.foods[row];
    return category.icon;
}

- (NSString *)dropdown:(QXDropDownView *)dropdown selectedIconForRowInMainTable:(NSInteger)row
{
    category *category = self.foods[row];
    return category.small_highlighted_icon;
}

- (NSArray *)dropdown:(QXDropDownView *)dropdown subdataForRowInMainTable:(NSInteger)row
{
    category *category = self.foods[row];
    return category.subcategories;
}


@end
