//
//  PChooseDramaView.m
//  PlayDrama
//
//  Created by RHC on 15/5/29.
//  Copyright (c) 2015年 times. All rights reserved.


#import "PChooseDramaView.h"
@interface PChooseDramaView ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *dramaTableView;
@property (assign,nonatomic) BOOL isRelizeFrame;
@end
@implementation PChooseDramaView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _dramaUrlArray = [@[@"http://7xj7y3.com1.z0.glb.clouddn.com/test.rmvb",
                        @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4",
                        @"http://www.qeebu.com/newe/Public/Attachment/99/52958fdb45565.mp4"]mutableCopy];
    
    _dramaTableView.delegate   = self;
    _dramaTableView.dataSource = self;
    [_dramaTableView reloadData];
}

+(PChooseDramaView *)initNib
{
    PChooseDramaView *view = [[NSBundle mainBundle]loadNibNamed:@"PChooseDramaView" owner:self options:nil][0];
    return view;
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = _dramaUrlArray.count;
    return count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"PDramaTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    cell.textLabel.text = _dramaUrlArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.chooseDramaBlock) {
        NSString *dramaUrl = _dramaUrlArray[indexPath.row];
        self.chooseDramaBlock(dramaUrl);
    }
    [self relizeFrame];
}

- (IBAction)tapAction:(id )sender
{
    if (self.chooseDramaBlock) {
        self.chooseDramaBlock(nil);
    }
    [self relizeFrame];
}

- (void)relizeFrame
{
    _isRelizeFrame       = !_isRelizeFrame;
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         frame.origin.x = _isRelizeFrame ? 0 :3*UIScreenWidth;
                         self.frame     = frame;
                     }
                     completion:nil];
}


@end
