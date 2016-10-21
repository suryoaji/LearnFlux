package com.idesolusiasia.learnflux.entity;

import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/18/2016.
 */

public class Contact {

    /**
     * id : 79
     * email : totti@ymail.com
     * type : user
     * link : /user/79
     * first_name : Totti
     * last_name : Fransesco
     * profile_picture : profile/79
     */

    private int id;
    private String email;
    private String type;
    private String link;
    private String first_name;
    private String last_name;
    private String profile_picture;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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
}
