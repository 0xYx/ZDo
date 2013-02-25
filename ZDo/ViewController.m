//
//  ViewController.m
//  ZDToDo
//
//  Created by john song on 13-2-23.
//  Copyright (c) 2013年 john song. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Record.h"
#import "ZDLoadingView.h"
@interface ViewController (){
    CGFloat scrollViewOffSet_y;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollViewOffSet_y = 0;
    self.recordLogic = [RecordLogic sharedRecordLogic];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 20, 320, 70)];
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.textField.delegate = self;
    [self.textField setPlaceholder:@"准备..."];
    self.textField.hidden = YES;
    [self.view addSubview:self.textField];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark UITableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.recordLogic recordList] count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    Record *record = [[self.recordLogic recordList] objectAtIndex:indexPath.row];
    cell.textLabel.text = record.record;
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",record.createTime];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Record *record = [[self.recordLogic recordList] objectAtIndex:indexPath.row];
    [self.recordLogic deleteRecord:record];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Record *record = [[self.recordLogic recordList] objectAtIndex:indexPath.row];
    [self.recordLogic completeRecord:record];
    [self.tableView reloadData];
//    ZDLoadingView *view = [[ZDLoadingView alloc]init];
//    [view start];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text != nil&&![textField.text isEqualToString:@""]){
        [self.recordLogic createRecord:textField.text];
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.tableView reloadData];
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }];
    }
    self.textField.hidden= YES;
    [self.textField resignFirstResponder];
    return YES;
}
#pragma mark scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.tableView.contentOffset.y < -30 && scrollView.contentOffset.y<scrollViewOffSet_y) {
        self.textField.text = @"";
        self.textField.hidden = NO;
    }
    scrollViewOffSet_y = scrollView.contentOffset.y;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.tableView.contentOffset.y < -40) {
        //        self.textField.hidden = NO;
        [self.textField becomeFirstResponder];
        self.textField.text = @"";
        [self.tableView setContentInset:UIEdgeInsetsMake(50, 0, 0, 0)];
        self.isShowInputView = NO;
    }else{
        self.textField.hidden=  YES;
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self.isShowInputView) {
        
    }
}



@end
