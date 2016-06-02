//
//  DMRecommendCategroyCell.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/23.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMRecommendCategroyCell.h"
#import "DMRecommendCategory.h"
@interface DMRecommendCategroyCell()
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;

@end
@implementation DMRecommendCategroyCell

- (void)awakeFromNib {
    self.backgroundColor = DXRGBColor(244,244,244);
    self.selectedIndicator.backgroundColor = DXRGBColor(219, 21, 26);
//    self.textLabel.textColor = DXRGBColor(78, 78, 78);
    
//    self.textLabel.highlightedTextColor = DXRGBColor(219, 21, 26);//cell为不选中状态 此方法不管用

    
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = bg;
}

-(void)setCategory:(DMRecommendCategory *)category
{
    _category = category;
    
    self.textLabel.text = category.name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.selectedIndicator.hidden = !selected;
    self.textLabel.textColor = selected ? self.selectedIndicator.backgroundColor :DXRGBColor(78, 78, 78);
    
}
@end
