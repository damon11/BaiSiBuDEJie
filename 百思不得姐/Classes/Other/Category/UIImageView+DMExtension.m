//
//  UIImageView+DMExtension.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/1.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "UIImageView+DMExtension.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (DMExtension)

-(void)setHeader:(NSString *)url{
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ?[image circleImage]:placeholder;
    }];
}
@end
