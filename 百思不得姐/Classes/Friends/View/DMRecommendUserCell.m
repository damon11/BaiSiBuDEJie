//
//  DMRecommendUserCell.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/23.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMRecommendUserCell.h"
#import "DMRecommendUser.h"
#import "UIImageView+WebCache.h"
@interface DMRecommendUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end
@implementation DMRecommendUserCell

- (void)awakeFromNib {
   
}

-(void)setUser:(DMRecommendUser *)user
{
    _user = user;
    self.screenNameLabel.text = user.screen_name;
    NSString *fansNumber = nil;
    if(user.fans_count < 10000){
        fansNumber = [NSString stringWithFormat:@"%zd人关注",user.fans_count];
    }
    else{
        fansNumber = [NSString stringWithFormat:@"%.1f万人关注",user.fans_count/10000.0];
    }
    self.fansCountLabel.text = fansNumber;
    [self.headerImageView setHeader:user.header];
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    
    [super setFrame:frame];
}
@end
