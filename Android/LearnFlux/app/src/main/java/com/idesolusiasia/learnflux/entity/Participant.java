package com.idesolusiasia.learnflux.entity;

import com.google.gson.annotations.SerializedName;

/**
 * Created by NAIT ADMIN on 28/06/2016.
 */
public class Participant {


	private int id;
	@SerializedName("first_name")
	private String firstName="No Name";
	private String lastName="";
	@SerializedName("profile_picture")
	private String photo="";
	private String type;
	private Links _links;

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getPhoto() {
		return photo;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Links get_links() {
		return _links;
	}

	public void set_links(Links _links) {
		this._links = _links;
	}
	@Override
	public String toString() {
		return super.toString();
	}

	public class Links {
		public Links(){

		}
		private Self self;
		private profilePicture profile_picture;
		private Frnd friends;


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

}
