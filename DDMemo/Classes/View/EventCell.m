//
//  EventCell.m
//  DDMemo
//
//  Created by duodian on 2018/5/21.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "EventCell.h"
@interface EventCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *ringImageView;
@end

@implementation EventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMemo:(Memo *)memo {
    _titleLabel.text = memo.title;
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@",memo.date,memo.time];
    _contentLabel.text = memo.content;
    _ringImageView.hidden = !memo.remind;
}
@end
