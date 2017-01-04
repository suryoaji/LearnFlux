package com.idesolusiasia.learnflux.activity;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class OrgProfileActivity extends BaseActivity {
	public String id, type, name;
	TextView description, title;
	ImageView message,addGroup;
	NetworkImageView imageProfile;
	public ProgressDialog progress;
	public Group group =null;
	ImageLoader imageLoader = VolleySingleton.getInstance(OrgProfileActivity.this).getImageLoader();
	String url = "http://lfapp.learnflux.net/v1/image?key=";
	public ArrayList<Group> org = new ArrayList<>();
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_base);
		super.onCreateDrawer(savedInstanceState);

		FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
		final LayoutInflater layoutInflater = LayoutInflater.from(this);
		View childLayout = layoutInflater.inflate(
				R.layout.activity_org_profile, null);
		parentLayout.addView(childLayout);

		id =  getIntent().getStringExtra("id");
		type = getIntent().getStringExtra("type");
		name = getIntent().getStringExtra("title");

		description = (TextView)findViewById(R.id.textView4);
		addGroup = (ImageView)findViewById(R.id.addGroup);
		addGroup.setVisibility(View.GONE);
		imageProfile = (NetworkImageView)findViewById(R.id.imageProfile);
		title = (TextView)findViewById(R.id.textView3);
		title.setText(name);
		getProfile();
		message = (ImageView)findViewById(R.id.imageView10);
		message.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent toChat = new Intent(OrgProfileActivity.this, ChattingActivity.class);
				toChat.putExtra("idThread", group.getThread().getId());
				startActivity(toChat);
			}
		});
		addGroup.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {

				Engine.joinGroup(getApplicationContext(), id, "join", new RequestTemplate.ServiceCallback() {
					@Override
					public void execute(JSONObject obj) {
						Toast.makeText(getApplicationContext(),"Successfull joining",Toast.LENGTH_SHORT).show();
						Intent i= new Intent(OrgProfileActivity.this, MyProfileActivity.class);
						startActivity(i);
					}
				});
			}
		});
	}
	void getProfile() {
		org = new ArrayList<>();
		Engine.getOrganizationProfile(getApplicationContext(), id, new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try {
					JSONObject data = obj.getJSONObject("data");
					group = Converter.convertOrganizations(data);
					description.setText(group.getDescription());
					title.setText(group.getName());
					if(group.getImage()!=null) {
						imageProfile.setImageUrl(url+group.getImage(), imageLoader);
					}else{
						imageProfile.setDefaultImageResId(R.drawable.company1);
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
		});
	}
}
