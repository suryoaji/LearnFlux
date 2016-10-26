package com.idesolusiasia.learnflux.entity;

/**
 * Created by Ide Solusi Asia on 10/26/2016.
 */

public class Notification {

    String message;
    String type;
    String ref;
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getRef() {
        return ref;
    }

    public void setRef(String ref) {
        this.ref = ref;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

}
