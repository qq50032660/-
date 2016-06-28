//
//  ViewController.m
//  test
//
//  Created by fyc on 16/6/27.
//  Copyright © 2016年 FuYaChen. All rights reserved.
//

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#import "ViewController.h"
#import "TableViewCell.h"
#import "Conti.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, retain)UIScrollView *scrollView;

@property (nonatomic, retain)UITableView *table1;
@property (nonatomic, retain)UITableView *table2;

@property (nonatomic, retain)NSArray *arr;

@property (nonatomic, retain)NSMutableArray *namelist;


@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
//    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 2, _scrollView.frame.size.height);
//    _scrollView.pagingEnabled = YES;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.delegate = self;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.view addSubview:_scrollView];
//    
//    Conti *c = [[Conti alloc]init];
//    
//    for (int i = 0; i < 2; i ++) {
//        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(i * SCREEN_SIZE.width, 0, SCREEN_SIZE.width, SCREEN_SIZE.height) style:UITableViewStylePlain];
//        table.delegate = self;
//        table.dataSource = self;
//        table.tag = 100 + i;
//        [_scrollView addSubview:table];
//        if (i == 0) {
//            self.table1 = table;
//        }else{
//            self.table2 = table;
//        }
//    }
//    
//    c.firstDelegate = self;
//    c.secondDelegate = self.table1;
    
    self.arr = @[@"111",@"你号",@"222",@"嘿嘿"];
    
    
    UITextField *te = [[UITextField alloc]initWithFrame:CGRectMake(0, 100, 200, 40)];
    te.delegate = self;
    te.backgroundColor  =[UIColor redColor];
    [self.view addSubview:te];

//    
  
    
}
- (NSMutableArray *)namelist{
    if (!_namelist) {
        _namelist = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _namelist;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL isRepeat = NO;
    if ([string isEqualToString:@"@"]) {//拼接@名字
        NSString *nameStr = self.arr[arc4random_uniform(4)];
        textField.text = [textField.text stringByAppendingString:[NSString stringWithFormat:@"@%@",nameStr]];
        [self.namelist addObject:nameStr];
        return NO;
    }
    if ([string isEqualToString:@""]) {//减
        
        NSMutableArray *zifuList = [[NSMutableArray alloc]initWithCapacity:0];
        NSRange newRange;
        for (int i = 0; i < textField.text.length ; i ++ ) {//讲字符串拆分
            newRange = [textField.text rangeOfComposedCharacterSequenceAtIndex:i];
            NSString *subStr = [textField.text substringWithRange:newRange];
            NSLog(@"%@ %@",subStr,NSStringFromRange(newRange));//字符和 所处的位置
            
            if ([subStr isEqualToString:@"@"]) {//取出所有@所在位置
                [zifuList addObject:@(newRange.location)];
            }
        }
        
        if (![zifuList containsObject:@(range.location)]) {//不要重复的位置 删除@位置正好重复
            [zifuList addObject:@(range.location)];
        }else{
            isRepeat = YES;
        }
        
        zifuList = [zifuList sortedArrayUsingSelector:@selector(compare:)];//从低到高排序
        
        NSInteger deleteln = [zifuList indexOfObject:@(range.location)];//删除的索引
        
        if (deleteln == 0) {
            if (isRepeat) {//aa@｜22
                NSString *name = self.namelist[0];
                if (range.location > 0 + name.length) {//删除的不是名字
                    return YES;
                }else{
                    
                    textField.text = [NSString stringWithFormat:@"%@",[textField.text substringFromIndex:0 + name.length + 1]];
                    
                    [self.namelist removeObjectAtIndex:0];
                    
                    return NO;
                }
            }else{//aaa｜@22
                return YES;
            }
        }

        int indexBefore = 0;
        if (isRepeat) {//删除@
            indexBefore = (int)range.location;
            
        }else{//删除其他
            indexBefore = [[zifuList objectAtIndex:deleteln - 1] intValue];//应该删除的@索引
        }
        
        int indexAfter;
        NSString *partStr;
        if (zifuList.count == deleteln + 1) {//删除的位置后面没有@
            NSString *stt = textField.text;
            partStr = [stt substringFromIndex:indexBefore];
            
        }else{//删除的位置后面有@
            indexAfter = [[zifuList objectAtIndex:deleteln + 1] intValue];
            partStr = [textField.text substringWithRange:NSMakeRange(indexBefore, indexAfter - indexBefore)];
            
        }
        
        NSString *name = isRepeat?self.namelist[deleteln]:self.namelist[deleteln - 1];//如果删除索引 和@索引 一致 则删除当前索引就行
        
        if (range.location > indexBefore + name.length) {//删除的不是名字
            return YES;
        }else{
            
            textField.text = [NSString stringWithFormat:@"%@%@",[textField.text substringToIndex:indexBefore],[textField.text substringFromIndex:indexBefore + name.length + 1]];
            [self.namelist removeObjectAtIndex:deleteln - 1];
            
            return NO;
        }
        
        
        NSLog(@"zifu====%@====%@",zifuList,partStr);
        
    }
    
    return YES;
    
}

#define UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
