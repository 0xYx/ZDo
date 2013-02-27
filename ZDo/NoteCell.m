//
//  NoteCell.m
//  ZDo
//
//  Created by john song on 13-2-25.
//  Copyright (c) 2013年 john song. All rights reserved.
//

#import "NoteCell.h"
#import <math.h>
@implementation NoteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField.delegate = self;
        textFieldCenter = self.textField.center;
    }
    return self;
}


#pragma mark Animation
-(void)beginCompleteAnimation{
    CGSize textSize= [self.textField.text sizeWithFont:self.textField.font];
    [UIView animateWithDuration:0.5 animations:^{
        [self.textField setCenter:CGPointMake(self.textField.center.x-textSize.width-8, self.textField.center.y)];
    }completion:^(BOOL finished) {
        [self.delegate didEndCompleteAnimate:self];
        [self performSelector:@selector(resetTextFieldCenter) withObject:nil afterDelay:0.3];
    }];
    
}

-(void)beginDeleteAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        [self.textField setCenter:CGPointMake(self.textField.center.x+320, self.textField.center.y)];
    }completion:^(BOOL finished) {
        [self.delegate didEndDeleteAnimate:self];

    }];
}

-(void)resetTextFieldCenter{
    [self.textField setCenter:textFieldCenter];
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
