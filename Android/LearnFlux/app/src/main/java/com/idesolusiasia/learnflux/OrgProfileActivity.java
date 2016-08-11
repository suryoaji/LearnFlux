package com.idesolusiasia.learnflux;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class OrgProfileActivity extends BaseActivity {
	public String id;
	TextView description, title;
	ImageView message;
	public Group group =null;
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

		Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
		setSupportActionBar(toolbar);

		id =  getIntent().getStringExtra("id");
		description = (TextView)findViewById(R.id.textView4);
		title = (TextView)findViewById(R.id.textView3);
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
	}
	void getProfile(){
		org = new ArrayList<>();
		Engine.getOrganizationProfile(getApplicationContext(), id, new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					JSONObject data = obj.getJSONObject("data");
					group = Converter.convertOrganizations(data);
					description.setText(group.getDescription());
					title.setText(group.getName());
				}catch (JSONException e){
					e.printStackTrace();
				}
			}
		});
	}
}
