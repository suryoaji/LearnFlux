package com.idesolusiasia.learnflux.entity;

/**
 * Created by Kuroko on 12/1/2016.
 */

public class CommentProfile {
    private static CommentProfile c;
    private String comment;
    
    private CommentProfile(){
        comment ="";
    }
    public static synchronized CommentProfile getComments(){
        if(c==null){
            c = new CommentProfile();
        }
        return c;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }
}
