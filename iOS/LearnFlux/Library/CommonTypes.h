//
//  CommonTypes.h
//  EMAN
//
//  Created by Martin Darma Kusuma Tjandra on 1/14/16.
//  Copyright © 2016 Danny Raharja. All rights reserved.
//

typedef enum loadStateTypes
{
    STATE_INITIAL,
    STATE_LOADING,
    STATE_LOADED,
    STATE_FAILED,
    STATE_INVALID,
    STATE_EXPIRED
} LoadStateTypes;

typedef enum directionTypes
{
    DIR_ENTER_FROM_LEFT,
    DIR_ENTER_FROM_RIGHT,
    DIR_ENTER_FROM_UP,
    DIR_ENTER_FROM_DOWN,
    
    DIR_EXIT_TO_LEFT,
    DIR_EXIT_TO_RIGHT,
    DIR_EXIT_TO_UP,
    DIR_EXIT_TO_DOWN
    
} DirectionTypes;

typedef enum urlrequestAction
{
    ACTION_POST_USER_LOGIN,
    ACTION_POST_USER_LOGOUT,
    ACTION_POST_USER_REGISTRATION,
    
    ACTION_GET_USER_DETAIL,
    
    ACTION_GET_PROFILEPICTURE,
    ACTION_GET_PROFILEPICTURE_THUMB,
        
} URLRequestAction;

typedef void(^completionBlockBOOL)(BOOL);
typedef void(^completionBlock)(void);

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
