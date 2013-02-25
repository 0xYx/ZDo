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
@end
#import <UIKit/UIKit.h>

@interface NoteCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic)CGFloat cellHeight;
@property (nonatomic, unsafe_unretained) id<NoteCellDelgate> delegate;
@end
