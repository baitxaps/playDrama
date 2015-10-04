//
//  PMeUserHeadView.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/5.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PAvatarView.h"

@interface PAvatarView ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end


@implementation PAvatarView

- (void)dealloc
{
    PDebugLog(@"%s",__FUNCTION__);
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self.headImageView drawBounderWidth:.05 Color:[UIColor clearColor] radius:self.headImageView.frame.size.height/2.0];
    
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPickImageActionSheet:)];
    tapG.numberOfTapsRequired = 1;
    [self.headImageView addGestureRecognizer:tapG];
}

+ (PAvatarView *) initWithNib
{
    PAvatarView *view = nil;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PAvatarView" owner:self options:nil];
    for (id obj in array) {
        if ([obj isKindOfClass:[PAvatarView class]]) {
            view = (PAvatarView *)obj;
            break;
        }
    }
    return view;
}


- (void)avtarImageViewUpdate:(NSString *)url
{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:url]
                        placeholderImage:nil
                                 options:SDWebImageLowPriority | SDWebImageRetryFailed];
    
    [self.imageArray addObject:url];
}


#pragma mark - Actions

- (void)deleteImage:(UITapGestureRecognizer *)tapG
{
    [self.imageArray removeAllObjects];
 
    _headImageView.hidden          = nil;

}

- (void)setWithController_:(UIViewController *)controller_
{
    _withController_ = controller_;
    //self.imageArray = [[NSMutableArray alloc] initWithCapacity:1];
}


- (IBAction)showPickImageActionSheet:(UIGestureRecognizer *)gesture
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"拍照", @"从本地选择",nil];
    
    [sheet showInView:self];
}



#pragma mark - Delegate Method

#pragma mark GOActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 ) {
        [self takePhoto];//相机
    }
    else if(buttonIndex == 1){
        [self openPhotolibrary];//照片库
    }
}

-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate      = self;
        picker.allowsEditing = YES;
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [_withController_ presentViewController:picker animated:YES completion:nil];
        
    }else{
        NSString *title = NSLocalizedString(@"IMBasicInfo_Not_Photo", nil);
        NSString *msg = NSLocalizedString(@"IMBasicInfo_Not_Photo_Mach", nil);
        [[UIApplication sharedApplication].keyWindow makeToast:msg duration:1.0 position:@"bottom" title:title tag:11111];
    }
}

-(void)openPhotolibrary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    [_withController_ presentViewController:picker animated:YES completion:nil];
}



#pragma mark - UIImagePickerCont≥rollerDelegate

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!image) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }

        self.headImageView.image = image;
       //[self.imageArray addObject:image];
        
        if (self.uploadAvatarBlock) {
            self.uploadAvatarBlock(image);
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
