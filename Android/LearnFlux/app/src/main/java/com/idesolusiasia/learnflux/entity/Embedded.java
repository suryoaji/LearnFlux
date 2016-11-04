package com.idesolusiasia.learnflux.entity;

/**
 * Created by Ide Solusi Asia on 11/2/2016.
 */

public class Embedded {
    public Embedded(){

    }
    private Children children;

    public Children getChildren() {
        return children;
    }

    public void setChildren(Children children) {
        this.children = children;
    }

    public class Children {

        private String type;
        private int id;
        private String first_name;
        private String last_name;
        private String location;
        private String work;
        private Links _links;

        /**
         * self : {"href":"/v1/api/user/2"}
         * profile_picture : {"href":"/v1/image?id=profile/2"}
         */



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
        public Links get_links() {
            return _links;
        }

        public void set_links(Links _links) {
            this._links = _links;
        }
    }
}
