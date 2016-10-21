package com.idesolusiasia.learnflux.entity;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by Ide Solusi Asia on 7/28/2016.
 */
public class Group {

    /**
     * type : group
     * id : 57981e743a603fff6c39ede7
     * name : Group Test 1
     */

    private String type;
    private String id;
    private String name;
    private String image;
    private String access;
    private String description;
    @SerializedName("message")
    private Thread thread;
    @SerializedName("participants")
    private List<Member> memberGroup;
    private List<Group> child;
    private BasicItem parent;

    public int getAdminID(){
        int x = -1;
        for(int i=0; i<memberGroup.size();i++){
           if(memberGroup.get(i).getRole().getType().equalsIgnoreCase("admin")){
               x = memberGroup.get(i).getUser().getId();
           }
        }
            return x;
    }

    public BasicItem getParent() {
        return parent;
    }

    public void setParent(BasicItem parent) {
        this.parent = parent;
    }

    public List<Group> getChild() {
        return child;
    }

    public void setChild(List<Group> child) {
        this.child = child;
    }

    public Thread getThread() {
        return thread;
    }

    public void setThread(Thread thread) {
        this.thread = thread;
    }

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

    public void setImage(String image){
        this.image = image;
    }

    public String getImage(){
        return image;
    }

    public String getDescription(){
        return description;
    }

    public void setDescription(String description){
        this.description = description;
    }


    public List<Member> getMemberGroup() {
        return memberGroup;
    }

    public void setMemberGroup(List<Member> memberGroup) {
        this.memberGroup = memberGroup;
    }

    public String getAccess() {
        return access;
    }

    public void setAccess(String access) {
        this.access = access;
    }

}
