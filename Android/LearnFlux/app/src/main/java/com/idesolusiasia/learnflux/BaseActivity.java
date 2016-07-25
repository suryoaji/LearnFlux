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
import android.widget.TextView;

import com.idesolusiasia.learnflux.db.DataSource;
import com.idesolusiasia.learnflux.entity.User;


public class BaseActivity extends AppCompatActivity
		implements NavigationView.OnNavigationItemSelectedListener {

	Toolbar toolbar;
	NavigationView navigationView;
	SharedPreferences sharedPref;

	protected void onCreateDrawer(Bundle savedInstanceState) {
		toolbar = (Toolbar) findViewById(R.id.toolbar);
		setSupportActionBar(toolbar);

		FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
		fab.hide();

		DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
		ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
				this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close) {
			@Override
			public void onDrawerOpened(View drawerView) {
				super.onDrawerOpened(drawerView);

				TextView tvName = (TextView) drawerView.findViewById(R.id.tvDrawerName);
				TextView tvEmail = (TextView) drawerView.findViewById(R.id.tvDrawerEmail);

				tvName.setText(User.getUser().getUsername());
				tvEmail.setText(User.getUser().getEmail());
			}
		};
		if (drawer != null) {
			drawer.addDrawerListener(toggle);
		}
		toggle.syncState();

		navigationView = (NavigationView) findViewById(R.id.nav_view);
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
			//i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
			startActivity(i);
		}else if (id == R.id.nav_logout){
			sharedPref = getApplicationContext().getSharedPreferences("com.idesolusiasia.learnflux",MODE_PRIVATE);
			SharedPreferences.Editor editor = sharedPref.edit();
			editor.putString("username","");
			editor.putString("password","");
			editor.commit();
			User.getUser().setUsername("");
			User.getUser().setPassword("");

			Intent i = new Intent(BaseActivity.this, LoginActivity.class);
			i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
			startActivity(i);

			DataSource ds = new DataSource(getApplicationContext());
			ds.deleteDB();

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
