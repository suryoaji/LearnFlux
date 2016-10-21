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
import android.view.MenuItem;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.component.CircularNetworkImageView;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import org.json.JSONException;
import org.json.JSONObject;


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
				final NetworkImageView ivDrawerPic = (NetworkImageView)drawerView.findViewById(R.id.ivDrawerPic);
				ivDrawerPic.setDefaultImageResId(R.drawable.user_profile);
				final ImageLoader imageLoader = VolleySingleton.getInstance(getApplicationContext()).getImageLoader();
				Engine.getMeWithRequest(getApplicationContext(), new RequestTemplate.ServiceCallback() {
					@Override
					public void execute(JSONObject obj) {
						try{
							JSONObject data = obj.getJSONObject("data");
							Contact contact = Converter.convertContact(data);
							String url = "http://lfapp.learnflux.net/v1/image?key=profile/"+contact.getId();
							tvName.setText(contact.getFirst_name()+" " + contact.getLast_name());
							tvEmail.setText(contact.getEmail());
							ivDrawerPic.setImageUrl(url, imageLoader);
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
		}else if (id == R.id.nav_logout){
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
