package com.idesolusiasia.learnflux;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;

import junit.framework.Test;

public class HomeActivity extends BaseActivity {

	private StaggeredGridLayoutManager gaggeredGridLayoutManager;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_home);
		super.onCreateDrawer(savedInstanceState);

		ImageView ivInterest  = (ImageView)findViewById(R.id.ivInterest);
		ivInterest.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent a = new Intent(HomeActivity.this, InterestGroup.class);
				startActivity(a);
			}
		});
		ImageView ivChat= (ImageView) findViewById(R.id.ivChat);
		ivChat.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent i = new Intent(HomeActivity.this,ChatsActivity.class);
				i.putExtra("chatroom", "org");
				startActivity(i);
			}
		});
		ImageView ivGallery = (ImageView)findViewById(R.id.ivGallery);

	}


	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.home, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();

		//noinspection SimplifiableIfStatement
		if (id == R.id.action_settings) {
			return true;
		}

		return super.onOptionsItemSelected(item);
	}
}
