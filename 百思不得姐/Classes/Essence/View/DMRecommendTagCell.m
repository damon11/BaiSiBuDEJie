//
//  DMRecommendTagCell.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/25.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMRecommendTagCell.h"
#import "DMRecommendTag.h"
#import "UIImageView+WebCache.h"
@interface DMRecommendTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;

@end
@implementation DMRecommendTagCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setRecommendTag:(DMRecommendTag *)recommendTag
{
    _recommendTag = recommendTag;
    
    
    [self.imageListImageView setHeader:recommendTag.image_list];
   
    self.themeNameLabel.text = recommendTag.theme_name;
    NSString *subNumber = nil;
    if(recommendTag.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd人订阅",recommendTag.sub_number];
    }else{
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅",recommendTag.sub_number / 10000.0];
    }
    self.subNumberLabel.text = subNumber;
    
}

-(void)setFrame:(CGRect)frame
{
//    frame.origin.x = 10;
//    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

@end
