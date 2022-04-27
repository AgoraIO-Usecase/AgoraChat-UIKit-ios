//
//  EaseInputGiphyViewController.m
//  chat-uikit
//
//  Created by liu001 on 2022/4/27.
//

#import "EaseInputGiphyViewController.h"
@import GiphyUISDK;

@interface EaseInputGiphyViewController () <GiphyDelegate>

@end

@implementation EaseInputGiphyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Giphy configureWithApiKey:@"vEQuLHcYSYZHNyEa4BF1Ja7EKwR4qW5e" verificationMode:false metadata:@{}] ;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
    
    GiphyViewController *giphy = [[GiphyViewController alloc]init ] ;
    giphy.theme = [[GPHTheme alloc] init];
    giphy.theme.type = GPHThemeTypeDark;
    giphy.rating = GPHRatingTypeRatedPG13;
    giphy.delegate = self;
    giphy.showConfirmationScreen = true ;
    [giphy setMediaConfigWithTypes: [ [NSMutableArray alloc] initWithObjects:
                                     @(GPHContentTypeGifs),@(GPHContentTypeStickers), @(GPHContentTypeText),@(GPHContentTypeEmoji), nil] ];
    [[GPHCache shared] clear] ;
    [self presentViewController:giphy animated:true completion:nil] ;
}

- (void) didSelectMediaWithGiphyViewController:(GiphyViewController *)giphyViewController media:(GPHMedia *)media {
     
    /* grab url:
    NSString *url = media.images.fixedWidth.gifUrl ;
    NSString *url = media.images.fixedWidth.webPUrl ;
    */
    
}

- (void) didDismissWithController:(GiphyViewController *)controller {
    
}


@end

