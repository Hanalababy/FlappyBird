//
//  ViewController.m
//  game
//
//  Created by Tang Hana on 2017/3/11.
//  Copyright © 2017年 Tang Hana. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self.view subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*background*/
    NSDate *dateNow = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger hour;
    NSInteger minute;
    NSInteger second;
    NSInteger nanosecond;
    [calendar getHour:&hour minute:&minute second:&second nanosecond:&nanosecond fromDate:dateNow];
    if(hour<6||hour>18){
        self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_night.png"]];
    }
    else{
        self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_day.png"]];
    }
    /*pipe*/
    pipeUp1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pipe_up.png"]];
    pipeUp1.center=CGPointMake(self.view.frame.size.width/4,self.view.frame.size.height-arc4random()%50);
    [self.view addSubview:pipeUp1];
    pipeDown1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pipe_down.png"]];
    pipeDown1.center=CGPointMake(self.view.frame.size.width/4,-arc4random()%20);
    [self.view addSubview:pipeDown1];

    pipeUp2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pipe_up.png"]];
    pipeUp2.center=CGPointMake(3*self.view.frame.size.width/4,self.view.frame.size.height-arc4random()%30);
    [self.view addSubview:pipeUp2];
    pipeDown2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pipe_down.png"]];
    pipeDown2.center=CGPointMake(3*self.view.frame.size.width/4,-arc4random()%20);
    [self.view addSubview:pipeDown2];
    /*bird*/
    birdImage=0;
    bird=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bird1_0.png"]];
    bird.center=CGPointMake(self.view.frame.size.width/4,self.view.frame.size.height/2);
    [self.view addSubview:bird];
    /*bird move*/
    speed=0;
    [myTimer invalidate];
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    myTimer=[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(Move)
                                           userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSRunLoopCommonModes];

    /*click action*/
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Click)];
    [self.view addGestureRecognizer:click];
    
    /*restart view*/
    result=true;
    resultView=[[UIView alloc]init];
    resultView.frame=self.view.frame;
    resultView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    UIButton* startBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-20, 100, 40)];
    [startBtn setTitle:@"Restart" forState: UIControlStateNormal];
    [startBtn addTarget:self action:@selector(viewDidLoad) forControlEvents:UIControlEventTouchUpInside];
    [resultView addSubview:startBtn];
    
    /*score*/
    score=0;
    pipe1Score=true;
    pipe2Score=true;
    scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-20,50,40,40)];
    scoreLabel.textColor=[UIColor whiteColor];
    scoreLabel.font=[UIFont systemFontOfSize:30];
    scoreLabel.text=[NSString stringWithFormat:@"%d",score];
    [self.view addSubview:scoreLabel];

}

-(void)Click{
    speed=-5;
}

-(void)Move{
    scoreLabel.text=[NSString stringWithFormat:@"%d",score];
    birdImage=(birdImage+1)%4;
    bird.image=[UIImage imageNamed:[NSString stringWithFormat:@"bird1_%d.png",birdImage]];
    /*game over*/
    if(result&&(CGRectIntersectsRect(bird.frame,pipeUp1.frame)||CGRectIntersectsRect(bird.frame,pipeDown1.frame)||CGRectIntersectsRect(bird.frame,pipeUp2.frame)||CGRectIntersectsRect(bird.frame,pipeDown2.frame)||bird.center.y>self.view.frame.size.height-30)){
        result=false;//fail
        speed=0;
    }
    
    if(!result){
        speed+=1;
        UIImage *changeImage=[UIImage imageWithCGImage:bird.image.CGImage
                                                scale:1.0
                                           orientation:UIImageOrientationRight];
        bird.image=changeImage;
        if(bird.center.y>=self.view.frame.size.height-20){
            [self.view addSubview:resultView];
            return;
        }
        bird.center=CGPointMake(bird.center.x, MIN((int)self.view.frame.size.height-20,(int)bird.center.y+speed));
        return;
    }
    
    speed+=0.1;
    bird.center=CGPointMake(bird.center.x, bird.center.y+speed);
    if(pipe1Score&&pipeUp1.center.x<self.view.frame.size.width/4){
        score+=1;
        pipe1Score=false;
    }
    if(pipe2Score&&pipeUp2.center.x<self.view.frame.size.width/4){
        score+=1;
        pipe2Score=false;
    }
    if(pipeUp1.center.x<-15){
        pipeUp1.center=CGPointMake(self.view.frame.size.width, self.view.frame.size.height-arc4random()%10);
        pipeDown1.center=CGPointMake(self.view.frame.size.width, -arc4random()%30);
        pipe1Score=true;
    }
    else{
        pipeUp1.center=CGPointMake(pipeUp1.center.x-1, pipeUp1.center.y);
        pipeDown1.center=CGPointMake(pipeDown1.center.x-1, pipeDown1.center.y);
    }
    if(pipeUp2.center.x<-15){
        pipeUp2.center=CGPointMake(self.view.frame.size.width, self.view.frame.size.height-arc4random()%30);
        pipeDown2.center=CGPointMake(self.view.frame.size.width, -arc4random()%10);
        pipe2Score=true;
    }
    else{
        pipeUp2.center=CGPointMake(pipeUp2.center.x-1, pipeUp2.center.y);
        pipeDown2.center=CGPointMake(pipeDown2.center.x-1, pipeDown2.center.y);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
