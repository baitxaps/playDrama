//
//  PlayTabBarViewController.m
//  PlayDrama
//
//  Created by chenhairong on 15/3/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PlayTabBarViewController.h"

@interface PlayTabBarViewController ()
{
    NSMutableArray          *_allNavigationAry;
}
@end

static PlayTabBarViewController *MainTabbarInstance = nil;
@implementation PlayTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initToolBar];
    [self setupTabbarItems];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

+ (PlayTabBarViewController *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MainTabbarInstance = [[self alloc] init];
    });
    
    return MainTabbarInstance;
}

- (void)dealloc
{
    _allNavigationAry = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Public method
- (void)reSetTabbarInitial
{
    for (UINavigationController *navCtr in _allNavigationAry) {
        [navCtr popToRootViewControllerAnimated:YES];
    }
    
    MainTabbarInstance = nil;
}
#pragma mark - Private method
- (void)initToolBar
{
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    _allNavigationAry = [NSMutableArray arrayWithCapacity:5];
}

- (void)setupTabbarItems
{
    [_allNavigationAry removeAllObjects];
    UIStoryboard *drama_storyboard = [UIStoryboard storyboardWithName:DRAMA_STORYBOARD bundle:[NSBundle mainBundle]];
    UIViewController *dramaVC = drama_storyboard.instantiateInitialViewController;
    UINavigationController *dramaNav = [self tabbarItemWithController:dramaVC
                                                              itemTag:0
                                                            itemTitle:@"玩剧"
                                                        itemImageName:@"tabbar_drama"
                                                itemSelectedImageName:@"tabbar_drama_sel"];
    [_allNavigationAry addObject:dramaNav];
    
    
    UIStoryboard *bill_storyboard = [UIStoryboard storyboardWithName:PBILL_STORYBOARD bundle:[NSBundle mainBundle]];
    UIViewController *billVC = bill_storyboard.instantiateInitialViewController;
    UINavigationController *billNav = [self tabbarItemWithController:billVC
                                                             itemTag:1
                                                           itemTitle:@"玩票"
                                                       itemImageName:@"tabbar_ticket"
                                               itemSelectedImageName:@"tabbar_ticket_sel"];
    
    [_allNavigationAry addObject:billNav];
    
    
    UIStoryboard *beauty_storyboard = [UIStoryboard storyboardWithName:PBEAUTY_STORYBOARD bundle:[NSBundle mainBundle]];
    UIViewController *beautyVC = beauty_storyboard.instantiateInitialViewController;
    UINavigationController *beautyNav = [self tabbarItemWithController:beautyVC
                                                               itemTag:2
                                                             itemTitle:@"玩美"
                                                         itemImageName:@"tabbar_beauty"
                                                 itemSelectedImageName:@"tabbar_beauty_sel"];
    
    [_allNavigationAry addObject:beautyNav];
    
    
    UIStoryboard *toy_storyboard = [UIStoryboard storyboardWithName:PTOY_STORYBOARD bundle:[NSBundle mainBundle]];
    UIViewController *toyVC = toy_storyboard.instantiateInitialViewController;
    UINavigationController *toyNav = [self tabbarItemWithController:toyVC
                                                            itemTag:3
                                                          itemTitle:@"玩具"
                                                      itemImageName:@"tabbar_toy"
                                              itemSelectedImageName:@"tabbar_toy_sel"];
    
    [_allNavigationAry addObject:toyNav];

    
    UIStoryboard *me_storyboard = [UIStoryboard storyboardWithName:PME_STORYBOARD bundle:[NSBundle mainBundle]];
    UIViewController *meVC = me_storyboard.instantiateInitialViewController;
    UINavigationController *meNav = [self tabbarItemWithController:meVC
                                                           itemTag:4
                                                         itemTitle:@"玩我"
                                                     itemImageName:@"tabbar_me"
                                             itemSelectedImageName:@"tabbar_me_sel"];

    
    [_allNavigationAry addObject:meNav];
    
//    if (IS_IOS7) {
//        carNav.interactivePopGestureRecognizer.delegate = (id)self;
//        driveNav_.interactivePopGestureRecognizer.delegate = (id)self;
//        messageNav.interactivePopGestureRecognizer.delegate = (id)self;
//        findNav.interactivePopGestureRecognizer.delegate = (id)self;
//        mineNav.interactivePopGestureRecognizer.delegate = (id)self;
//    }

    self.viewControllers = _allNavigationAry;
    
    // 更加分隔线
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 0.5)];
    [lineV setBackgroundColor:RGBAColor(187, 185, 192, 1)];
    [self.tabBar addSubview:lineV];
    
    self.tabBar.selectionIndicatorImage=[UIImage imageNamed:@"tabbar_dramaBg"];
}

- (UINavigationController *)tabbarItemWithController:(UIViewController *)controller
                                             itemTag:(NSInteger)tag
                                           itemTitle:(NSString *)title
                                       itemImageName:(NSString *)imageName
                               itemSelectedImageName:(NSString *)selImageName

{
    controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                          image:[UIImage imageNamed:imageName]
                                                            tag:tag];
    
    if (IS_IOS7) {
        controller.tabBarItem.selectedImage = [[UIImage imageNamed:selImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        [controller.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:selImageName]
                            withFinishedUnselectedImage:[UIImage imageNamed:imageName]];
    }
    
    [self unSelectedTapTabBarItems:controller.tabBarItem];
    [self selectedTapTabBarItems:controller.tabBarItem];
    
    return [[UINavigationController alloc] initWithRootViewController:controller];
}

-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    UIColor *unselectedColor  = [UIColor whiteColor];
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        Drama_Content_Font, NSFontAttributeName,
                                        unselectedColor, NSForegroundColorAttributeName, nil]
                              forState:UIControlStateNormal];
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    //UIColor *selectedColor  = [UIColor hexStringToColor:@"d955za"];
    UIColor *selectedColor  = [UIColor blackColor];
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        Drama_Content_Font, NSFontAttributeName,
                                        selectedColor, NSForegroundColorAttributeName, nil]
                              forState:UIControlStateSelected];
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    PDebugLog(@"%s, tag:%ld", __FUNCTION__, (long)item.tag);
#if 0
    if (item.tag != 0) {
        BOOL dirveExist = [allNavigationAry_ containsObject:driveNav_];
        if (dirveExist) {
            [self checkLongin:YES withIndex:item.tag];
        }else{
            [self checkLongin:YES withIndex:item.tag - 1];
        }
    }
#endif
    NSString *images = nil;
    switch (item.tag) {
        case 0:
          images    = @"tabbar_dramaBg";
            break;
        case 1:
            images  = @"tabbar_ticketBg";
            break;
        case 2:
            images  = @"tabbar_beautyBg";
            break;
        case 3:
            images  = @"tabbar_joyBg";
            break;
            
        case 4:
            images  = @"tabbar_meBg";
            [self checkLongin:YES withIndex:item.tag];
            break;
            
        default:
            images  = @"tabbar_meBg";
            
            break;
    }
    
    tabBar.selectionIndicatorImage= [UIImage imageNamed:images];
    //self.tabBar.backgroundColor = [UIColor whiteColor];
}

#pragma mark - change main tabbar
- (void) checkLongin:(BOOL)needToLogin withIndex:(NSInteger)index
{
    [PVerifyFunc showLogin:self];
}

#pragma mark -- skipLoginDelegate
- (void)skipLoginViewCtr
{
    [self setSelectedIndex:0];
}


#pragma mark- 横屏处理
- (BOOL)shouldAutorotate{
    return YES;
}

//返回最上层的子Controller的supportedInterfaceOrientations
- (NSUInteger)supportedInterfaceOrientations{
    //    return UIInterfaceOrientationMaskPortrait;
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (void) limitPortraitScreen {
    //强制竖屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

//强制转为竖屏
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self limitPortraitScreen];
}



@end
