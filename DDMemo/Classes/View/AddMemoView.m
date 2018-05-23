//
//  AddMemoView.m
//  DDMemo
//
//  Created by duodian on 2018/5/19.
//  Copyright © 2018年 丁远帅. All rights reserved.
//



#import "AddMemoView.h"
#import "NSString+Extension.h"
#import "Memo+CoreDataProperties.h"
#import "AppDelegate.h"
#import <BRPickerView/BRPickerView.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSDate+Extension.h"
#import <AVFoundation/AVFoundation.h>

@interface AddMemoView()
@property (weak, nonatomic) IBOutlet UITextField *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remindHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *remindBottomView;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (nonatomic,assign) BOOL isRemind;
@property (nonnull,strong) AVAudioPlayer *player;
@property (nonatomic,strong) NSString *selectedMusic;
@end

@implementation AddMemoView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setCornerRadius:15];
    _dateLabel.text = [NSString dateStringFromDate:[NSDate date]];
    _timeLabel.text = [NSString timeStringFromDate:[NSDate date]];
    _isRemind = YES;
}

- (IBAction)closeClicked:(id)sender {
    if (_player) {
        [_player stop];
        _player = nil;
    }
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (IBAction)ringClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    _isRemind = !sender.isSelected;
    if (sender.isSelected) {
        _remindHeightConstraint.constant = 40;
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
            _remindBottomView.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        _remindHeightConstraint.constant = 60;
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
            _remindBottomView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}


- (IBAction)dateBtnClicked:(id)sender {
        [BRDatePickerView showDatePickerWithTitle:@"" dateType:UIDatePickerModeDate defaultSelValue:nil minDateStr:[NSString totalDateStringFromDate:[NSDate date]] maxDateStr:nil isAutoSelect:YES themeColor:ThemeColor resultBlock:^(NSString *selectValue) {
            _dateLabel.text = selectValue;
        }];
}

- (IBAction)timeBtnClicked:(id)sender {
    [BRDatePickerView showDatePickerWithTitle:@"" dateType:UIDatePickerModeTime defaultSelValue:nil minDateStr:nil maxDateStr:nil isAutoSelect:YES themeColor:ThemeColor resultBlock:^(NSString *selectValue) {
        _timeLabel.text = selectValue;
    }];
}

- (IBAction)remindBtnClicked:(id)sender {
    NSArray *array = @[@"屋内听雨",@"萨克斯金曲",@"水晶音乐",@"超可爱",@"人间仙境",@"非常有趣",@"滴滴哒哒",@"大喇叭",@"穿透力",@"优美口哨",@"吓死寡人"];
    [BRStringPickerView showStringPickerWithTitle:@"" dataSource:array defaultSelValue:@"屋内听雨" isAutoSelect:YES themeColor:ThemeColor resultBlock:^(id selectValue) {
        if ([_selectedMusic isEqualToString:selectValue]) {//保证点击确定音乐停止
            [_player stop];
            _player = nil;
            _selectedMusic = nil;
        } else {
            NSString *path = [[NSBundle mainBundle] pathForResource:selectValue ofType:@"wav"];
            NSURL *url = [NSURL fileURLWithPath:path];
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            self.player.numberOfLoops = 1;
            [self.player play];
            _selectedMusic = selectValue;
        }
        _remindLabel.text = selectValue;
    } cancelBlock:^{
        if (_player) {
            [_player stop];
            _player = nil;
            _selectedMusic = nil;
        }
    }];
}

- (IBAction)saveClicked:(id)sender {
    if (_eventNameLabel.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"Event name can't be empty"];
        return;
    }
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    Memo *memo = [NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:appDelegate.context];
    memo.memoId = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
    memo.title = _eventNameLabel.text;
    memo.content = _remarkTextView.text;
    memo.music = _remindLabel.text;
    memo.remind = _isRemind;
    memo.time = _timeLabel.text;
    memo.date = _dateLabel.text;
    memo.dateInterval = [NSDate totalDateFromStr:[NSString stringWithFormat:@"%@ %@",_dateLabel.text,_timeLabel.text]].timeIntervalSince1970;
    [appDelegate.context save:nil];
    [SVProgressHUD showSuccessWithStatus:@"Save success"];
    [self addNotiWithMomo:memo];
    if (self.saveBlock) {
        self.saveBlock(memo.date);
        if (_player) {
            [_player stop];
            _player = nil;
        }
    }
}

- (void)addNotiWithMomo:(Memo *)memo {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate totalDateFromStr:[NSString stringWithFormat:@"%@ %@",memo.date,memo.time]];
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.alertBody = memo.content;
    localNotification.alertTitle = memo.title;
    if (memo.remind) {
        localNotification.soundName = [NSString stringWithFormat:@"%@.wav",memo.music];
    }
    localNotification.applicationIconBadgeNumber += localNotification.applicationIconBadgeNumber;
    localNotification.userInfo = @{@"modelId":memo.memoId};
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
