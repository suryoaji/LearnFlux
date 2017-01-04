package com.idesolusiasia.learnflux.activity;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.model.GlideUrl;
import com.bumptech.glide.load.model.LazyHeaders;
import com.idesolusiasia.learnflux.InterestGroup;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONException;
import org.json.JSONObject;


public class BaseActivity extends AppCompatActivity
		implements NavigationView.OnNavigationItemSelectedListener {

	Toolbar toolbar;
	NavigationView navigationView;
	SharedPreferences sharedPref;
	public int mViewId;
	private static final String NAV_ITEM_ID ="navItemId";

	protected void onCreateDrawer(final Bundle savedInstanceState) {
		toolbar = (Toolbar) findViewById(R.id.toolbar);
		setSupportActionBar(toolbar);

		DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
		ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
				this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close) {
			@Override
			public void onDrawerOpened(View drawerView) {
				super.onDrawerOpened(drawerView);
			}
		};

		if (drawer != null) {
			drawer.addDrawerListener(toggle);
		}
		toggle.syncState();

		navigationView = (NavigationView) findViewById(R.id.nav_view);
		navigationView.setItemIconTintList(null);
		if (navigationView != null) {
			navigationView.setNavigationItemSelectedListener(this);
		}
		View headerView = LayoutInflater.from(getApplicationContext()).inflate(R.layout.nav_header_drawer,null);
		navigationView.addHeaderView(headerView);
		navigationView.getHeaderView(0);

		final LinearLayout navigation = (LinearLayout)headerView.findViewById(R.id.linearNavigation) ;
		final TextView tvName = (TextView) headerView.findViewById(R.id.tvDrawerName);
		final TextView tvEmail = (TextView) headerView.findViewById(R.id.tvDrawerEmail);
		final ImageView ivDrawerPic = (ImageView)headerView.findViewById(R.id.ivDrawerPic);

		final String url = "http://lfapp.learnflux.net";
		//get data for myprofile activity
		Engine.getMeWithRequest(getApplicationContext(), "details",  new RequestTemplate.ServiceCallback() {
					@Override
					public void execute(JSONObject obj) {
						try{
							Contact contact= Converter.convertContact(obj);
							if(contact.get_links().getProfile_picture()!=null) {
								String pic = url + contact.get_links().getProfile_picture().getHref();
								GlideUrl glideUrl = new GlideUrl(pic, new LazyHeaders.Builder()
										.addHeader("Authorization", "Bearer " + User.getUser().getAccess_token())
										.build());

								Glide.with(getApplicationContext()).load(glideUrl)
										.diskCacheStrategy(DiskCacheStrategy.NONE)
										.skipMemoryCache(true)
										.into(ivDrawerPic);
							}
							User.getUser().setID(contact.getId());
							User.getUser().setName(contact.getUsername());
							User.getUser().setWork(contact.getWork());
							User.getUser().setLocation(contact.getLocation());
							tvName.setText(contact.getFirst_name()+" "+ contact.getLast_name());
							tvEmail.setText(contact.getEmail());
						}catch (JSONException e){
							e.printStackTrace();
						}
					}
				});
				navigation.setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View view) {
						Intent e = new Intent(BaseActivity.this, MyProfileActivity.class);
						startActivity(e);
					}
				});
				ivDrawerPic.setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View v) {
						Intent pic = new Intent(BaseActivity.this, MyProfileActivity.class);
						startActivity(pic);
					}
				});
	}

	@Override
	public void onBackPressed() {
		DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
		if (drawer != null) {
			if (drawer.isDrawerOpen(GravityCompat.START)) {
				drawer.closeDrawer(GravityCompat.START);
			} else {
				super.onBackPressed();
			}
		}
	}

	@SuppressWarnings("StatementWithEmptyBody")
	@Override
	public boolean onNavigationItemSelected(MenuItem item) {
		item.setChecked(true);
		// Handle navigation view item clicks here.
		int id = item.getItemId();
		if (id == R.id.nav_home){
			Intent i = new Intent(BaseActivity.this, HomeActivity.class);
			i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
			startActivity(i);
		}else if (id == R.id.nav_chats){
			Intent i = new Intent(BaseActivity.this, ChatsActivity.class);
			i.putExtra("chatroom", "chat");
			//i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
			startActivity(i);
		}else if(id == R.id.nav_interest_groups){
			Intent i= new Intent(BaseActivity.this, InterestGroup.class);
			startActivity(i);
		}
		else if(id == R.id.nav_Project){
			Intent project = new Intent(BaseActivity.this, ProjectActivity.class);
			project.putExtra("projectAct", "activity");
			startActivity(project);
		}
		else if (id == R.id.nav_logout) {
			SharedPreferences prefs = getSharedPreferences("com.idesolusiasia.learnflux", 0);
			SharedPreferences.Editor editor = prefs.edit();
			editor.putString("email", User.getUser().getName());
			editor.apply();
			Functions.logout(getApplicationContext());
		}

		/*if (id == R.id.nav_camera) {
			// Handle the camera action
		} else if (id == R.id.nav_gallery) {

		} else if (id == R.id.nav_slideshow) {

		} else if (id == R.id.nav_manage) {

		} else if (id == R.id.nav_share) {

		} else if (id == R.id.nav_send) {

		}*/

		DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
		if (drawer != null) {
			drawer.closeDrawer(GravityCompat.START);
		}
		return true;
	}

}
