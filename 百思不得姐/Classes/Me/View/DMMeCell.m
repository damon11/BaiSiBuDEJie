//
//  DMMeCell.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/1.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMMeCell.h"

@implementation DMMeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"mainCellBackground"];
        
        self.backgroundView = bgView;
        
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.width = 30;
    self.imageView.height = 30;
    self.imageView.centerY = self.contentView.height /2;
    
}

-(void)setFrame:(CGRect)frame{
//    frame.origin.y -= (35-DMTopicCellMargin);
    [super setFrame:frame];
}
@end
