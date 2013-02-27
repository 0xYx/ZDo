//
//  NoteCell.h
//  ZDo
//
//  Created by john song on 13-2-25.
//  Copyright (c) 2013年 john song. All rights reserved.
//
@class NoteCell;
@protocol NoteCellDelgate <NSObject>

-(void)didSelectedNoteCell : (NoteCell*)cell;
-(void)didEndEditNoteCell : (NoteCell *)cell note : (NSString*)note;
-(void)didEndDeleteAnimate : (NoteCell *)cell;
-(void)didEndCompleteAnimate:(NoteCell *)cell;
@end
#import <UIKit/UIKit.h>

@interface NoteCell : UITableViewCell<UITextFieldDelegate>{
    CGPoint textFieldCenter;
}
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic)CGFloat cellHeight;
@property (nonatomic, unsafe_unretained) id<NoteCellDelgate> delegate;

-(void)beginCompleteAnimation;
-(void)beginDeleteAnimation;
@end
