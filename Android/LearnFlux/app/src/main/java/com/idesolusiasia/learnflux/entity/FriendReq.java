package com.idesolusiasia.learnflux.entity;

import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/27/2016.
 */

public class FriendReq {

    /**
     * type : user
     * id : 2
     * first_name : Cak
     * last_name : Lontong
     * location : Indonesia
     * work : Lautan Terdalam Antartika
     * _links : {"self":{"href":"/v1/api/user/2"},"profile_picture":{"href":"/v1/image?id=profile/2"}}
     */

    private String type;
    private int id;
    private String first_name;
    private String last_name;
    private String location;
    private String work;
    private boolean isSelected=false;
    private LinksBean _links;
    private List<FriendReq> pending;
    private List<FriendReq> requested;
    public boolean box;

    public FriendReq(boolean _box){
        box = _box;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public LinksBean get_links() {
        return _links;
    }

    public void set_links(LinksBean _links) {
        this._links = _links;
    }

    public List<FriendReq> getPending() {
        return pending;
    }

    public void setPending(List<FriendReq> pending) {
        this.pending = pending;
    }

    public List<FriendReq> getRequested() {
        return requested;
    }

    public void setRequested(List<FriendReq> requested) {
        this.requested = requested;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }
    public static class LinksBean {
        /**
         * href : /v1/api/user/2
         */

        private SelfBean self;
        /**
         * href : /v1/image?id=profile/2
         */

        private ProfilePictureBean profile_picture;

        public SelfBean getSelf() {
            return self;
        }

        public void setSelf(SelfBean self) {
            this.self = self;
        }

        public ProfilePictureBean getProfile_picture() {
            return profile_picture;
        }

        public void setProfile_picture(ProfilePictureBean profile_picture) {
            this.profile_picture = profile_picture;
        }

        public static class SelfBean {
            private String href;

            public String getHref() {
                return href;
            }

            public void setHref(String href) {
                this.href = href;
            }
        }

        public static class ProfilePictureBean {
            private String href;

            public String getHref() {
                return href;
            }

            public void setHref(String href) {
                this.href = href;
            }
        }
    }
}
