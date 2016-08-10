package com.idesolusiasia.learnflux.entity;

/**
 * Created by NAIT ADMIN on 10/08/2016.
 */
public class Member {

	private Participant user;
	private Role role;

	public Participant getUser() {
		return user;
	}

	public void setUser(Participant user) {
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
