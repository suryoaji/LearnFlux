package com.idesolusiasia.learnflux.entity;

import java.util.List;

/**
 * Created by Ide Solusi Asia on 8/10/2016.
 */
public class Member {

    private List<Participant> user;
    private Role role;

    public List<Participant> getUser() {
        return user;
    }

    public void setUser(List<Participant> user) {
        this.user = user;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public static class Role {
        private String type;
        private String name;

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }
    }
}
