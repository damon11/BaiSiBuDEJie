//
//  DMSettingViewController.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/3.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMSettingViewController.h"
#import "SDImageCache.h"

static NSInteger const DMHeaderSetLabelTag = 101;

@interface DMSettingViewController ()
@property (nonatomic , retain) NSString *cachePath;
/** 标题名称 */
@property(nonatomic,strong) NSArray *titleArr;
@end
float cacheSize;
@implementation DMSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.tableView.backgroundColor = DXGlobalBg;
    
    [self.tableView registerClass:[UITableViewCell class]forCellReuseIdentifier:@"cell"];
    
}

-(NSArray *)titleArr{
    if(!_titleArr){
        _titleArr = [NSArray arrayWithObjects:@"清除缓存",@"推荐给朋友",@"帮助",@"当前版本:",@"关于我们",@"设备信息",@"隐私政策",@"打分支持不得姐!",nil];
    }
    return _titleArr;
}
//-(void)getSize2{
//    //图片缓存
//    NSUInteger size = [SDImageCache sharedImageCache].getSize;
//    
//    //
//    NSFileManager *manager = [NSFileManager defaultManager];
//    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *cachePath = [caches stringByAppendingPathComponent: @"default/com.hackenist.SDWebImageCache.default"];
//    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:cachePath];
//    
//    //获得文件夹内部的所有内容
//    NSArray *contents = [manager contentsOfDirectoryAtPath:cachePath error:nil];
//    NSArray *subpaths = [manager subpathsAtPath:cachePath];
//}

-(void)getSize{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = [caches stringByAppendingPathComponent: @"default/com.hackenist.SDWebImageCache.default"];
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:cachePath];
    NSInteger totalSize = 0;
    for (NSString *fileName in fileEnumerator) {
        
        NSString *filepath = [cachePath stringByAppendingPathComponent:fileName];
        
        //        BOOL dir = NO;
        //        //判断文件的类型： 文件/文件夹
        //        [manager fileExistsAtPath:filepath isDirectory:&dir];
        //        if(dir) continue;
        NSDictionary *attrs = [manager attributesOfItemAtPath:filepath error:nil];
        if([attrs[NSFileType] isEqualToString:NSFileTypeDirectory]) continue;
        
        //        NSInteger size = [[manager attributesOfItemAtPath:filepath error:nil][NSFileSize] integerValue];
        totalSize += [attrs[NSFileSize] integerValue];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 3;
    }
        return 8;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *ID = @"header1";
    //先从缓存池中找header
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
        UILabel *label = nil;
    
    if(header == nil){//缓存池中没有,自己创建
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:ID];
        
        //创建label
        label = [[UILabel alloc] init];
        label.textColor = DXRGBColor(67, 67, 67);
        label.backgroundColor = DXGlobalBg;
        label.width = DMSCREENWIDTH;
        label.x = DMTopicCellMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        label.tag = DMHeaderSetLabelTag;
        [header addSubview:label];
        
    }else{//缓存池中取出来的
        label = (UILabel*)[header viewWithTag:DMHeaderSetLabelTag];
    }
    //设置label的数据
    if(section == 0){
        label.text = @"功能设置";
        return header;
    }else if(section == 1){
        label.text = @"其他";
    }

    return header;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    view.tintColor = DXGlobalBg;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0 && indexPath.row == 0){
        UITableViewCell *fontCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fontCell"];
        fontCell.textLabel.text = @"字体大小";
        NSArray *fontArr = @[@"小",@"中",@"大"];
        UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:fontArr];
        segment.selectedSegmentIndex = 1;
        segment.frame = CGRectMake(DMSCREENWIDTH - segment.width - 28, (fontCell.height-segment.height)*0.5, 95, 30);
        [fontCell addSubview:segment];
        fontCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return fontCell;
    }else if (indexPath.section == 0 && indexPath.row == 1){
         UITableViewCell *shakeCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shakeCell"];
        shakeCell.textLabel.text = @"摇一摇夜间模式";
        UISwitch *switchView = [[UISwitch alloc] init];
        switchView.on = YES;
        switchView.frame = CGRectMake(DMSCREENWIDTH - switchView.width - 15, (shakeCell.height - switchView.height)*0.5, 48, 30);
        [shakeCell addSubview:switchView];
        shakeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return shakeCell;
    }else if (indexPath.section == 0 && indexPath.row == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = @"通知设置";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
       if(cell == nil){
           cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
       }
       //    CGFloat size = [SDImageCache sharedImageCache].getSize / 1000.0 /1000;
       //    cell.textLabel.text = [NSString stringWithFormat:@"清除缓存(已使用%.2fMB)",size];
       NSArray *cachepaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
       NSString *cachesDir = [cachepaths objectAtIndex:0];
       self.cachePath = [cachepaths objectAtIndex:0];
       cacheSize = [self folderSizeAtPath:cachesDir];
       cell.textLabel.text = [NSString stringWithFormat:@"%@", self.titleArr[indexPath.row]];
       if(indexPath.row == 0){
       cell.textLabel.text = [NSString stringWithFormat:@"%@(已使用%.2fMB)", self.titleArr[indexPath.row],cacheSize];
       }
       
       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
        // 当前应用软件版本  比如：1.0.1
        NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
       if(indexPath.row == 3){
           
           cell.accessoryType = UITableViewCellAccessoryNone;
           cell.textLabel.text = [NSString stringWithFormat:@"%@%@", self.titleArr[indexPath.row],appCurVersion];
       }
       return cell;

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [NSFileManager defaultManager] removeItemAtPath:<#(nonnull NSString *)#> error:<#(NSError * _Nullable __autoreleasing * _Nullable)#>;
    if(indexPath.section == 0){
        if(indexPath.row == 2){
            
        }
    }
    else if(indexPath.section == 1 && indexPath.row == 0){
        [self clearInfo];
    }
    
    
}

-(void)clearInfo{
    
    [self clearCache:self.cachePath];
    [self.tableView reloadData];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"清除缓存" message:@"缓存已清除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        DXLog(@"%@", path);
        // NSString *imageDir = [NSString stringWithFormat:@"%@/Caches/%@", NSHomeDirectory(), dirName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:path error:nil];
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            DXLog(@"%@", fileName);
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    //[[SDImageCache sharedImageCache] cleanDisk];
}

- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


@end
