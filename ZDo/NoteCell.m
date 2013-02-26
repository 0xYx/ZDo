//
//  NoteCell.m
//  ZDo
//
//  Created by john song on 13-2-25.
//  Copyright (c) 2013年 john song. All rights reserved.
//

#import "NoteCell.h"

@implementation NoteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField.delegate = self;
    }
    return self;
}

-(IBAction)frontBtnClicked:(id)sender{
    [self.textField becomeFirstResponder];
}

#pragma mark TextFieldDelegate
-(void) textFieldDidBeginEditing:(UITextField *)textField{

    
    [self.delegate didSelectedNoteCell:self];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.delegate didEndEditNoteCell:self note:textField.text];
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
