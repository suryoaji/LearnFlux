package com.idesolusiasia.learnflux;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.idesolusiasia.learnflux.component.CircularNetworkImageView;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.idesolusiasia.learnflux.util.VolleySingleton;
import com.koushikdutta.async.future.FutureCallback;
import com.koushikdutta.ion.Ion;
import com.squareup.picasso.Picasso;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


public class BaseActivity extends AppCompatActivity
		implements NavigationView.OnNavigationItemSelectedListener {

	Toolbar toolbar;
	NavigationView navigationView;
	SharedPreferences sharedPref;

	protected void onCreateDrawer(Bundle savedInstanceState) {
		toolbar = (Toolbar) findViewById(R.id.toolbar);
		setSupportActionBar(toolbar);

		DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
		ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
				this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close) {
			@Override
			public void onDrawerOpened(View drawerView) {
				super.onDrawerOpened(drawerView);
				LinearLayout navigation = (LinearLayout)drawerView.findViewById(R.id.linearNavigation) ;
				final TextView tvName = (TextView) drawerView.findViewById(R.id.tvDrawerName);
				final TextView tvEmail = (TextView) drawerView.findViewById(R.id.tvDrawerEmail);
				final ImageView ivDrawerPic = (ImageView)drawerView.findViewById(R.id.ivDrawerPic);
				final String url = "http://lfapp.learnflux.net";
				String getUrl =  url + "/v1"+"/me"+"/details";
				Ion.with(getApplicationContext()).load(getUrl)
						.addHeader("Authorization", "Bearer "+User.getUser().getAccess_token())
						.asJsonObject()
						.setCallback(new FutureCallback<JsonObject>() {
							@Override
							public void onCompleted(Exception e, JsonObject result) {
								if(e!=null){
									Toast.makeText(BaseActivity.this, "Something Wrong", Toast.LENGTH_SHORT).show();
								}
								JsonObject obj = result.getAsJsonObject();
								Gson gson = new Gson();
								Contact contact = gson.fromJson(obj.toString(), Contact.class);
								tvName.setText(contact.getFirst_name()+ " "+ contact.getLast_name());
								tvEmail.setText(contact.getEmail());
								User.getUser().setID(contact.getId());
								User.getUser().setUsername(contact.getFirst_name()+ " "+ contact.getLast_name());
								User.getUser().setName(contact.getUsername());
								User.getUser().setWork(contact.getWork());
								User.getUser().setLocation(contact.getLocation());
								Animation animation = AnimationUtils.loadAnimation(getApplicationContext(),
										R.anim.popup_enter);
								if(contact.get_links().getProfile_picture()!=null) {
									String pic = url+contact.get_links().getProfile_picture().getHref();
									Ion.with(getApplicationContext())
											.load(pic).noCache()
											.addHeader("Authorization", "Bearer " + User.getUser().getAccess_token())
											.withBitmap().animateLoad(animation)
											.intoImageView(ivDrawerPic);
								}else{
									ivDrawerPic.setImageResource(R.drawable.user_profile);
								}
							}
						});
				/*Engine.getMeWithRequest(getApplicationContext(), "details",  new RequestTemplate.ServiceCallback() {
					@Override
					public void execute(JSONObject obj) {
						try{
							Contact contact= Converter.convertContact(obj);
							String url = "http://lfapp.learnflux.net";
							if(contact.get_links().getProfile_picture()!=null) {
								String pic = contact.get_links().getProfile_picture().getHref();
								User.getUser().setProfile_picture(url+pic);
							}
							User.getUser().setID(contact.getId());
							User.getUser().setUsername(contact.getUsername());
							tvName.setText(contact.getFirst_name()+" "+ contact.getLast_name());
							tvEmail.setText(contact.getEmail());
							Animation animation = AnimationUtils.loadAnimation(getApplicationContext(),
									R.anim.popup_enter);
							if(contact.get_links().getProfile_picture()!=null) {
								Ion.with(getApplicationContext())
										.load(url+contact.get_links().getProfile_picture().getHref())
										.addHeader("Authorization", "Bearer " + User.getUser().getAccess_token())
										.withBitmap().animateLoad(animation)
										.intoImageView(ivDrawerPic);
							}else{
								ivDrawerPic.setImageResource(R.drawable.user_profile);
							}
						}catch (JSONException e){
							e.printStackTrace();
						}
					}
				});*/
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
		else if (id == R.id.nav_logout){
			SharedPreferences prefs = getSharedPreferences("com.idesolusiasia.learnflux",0);
			SharedPreferences.Editor editor = prefs.edit();
			editor.putString("email",User.getUser().getName());
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
