package com.idesolusiasia.learnflux;

import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.TextView;

import com.idesolusiasia.learnflux.entity.Organizations;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class OrgProfileActivity extends BaseActivity {
	public String id;
	TextView description;
	public Organizations organizations =null;
	public ArrayList<Organizations> org = new ArrayList<>();
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
		getProfile();
	}
	void getProfile(){
		org = new ArrayList<>();
		Engine.getOrganizationProfile(getApplicationContext(), id, new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					JSONObject data = obj.getJSONObject("data");
					organizations = Converter.convertOrganizations(data);
					description.setText(organizations.getDescription());
				}catch (JSONException e){
					e.printStackTrace();
				}
			}
		});
	}
}
