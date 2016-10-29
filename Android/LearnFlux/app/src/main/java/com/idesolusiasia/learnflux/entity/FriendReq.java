package com.idesolusiasia.learnflux.entity;

/**
 * Created by Ide Solusi Asia on 10/27/2016.
 */

public class FriendReq {

    /**
     * id : 40
     * username : marvel14
     * email : marvel14@agent.com
     * type : user
     * link : /user/40
     * first_name : Spider
     * last_name : Man
     * profile_picture : profile/40
     * location : Timor Timor
     * work : Lautan Terdalam
     */

    private int id;
    private String username;
    private String email;
    private String type;
    private String link;
    private String first_name;
    private String last_name;
    private String profile_picture;
    private String location;
    private String work;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public String getFirst_name() {
        return first_name;
    }

    public void setFirst_name(String first_name) {
        this.first_name = first_name;
    }

    public String getLast_name() {
        return last_name;
    }

    public void setLast_name(String last_name) {
        this.last_name = last_name;
    }

    public String getProfile_picture() {
        return profile_picture;
    }

    public void setProfile_picture(String profile_picture) {
        this.profile_picture = profile_picture;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getWork() {
        return work;
    }

    public void setWork(String work) {
        this.work = work;
    }
}
