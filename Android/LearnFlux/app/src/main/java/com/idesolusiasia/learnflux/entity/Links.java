package com.idesolusiasia.learnflux.entity;

/**
 * Created by Ide Solusi Asia on 11/2/2016.
 */

public class Links {
    public Links(){

    }
    private Self self;
    private profilePicture profile_picture;
    private Frnd friends;


    public profilePicture getProfile_picture() {
        return profile_picture;
    }

    public void setProfile_picture(profilePicture profile_picture) {
        this.profile_picture = profile_picture;
    }

    public Frnd getFriend() {
        return friends;
    }

    public void setFriend(Frnd friends) {
        this.friends = friends;
    }

    public Self getSelf() {
        return self;
    }

    public void setSelf(Self self) {
        this.self = self;
    }

public class Self{
    public Self(){

    }
    private String href;
    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href;
    }

}
public class profilePicture{
    public profilePicture(){

    }
    private String href;
    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href;
    }
}
public class Frnd{
    public Frnd(){

    }
    private String href;
    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href;
    }
            }

        }
