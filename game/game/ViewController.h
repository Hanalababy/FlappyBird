//
//  ViewController.h
//  game
//
//  Created by Tang Hana on 2017/3/11.
//  Copyright © 2017年 Tang Hana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    float speed;
    UIImageView *bird;
    int birdImage;
    UIImageView *pipeUp1;
    UIImageView *pipeDown1;
    UIImageView *pipeUp2;
    UIImageView *pipeDown2;
    bool result;
    NSTimer*myTimer;
    UIView* resultView;
    int score;
    UILabel* scoreLabel;
    bool pipe1Score;
    bool pipe2Score;
}


@end

