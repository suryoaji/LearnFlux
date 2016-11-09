package com.idesolusiasia.learnflux.entity;

import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/18/2016.
 */

public class Contact {
    private int id;
    private String username;
    private String type;
    private String email;
    private String first_name;
    private String last_name;
    private String[] interests;
    private String location;
    private String work;
    private Links _links;
    private Embedded _embedded;
    private List<Contact> mutual;

    public String getLast_name() {
        return last_name;
    }

    public void setLast_name(String last_name) {
        this.last_name = last_name;
    }

    public String getFirst_name() {
        return first_name;
    }

    public void setFirst_name(String first_name) {
        this.first_name = first_name;
    }
    public String[] getInterests() {
        return interests;
    }

    public void setInterests(String[] interests) {
        this.interests = interests;
    }

    public Links get_links() {
        return _links;
    }

    public void set_links(Links _links) {
        this._links = _links;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Embedded get_embedded() {
        return _embedded;
    }

    public void set_embedded(Embedded _embedded) {
        this._embedded = _embedded;
    }

    public String getWork() {
        return work;
    }

    public void setWork(String work) {
        this.work = work;
    }

    public List<Contact> getMutual() {
        return mutual;
    }

    public void setMutual(List<Contact> mutual) {
        this.mutual = mutual;
    }


    public class Links {
        public Links(){

        }
        private Self self;
        private profilePicture profile_picture;
        private Links.Frnd friends;


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
    private class Embedded {
        private List<Contact> children;
        public List<Contact> getChildren() {
            return children;
        }

        public void setChildren(List<Contact> children) {
            this.children = children;
        }



    }
}
