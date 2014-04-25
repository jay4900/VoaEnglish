//
//  CellForArticle.m
//  VoaEnglish
//
//  Created by Wuffy on 4/19/14.
//  Copyright (c) 2014 Lion. All rights reserved.
//

#import "CellForArticle.h"

@implementation CellForArticle

+ (id)cellWithIdentifier:(NSString *)cellIdentifier
{
    CellForArticle *cell = [[CellForArticle alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//    CellForArticle *cell = [[CellForArticle alloc] init];
    [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.textLabel setNumberOfLines:0];
    
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:6]];
//    cell.progressIndicator = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
//    cell.progressIndicator.frame= CGRectMake(0, 0, cell.frame.size.width, 10);
//    cell.progressIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [cell addSubview:cell.progressIndicator];
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
