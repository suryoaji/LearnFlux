package com.idesolusiasia.learnflux.entity;

/**
 * Created by Ide Solusi Asia on 7/28/2016.
 */
public class Organizations {

    /**
     * type : group
     * id : 57981e743a603fff6c39ede7
     * name : Group Test 1
     */

    private String type;
    private String id;
    private String name;
    private String thumb;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setThumb(String thumb){
        this.thumb = thumb;
    }
    public String getThumb(){
        return thumb;
    }
}
