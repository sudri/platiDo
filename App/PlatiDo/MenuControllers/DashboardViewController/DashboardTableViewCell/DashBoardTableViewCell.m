//
//  DashBoardTableViewCell.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 27.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "DashBoardTableViewCell.h"
#import "UIColor+Additions.h"
#import "DashboardItem.h"

@interface DashBoardTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *subContent;
@property (weak, nonatomic) IBOutlet UIView *whiteBg;
@property (weak, nonatomic) IBOutlet UIView *blueBlur;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UIImageView *signalImg;
@property (weak, nonatomic) IBOutlet UILabel *imageTitle;
@end

@implementation DashBoardTableViewCell

- (void)awakeFromNib {
    self.whiteBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.whiteBg.layer.borderWidth = 0.5;
    
    self.whiteBg.layer.shadowColor = [UIColor blackColor].CGColor;
    self.whiteBg.layer.shadowOffset = CGSizeMake(0, 2);
    self.whiteBg.layer.shadowOpacity = 0.8;
    self.whiteBg.layer.shadowRadius = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (highlighted) {
        [UIView animateWithDuration:0.5 animations:^{
            [_blueBlur setBackgroundColor:[UIColor whiteColor]];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            [_blueBlur setBackgroundColor:[UIColor  colorWithHex:0x0F2C86]];
        }];
    }
}


- (void)setItem:(DashboardItem *)item{
    _item = item;
    [self resetMe];
    
    [self.categoryImage setImage:[self imageForType:_item.type]];
    [self.imageTitle     setText:[self titleImageForType:_item.type]];
    
    if (_item.type == DashboardItembill || _item.type == DashboardItemMetersReport){
        [self updateLikeTempView];
    } else {
        [self updateLikeListItem];
    }
        
    [self.imageTitle setText:item.count>0?
                             [NSString stringWithFormat:@"%@(%d)", self.imageTitle.text, item.count]:
                             [NSString stringWithFormat:@"%@", self.imageTitle.text]];
    
}


- (void)resetMe{
    for (UILabel *lbl in self.labels){
        lbl.text = @"";
    }
    
    [self.signalImg setHidden:YES];
    [self.btn setHidden:YES];
}


- (void)updateLikeListItem{
    if ([_item.data count]>0 && [_item.data count]<4){
        int counter = 0;
        for (NSString *str in _item.data){
            [self.labels[counter] setText:str];
            counter++;
        }
    } else {
        [self.btn setHidden:NO];
        [self.btn setTitle:[self buttonTitle:_item.type] forState:UIControlStateNormal];
        [self.labels[0] setText:[self textMainLabelForType:_item.type]];
    }
}


- (void)updateLikeTempView{
    [self.btn setHidden:NO];
    UILabel *lbl  = self.labels[0];
    
    if (_item.isHaveAccess){
        [self.signalImg setHidden:YES];
        NSString *str =  [self textMainLabelForType:_item.type];
        lbl.text = str;
        [self.btn setTitle:[self buttonTitle:_item.type] forState:UIControlStateNormal];
    } else {
        [self.btn setTitle:NSLocalizedString(@"Enter", @"Введите") forState:UIControlStateNormal];
        [self.signalImg setHidden:NO];
        lbl.text = NSLocalizedString(@"Enter flat number", @"Введите номер квартиры");
    }
}

- (NSString*)titleImageForType:(DashboardItemType)type{
    
    switch (type) {
        case DashboardItemDiscussions:{
            return @"Текущие идеи и обсуждения";
        }
            break;
        case DashboardItemMetersReport:{
            return @"Счетчики и показания";
        }
            break;
        case DashboardItembill:{
            return @"Счета и оплата";
        }
        break;

        case DashboardItemVotings:{
            return @"Актуальные опросы";
        }
            break;
            
        case DashboardItemRequests:{
            return @"Ваши заявки";
        }
            break;
    }
    return nil;
}


- (UIImage*)imageForType:(DashboardItemType)type{
    switch (type) {
            
        case DashboardItemMetersReport:{
            return [UIImage imageNamed:@"dash_metr"];
        }
            break;
        case DashboardItembill:{
            return [UIImage imageNamed:@"dash_bils"];
        }
            break;
            
        case DashboardItemDiscussions:{
            return [UIImage imageNamed:@"dash_discustions"];
        }
            break;
        case DashboardItemVotings:
            return  [UIImage imageNamed:@"dash_votes"];
            break;
            
        case DashboardItemRequests:{
            return [UIImage imageNamed:@"dash_request"];
        }
            break;
    }
    
    return nil;
}

- (NSString*)textMainLabelForType:(DashboardItemType)type{
    switch (type) {
        case DashboardItemMetersReport:{
           return NSLocalizedString(@"Enter meter readings", @"Введите показания приборов учета");
        }
            break;
        case DashboardItembill:{
            return  NSLocalizedString(@"You put up a new bill", @"Вам выставлен новый счет");
        }
            break;
            
        case DashboardItemDiscussions:{
            return NSLocalizedString(@"No Discussions", @"Нет обсуждений");
        }
            break;
        case DashboardItemVotings:{
            return  NSLocalizedString(@"No Vote", @"Нет опросов");
        }
            break;
            
        case DashboardItemRequests:{
            return NSLocalizedString(@"No requests", @"Заявок нет");
        }
            break;
    }
    return @"";
}

- (NSString*)buttonTitle:(DashboardItemType)type{
    if (type == DashboardItemMetersReport) {
        return NSLocalizedString(@"Enter meters", @"Введите показания");
    } else if (type == DashboardItembill) {
        return NSLocalizedString(@"Pay", @"Оплатить");
    } else {
        return NSLocalizedString(@"Create", @"Создать");
    }
}




@end
