package com.idesolusiasia.learnflux;

import android.app.Activity;
import android.content.ContentUris;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.text.TextWatcher;
import android.text.method.ScrollingMovementMethod;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.androidnetworking.AndroidNetworking;
import com.androidnetworking.common.Priority;
import com.androidnetworking.error.ANError;
import com.androidnetworking.interfaces.JSONObjectRequestListener;
import com.androidnetworking.interfaces.UploadProgressListener;
import com.google.gson.JsonObject;
import com.idesolusiasia.learnflux.adapter.ChildrenAdapter;
import com.idesolusiasia.learnflux.adapter.ConnectionFragmentAdapter;
import com.idesolusiasia.learnflux.adapter.ContactAdapter;
import com.idesolusiasia.learnflux.adapter.FriendRequest;
import com.idesolusiasia.learnflux.adapter.MyProfileOrganizationAdapter;
import com.idesolusiasia.learnflux.adapter.MyProfileInterestAdapter;
import com.idesolusiasia.learnflux.adapter.NotificationAdapter;
import com.idesolusiasia.learnflux.adapter.SearchAdapter;
import com.idesolusiasia.learnflux.component.CircularNetworkImageView;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.FriendReq;
import com.idesolusiasia.learnflux.entity.Friends;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Notification;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.idesolusiasia.learnflux.util.VolleySingleton;
import com.koushikdutta.ion.Ion;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


public class MyProfileActivity extends BaseActivity implements View.OnClickListener {
	//Adapter
	ConnectionFragmentAdapter rAdapter;
	NotificationAdapter notifAdapter;
	FriendRequest frAdapt;
	MyProfileInterestAdapter myProfileInterestAdapter;
	FragmentAdapter mAdap;
	SearchAdapter id;
	MyProfileOrganizationAdapter rcAdapter;
	ChildrenAdapter childAdapter;

	//ArrayList
	ArrayList<Contact>childList;
	ArrayList<String>interestUser;
	List<Object> searchObject;
	ArrayList<Group> arrOrg = new ArrayList<Group>();
	ArrayList<Object> Org = new ArrayList<Object>();
	ArrayList<Notification> notif= new ArrayList<>();

	//RecyclerView
	public RecyclerView searchRecycler, myProfileInterest, ConnectionMyProfile,affilatedOrganizationRecycler;

	TextView interest1,interest2, txtParent, txtParentDesc, empty_view, affilatedOrganizationButtonMore , from, work;
	LinearLayout tabIndividual, tabGroups, tabOrganization, tabContact,showAllOrganization,linearTabBar;
	View indicatorIndividual, indicatorGroups, indicatorOrganization, indicatorContact;
	ImageView parent;
	CircularNetworkImageView child;
	private ImageView changeImage;
	ViewPager mViewPager;
	EditText searchBar;
	String visible;
	boolean visible2;
	ImageView enterSearch;
	LinearLayoutManager linearLayoutOrg;
	View includedLayout, includedLayout2, includedLayout3;
	File file;

	static final int ITEMS = 4;
	public int PICK_IMAGE =100;

	ImageLoader imageLoader = VolleySingleton.getInstance(MyProfileActivity.this).getImageLoader();

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_base);
		super.onCreateDrawer(savedInstanceState);


		AndroidNetworking.initialize(getApplicationContext()); // initialize library

		final FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
		final LayoutInflater layoutInflater = LayoutInflater.from(this);
		View childLayout = layoutInflater.inflate(
				R.layout.activity_my_profile, null);
		parentLayout.addView(childLayout);


		visible="none";
		visible2=true;

		//My profile and connection action bar
		final ScrollView scroll1 = (ScrollView) findViewById(R.id.linear1);
		final LinearLayout linear2 = (LinearLayout) findViewById(R.id.linear2);
		final ScrollView scroll3 = (ScrollView) findViewById(R.id.includeMyProfile);
		LinearLayout myProfileTab = (LinearLayout) findViewById(R.id.tabMyProfile);
		LinearLayout connectionTab = (LinearLayout) findViewById(R.id.tabConnection);
		final TextView myProfileTitle = (TextView) findViewById(R.id.myProfileTitle);
		final TextView connectionTitle = (TextView) findViewById(R.id.connectionTitle);
		final View line1 = (View) findViewById(R.id.line1);
		final View line2 = (View) findViewById(R.id.line2);
		ImageButton connectionNotif = (ImageButton)findViewById(R.id.friendsNotif);
		ImageButton userNotif = (ImageButton)findViewById(R.id.menotif);
		final ImageButton search = (ImageButton)findViewById(R.id.searchBar);
		final ViewPager viewPager = (ViewPager)findViewById(R.id.pager);
		includedLayout = findViewById(R.id.mixLayout);
		includedLayout2 = findViewById(R.id.mixLayout2);
		scroll3.setVisibility(View.GONE);

		myProfileTab.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				viewPager.setVisibility(View.GONE);
				line2.setVisibility(View.GONE);
				scroll3.setVisibility(View.GONE);
				myProfileTitle.setTextColor(Color.parseColor("#8bc34a"));
				line1.setVisibility(View.VISIBLE);
				line1.setBackgroundColor(Color.parseColor("#8bc34a"));
				scroll1.setVisibility(View.VISIBLE);
				connectionTitle.setTextColor(Color.parseColor("#FFFFFF"));
				linear2.setVisibility(View.GONE);
				includedLayout.setVisibility(View.GONE);
				includedLayout2.setVisibility(View.GONE);
				visible="none";
			}
		});
		connectionTab.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				viewPager.setVisibility(View.VISIBLE);
				scroll3.setVisibility(View.GONE);
				connectionTitle.setTextColor(Color.parseColor("#8bc34a"));
				line2.setVisibility(View.VISIBLE);
				line1.setVisibility(View.GONE);
				line2.setBackgroundColor(Color.parseColor("#8bc34a"));
				scroll1.setVisibility(View.GONE);
				myProfileTitle.setTextColor(Color.parseColor("#FFFFFF"));
				linear2.setVisibility(View.VISIBLE);
				includedLayout.setVisibility(View.GONE);
				includedLayout2.setVisibility(View.GONE);
				visible="none";
			}
		});


		//Friend Request Notification and All Notification
		//final TextView txtNotification1 = (TextView)findViewById(R.id.textNotif1);
		//final TextView txtNotification2 = (TextView)findViewById(R.id.textNotif2);
		final ProgressBar progress = (ProgressBar)findViewById(R.id.progress_bar);

		connectionNotif.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				progress.setVisibility(View.VISIBLE);
				if(visible.equalsIgnoreCase("none")||visible.equalsIgnoreCase("friend")) {
					includedLayout.setVisibility(View.VISIBLE);
					includedLayout2.setVisibility(View.GONE);
					includedLayout.bringToFront();
					final RecyclerView rcViewFriend = (RecyclerView)findViewById(R.id.recyclerFriendNotif);
					LinearLayoutManager linearLayoutManager= new LinearLayoutManager(getApplicationContext(), LinearLayoutManager.VERTICAL, false);
					rcViewFriend.setLayoutManager(linearLayoutManager);

					final List<Object> requestObjList= new ArrayList<Object>();
					final List<FriendReq> contactReq = new ArrayList<FriendReq>();
					final List<Friends> mutualFriendReq = new ArrayList<Friends>();


					Engine.getMeWithRequest(getApplicationContext(),"friends", new RequestTemplate.ServiceCallback() {
						@Override
						public void execute(JSONObject obj) {
							try {
								JSONArray array = obj.getJSONArray("pending");
								for(int i=0;i<array.length();i++){
									JSONObject ap = array.getJSONObject(i);
									FriendReq frQ = Converter.convertFriendRequest(ap);
									contactReq.add(frQ);
								}
								/*JSONArray array = data.getJSONArray("friend_request");
								for(int l=0;l<array.length();l++){
									JSONObject ap = array.getJSONObject(l);
									//Contact ctReq = Converter.convertContact(ap);
									//contactReq.add(ctReq);

									JSONArray friendArray = ap.getJSONArray("Friends");
									for(int first=0;first<friendArray.length();first++){
										JSONObject friends1 = friendArray.getJSONObject(first);
										Friends f = Converter.convertFriends(friends1);
										mutualFriendReq.add(f);
									}

								}
*/
								requestObjList.addAll(contactReq);
								//requestObjList.addAll(mutualFriendReq);

								TextView emptyFriend = (TextView)findViewById(R.id.empty_friend);
								if(requestObjList.isEmpty()) {
									emptyFriend.setVisibility(View.VISIBLE);
									rcViewFriend.setVisibility(View.GONE);
									progress.setVisibility(View.GONE);

								}else{
									progress.setVisibility(View.GONE);
									emptyFriend.setVisibility(View.GONE);
									rcViewFriend.setVisibility(View.VISIBLE);
									frAdapt = new FriendRequest(requestObjList);
									rcViewFriend.setAdapter(frAdapt);
									rcViewFriend.refreshDrawableState();
								}

							}catch (JSONException e){
								e.printStackTrace();
							}

						}
					});
					//txtNotification1.setVisibility(View.GONE);
					visible="notif";
				}else{
					includedLayout.setVisibility(View.GONE);
					includedLayout2.setVisibility(View.GONE);
					visible="none";
				}
			}
		});
		userNotif.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				if(visible.equalsIgnoreCase("none")|| visible.equalsIgnoreCase("notif")){
					notif = new ArrayList<>();
					includedLayout2.setVisibility(View.VISIBLE);
					includedLayout2.bringToFront();
					includedLayout.setVisibility(View.GONE);
					//txtNotification2.setVisibility(View.GONE);
					final RecyclerView recyclerNotif = (RecyclerView) findViewById(R.id.recycleNotification);
					LinearLayoutManager SecondLinear = new LinearLayoutManager(getApplicationContext(),LinearLayoutManager.VERTICAL,false);
					recyclerNotif.setLayoutManager(SecondLinear);
					Engine.getNotification(getApplicationContext(), new RequestTemplate.ServiceCallback() {
						@Override
						public void execute(JSONObject obj) {
							try{
								JSONArray data = obj.getJSONArray("data");
								for(int it=0;it<data.length();it++){
									Notification notifications = Converter.convertNotification(data.getJSONObject(it));
									notif.add(notifications);
								}
								TextView notifEmpty = (TextView)findViewById(R.id.empty_notification);
								if(notif.isEmpty()){
									notifEmpty.setVisibility(View.VISIBLE);
									recyclerNotif.setVisibility(View.GONE);
								}else {
									notifEmpty.setVisibility(View.GONE);
									notifAdapter = new NotificationAdapter(getApplicationContext(), notif);
									recyclerNotif.setAdapter(notifAdapter);
								}
							}catch (JSONException e){
								e.printStackTrace();
							}
						}
					});
					visible2=false;
					visible="friend";
				}else{
					includedLayout.setVisibility(View.GONE);
					includedLayout2.setVisibility(View.GONE);
					visible="none";
				}
			}
		});

		//Layout3 search action bar
		linearTabBar = (LinearLayout)findViewById(R.id.LinearTabBar);
		includedLayout3 = (LinearLayout) findViewById(R.id.mixLayout3);
		enterSearch = (ImageView)findViewById(R.id.enterYourPreference);
		searchBar = (EditText)findViewById(R.id.searchID);
		final ImageView back = (ImageView)findViewById(R.id.imageBack);
		searchRecycler = (RecyclerView)findViewById(R.id.recyclerViewSearch);
		LinearLayoutManager linearManagerSearch = new LinearLayoutManager(getApplicationContext(), LinearLayoutManager.VERTICAL,false);
		searchRecycler.setLayoutManager(linearManagerSearch);
		search.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				search();
			}
		});
		back.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				linearTabBar.setVisibility(View.VISIBLE);
				includedLayout3.setVisibility(View.GONE);
			}
		});

		//Edit Profile
		TextView editProfile = (TextView)findViewById(R.id.editProfile);
		final TextView save = (TextView)findViewById(R.id.save);
		editProfile.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				scroll1.setVisibility(View.GONE);
				scroll3.setVisibility(View.VISIBLE);
				scroll3.bringToFront();
				final EditText editextName = (EditText)findViewById(R.id.editTextName);
				final EditText From = (EditText)findViewById(R.id.edittextFrom);
				final EditText Work = (EditText)findViewById(R.id.editTextWork);
				save.setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View view) {
						Engine.editProfileName(getApplicationContext(), "", editextName.getText().toString().trim(),
								From.getText().toString().trim(),Work.getText().toString().trim(),"",  new RequestTemplate.ServiceCallback() {
							@Override
							public void execute(JSONObject obj) {
								finish();
								startActivity(getIntent());
							}
						});
					}
				});
			}
		});
		TextView textNotif = (TextView)findViewById(R.id.textView10);



		//Edit Profile UPLOADING AN IMAGE
		changeImage = (ImageView)findViewById(R.id.profileImageChange);
		changeImage.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent intent = new Intent();
				intent.setType("image/*");
				intent.setAction(Intent.ACTION_GET_CONTENT);
				startActivityForResult(Intent.createChooser(intent, "Select Image"), PICK_IMAGE);
			}
		});


		// Set User My Profile details Data inside the box
		//Setting the initialization
		work = (TextView)findViewById(R.id.work);
		from = (TextView)findViewById(R.id.fromText);
		parent = (ImageView)findViewById(R.id.imageeees);
		txtParentDesc = (TextView)findViewById(R.id.txtParentDesc);
		txtParent = (TextView)findViewById(R.id.txtParentTitle);
		child  = (CircularNetworkImageView)findViewById(R.id.imagesChild);
		child.setDefaultImageResId(R.drawable.user_profile);
		Engine.getMeWithRequest(getApplicationContext(),"details", new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					Contact ct = Converter.convertContact(obj);
					txtParent.setText(ct.getFirst_name()+" "+ct.getLast_name());
					if(ct.getLocation()==null){
						from.setText("-");
					}else{
						from.setText(ct.getLocation());
					}
					if(ct.getWork()==null){
						work.setText("-");
					}else {
						work.setText(ct.getWork());
					}
				String url = "http://lfapp.learnflux.net";
				if(ct.get_links().getProfile_picture()!=null) {
					String prof = url + ct.get_links().getProfile_picture().getHref();
					Ion.with(getApplicationContext())
							.load(prof).noCache()
							.addHeader("Authorization", "Bearer " + User.getUser().getAccess_token())
							.withBitmap().placeholder(R.drawable.user_profile).error(R.drawable.user_profile)
							.intoImageView(parent);
				}
				}catch (JSONException e){
					e.printStackTrace();
				}
			}
		});
		getUserStatus();

		//dialog children
		final RecyclerView recyclerChildren = (RecyclerView)findViewById(R.id.childrenRecyclerView);
		LinearLayoutManager childrenLayoutManager = new LinearLayoutManager(getApplicationContext(), LinearLayoutManager.HORIZONTAL, false);
		recyclerChildren.setLayoutManager(childrenLayoutManager);
		childList = new ArrayList<>();
		final TextView childrenEmptyView = (TextView)findViewById(R.id.childrenEmptyView);
		childrenEmptyView.setVisibility(View.VISIBLE);
		recyclerChildren.setVisibility(View.GONE);
		Engine.getMeWithRequest(getApplicationContext(),"details", new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					JSONObject embedded = obj.getJSONObject("_embedded");
					if(embedded.has("children")) {
						JSONArray array = embedded.getJSONArray("children");
						for (int i = 0; i < array.length(); i++) {
							Contact childrenContact = Converter.convertContact(array.getJSONObject(i));
							childList.add(childrenContact);
						}
						if (childList.isEmpty()) {
							recyclerChildren.setVisibility(View.GONE);
							childrenEmptyView.setVisibility(View.VISIBLE);
						} else {
							recyclerChildren.setVisibility(View.VISIBLE);
							childrenEmptyView.setVisibility(View.GONE);
							childAdapter = new ChildrenAdapter(getApplicationContext(), childList);
							recyclerChildren.setAdapter(childAdapter);
							recyclerChildren.refreshDrawableState();
						}

					}
				}catch (JSONException e){
					e.printStackTrace();
				}
			}
		});
		//Affilited Organization
		affilatedOrganizationRecycler = (RecyclerView)findViewById(R.id.organizationRecycler);
		empty_view = (TextView)findViewById(R.id.emptyViewOrg);
		showAllOrganization = (LinearLayout)findViewById(R.id.layoutShowAll);
		affilatedOrganizationButtonMore = (TextView)findViewById(R.id.buttonShowMore);
		linearLayoutOrg = new LinearLayoutManager(this,LinearLayoutManager.HORIZONTAL,false);
		affilatedOrganizationRecycler.setLayoutManager(linearLayoutOrg);
		initOrganizations();

		//User Interest
		myProfileInterest = (RecyclerView)findViewById(R.id.recyclerMyProfileInterest);
		LinearLayoutManager interestLayout = new LinearLayoutManager(getApplicationContext(), LinearLayoutManager.VERTICAL,false);
		myProfileInterest.setLayoutManager(interestLayout);
		getInterest();

		//ViewPager
		//set the adapter pager indicator of the tab
		mAdap = new FragmentAdapter(getSupportFragmentManager());
		mViewPager = (ViewPager) findViewById(R.id.pager);
		mViewPager.setAdapter(mAdap);
		tabIndividual = (LinearLayout) findViewById(R.id.tabIndividual);
		tabGroups = (LinearLayout) findViewById(R.id.tabGroups);
		tabOrganization = (LinearLayout) findViewById(R.id.tabOrganization);
		tabContact = (LinearLayout) findViewById(R.id.tabContact);
		tabIndividual.setOnClickListener(this);
		tabGroups.setOnClickListener(this);
		tabOrganization.setOnClickListener(this);
		tabContact.setOnClickListener(this);
		indicatorIndividual = (View) findViewById(R.id.indicator_individual);
		indicatorGroups = (View) findViewById(R.id.indicator_groups);
		indicatorOrganization = (View) findViewById(R.id.indicator_organization);
		indicatorContact = (View) findViewById(R.id.indicator_contact);

		mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
			@Override
			public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

			}

			@Override
			public void onPageSelected(int position) {
				selectTab(position);
			}

			@Override
			public void onPageScrollStateChanged(int state) {

			}
		});
		mViewPager.setCurrentItem(0);


		ConnectionMyProfile = (RecyclerView)findViewById(R.id.recyclerMyProfile);
		LinearLayoutManager ConnectionLayout = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
		ConnectionMyProfile.setLayoutManager(ConnectionLayout);
		initConnection();

	}


	void initConnection(){
		Org = new ArrayList<>();
		final TextView noConnection = (TextView)findViewById(R.id.emptyConnection);
		Engine.getMeWithRequest(getApplicationContext(), "Friends", new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					if(obj.has("Friends")){
						JSONArray friends = obj.getJSONArray("Friends");
						Contact c = Converter.convertContact(friends.getJSONObject(0));
						Org.add(c);
						Engine.getOrganizations(getApplicationContext(), new RequestTemplate.ServiceCallback() {
							@Override
							public void execute(JSONObject obj) {
								try {
									JSONArray array = obj.getJSONArray("data");
									Group g = Converter.convertGroup(array.getJSONObject(0));
									Org.add(g);

									if(Org.isEmpty()){
										noConnection.setVisibility(View.VISIBLE);
										ConnectionMyProfile.setVisibility(View.GONE);
									}else {
										noConnection.setVisibility(View.GONE);
										ConnectionMyProfile.setVisibility(View.VISIBLE);
										Functions.sortingContact(Org);
										rAdapter = new ConnectionFragmentAdapter(getApplicationContext(),Org);
										ConnectionMyProfile.setAdapter(rAdapter);
										ConnectionMyProfile.refreshDrawableState();
									}
								} catch (JSONException e) {
									e.printStackTrace();
								}

							}
						});
					}
				}catch (JSONException e){
					e.printStackTrace();
				}
			}
		});
	}
	@Override
	public void onClick(View view) {
		if (view == tabIndividual) {
			mViewPager.setCurrentItem(0);
		} else if (view == tabGroups) {
			mViewPager.setCurrentItem(1);
		} else if (view == tabOrganization) {
			mViewPager.setCurrentItem(2);
		} else if (view == tabContact) {
			mViewPager.setCurrentItem(3);
		}
	}
	void selectTab(int pos) {
		indicatorIndividual.setVisibility(View.GONE);
		indicatorGroups.setVisibility(View.GONE);
		indicatorOrganization.setVisibility(View.GONE);
		indicatorContact.setVisibility(View.GONE);
		if (pos == 0) {
			indicatorIndividual.setVisibility(View.VISIBLE);
		} else if (pos == 1) {
			indicatorGroups.setVisibility(View.VISIBLE);
		} else if (pos == 2) {
			indicatorOrganization.setVisibility(View.VISIBLE);
		} else if(pos == 3){
			indicatorContact.setVisibility(View.VISIBLE);
		}
	}
	public static class FragmentAdapter extends FragmentPagerAdapter {

		public FragmentAdapter(FragmentManager fm) {
			super(fm);
		}
		@Override
		public Fragment getItem(int position) {
			Fragment fragment =null;
			switch (position) {
				case 0:
					fragment = IndividualFragment.newInstance();
					break;
				case 1:
					fragment =  ConnectionGroupFragment.newInstance();
					break;
				case 2:
					fragment =  ConnectionOrganizationFragment.newInstance();
					break;
				case 3:
					fragment =  ContactFragment.newInstance();
					break;
			}
				return fragment;

		}
		@Override
		public int getCount() {
			return ITEMS;
		}
		@Override
		public int getItemPosition(Object object) {
			return POSITION_NONE;
		}
	}
	void search(){
		linearTabBar.setVisibility(View.GONE);
		includedLayout3.setVisibility(View.VISIBLE);
		includedLayout.setVisibility(View.GONE);
		includedLayout2.setVisibility(View.GONE);
		visible="none";
		searchBar.addTextChangedListener(new TextWatcher() {
			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {

			}

			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {

			}

			@Override
			public void afterTextChanged(Editable s) {
				searchValue();
			}
		});
		searchBar.setOnKeyListener(new View.OnKeyListener() {
			@Override
			public boolean onKey(View v, int keyCode, KeyEvent event) {
				if((event.getAction()==KeyEvent.ACTION_DOWN)&&(keyCode == KeyEvent.KEYCODE_ENTER)){
					searchValue();
					return true;
				}
				return false;
			}
		});
		enterSearch.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				searchValue();
			}
		});
	}
	void initOrganizations(){
		arrOrg = new ArrayList<>();
		Engine.getOrganizations(getApplicationContext(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					JSONArray array = obj.getJSONArray("data");
					for(int i=0;i<array.length();i++){
						Group org = Converter.convertOrganizations(array.getJSONObject(i));
						if(array.getJSONObject(i).getString("type").equals("organization")) {
							arrOrg.add(org);
						}
					}
					if(arrOrg.isEmpty()){
						affilatedOrganizationRecycler.setVisibility(View.GONE);
						empty_view.setVisibility(View.VISIBLE);
						showAllOrganization.setVisibility(View.GONE);
						affilatedOrganizationButtonMore.setVisibility(View.GONE);
					}else {
						rcAdapter = new MyProfileOrganizationAdapter(getApplicationContext(), arrOrg);
						affilatedOrganizationRecycler.setAdapter(rcAdapter);
						   if(arrOrg.size()>3) {
							   showAllOrganization.setVisibility(View.VISIBLE);
							   showAllOrganization.bringToFront();
							   affilatedOrganizationButtonMore.setOnClickListener(new View.OnClickListener() {
								   @Override
								   public void onClick(View view) {
									   showAllOrganization.setVisibility(View.GONE);
									   affilatedOrganizationButtonMore.setVisibility(View.GONE);
								   }
							   });
						   }else {
							   affilatedOrganizationButtonMore.setVisibility(View.VISIBLE);
							   showAllOrganization.setVisibility(View.GONE);
							   affilatedOrganizationButtonMore.setVisibility(View.GONE);
						   }
						/*if(arrOrg.size()>3){
							affilatedOrganizationButtonMore.setOnClickListener(new View.OnClickListener() {
								@Override
								public void onClick(View view) {

								}
							});
						}*/
						//emptyView.setVisibility(View.GONE);
					}
				}catch (JSONException e){
					e.printStackTrace();
				}

			}
		});
	}
	void getInterest(){
		interestUser = new ArrayList<>();
		final TextView emptyRecycler = (TextView)findViewById(R.id.interest_empty);
		emptyRecycler.setVisibility(View.VISIBLE);
		myProfileInterest.setVisibility(View.GONE);
		Engine.getMeWithRequest(getApplicationContext(),"details", new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					if(obj.has("interests")) {
						JSONArray interest = obj.getJSONArray("interests");
						for (int i = 0; i < interest.length(); i++) {
							interestUser.add(interest.get(i).toString());
						}
						emptyRecycler.setVisibility(View.GONE);
						myProfileInterest.setVisibility(View.VISIBLE);
						myProfileInterestAdapter = new MyProfileInterestAdapter(interestUser);
						myProfileInterest.setAdapter(myProfileInterestAdapter);
						myProfileInterest.refreshDrawableState();
					}
				}catch (JSONException e){
					e.printStackTrace();
				}
			}
		});
	}
	void getUserStatus(){
		Engine.getOrganizations(getApplicationContext(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					StringBuilder sb = new StringBuilder();
					JSONArray array = obj.getJSONArray("data");
					for(int i=0;i<array.length();i++){

					if(array.getJSONObject(i).getString("access").equals("Admin")){
						String nameofGroup = array.getJSONObject(i).getString("name");
						ArrayList<String> collectionOfStrings = new ArrayList<String>();
						collectionOfStrings.add(nameofGroup);
						for(String string : collectionOfStrings) {
							sb.append("Admin"+ " of " + string);
							sb.append(",");
							txtParentDesc.setText(sb.length() > 0 ? sb.substring(0, sb.length() - 1): "");
						}

						final TextView tvSeeMore = (TextView)findViewById(R.id.tvSeeMore);
						txtParentDesc.post(new Runnable() {
							@Override
							public void run() {
								int a = txtParentDesc.getLineCount();
								if(a>1){
									tvSeeMore.setVisibility(View.VISIBLE);
									txtParentDesc.setMaxLines(1);
								}
							}
						});
						tvSeeMore.setOnClickListener(new View.OnClickListener() {
							@Override
							public void onClick(View view) {
								txtParentDesc.setMaxLines(Integer.MAX_VALUE);
								tvSeeMore.setVisibility(View.GONE);
							}
						});


					}
					}
				}catch (JSONException e){
					e.printStackTrace();
				}
			}
		});
	}
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);

		if (requestCode == PICK_IMAGE && resultCode == Activity.RESULT_OK) {
				try {
					Uri selectedImage = data.getData();
					Bitmap bitmap = MediaStore.Images.Media.getBitmap(getContentResolver(), selectedImage);
					String path = getRealPathFromUri(selectedImage);
					changeImage.setImageBitmap(bitmap);
					file = new File(path);
					final String a = "http://lfapp.learnflux.net/v1/me/image?key=profile/"+User.getUser().getID();
					AndroidNetworking.put(a)
							.addFileBody(file)
							.addHeaders("Authorization", "Bearer " + User.getUser().getAccess_token())
							.setTag("uploadTest")
							.setPriority(Priority.HIGH)
							.build()
							.getAsJSONObject(new JSONObjectRequestListener() {
								@Override
								public void onResponse(JSONObject response) {
										Toast.makeText(MyProfileActivity.this, response.toString(), Toast.LENGTH_SHORT).show();

								}
								@Override
								public void onError(ANError error) {
									// handle error
								}
							});
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
	}
	public String getRealPathFromUri(final Uri uri) {
		// DocumentProvider
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT && DocumentsContract.isDocumentUri(getApplicationContext(), uri)) {
			// ExternalStorageProvider
			if (isExternalStorageDocument(uri)) {
				final String docId = DocumentsContract.getDocumentId(uri);
				final String[] split = docId.split(":");
				final String type = split[0];

				if ("primary".equalsIgnoreCase(type)) {
					return Environment.getExternalStorageDirectory() + "/" + split[1];
				}
			}
			// DownloadsProvider
			else if (isDownloadsDocument(uri)) {

				final String id = DocumentsContract.getDocumentId(uri);
				final Uri contentUri = ContentUris.withAppendedId(
						Uri.parse("content://downloads/public_downloads"), Long.valueOf(id));

				return getDataColumn(getApplicationContext(), contentUri, null, null);
			}
			// MediaProvider
			else if (isMediaDocument(uri)) {
				final String docId = DocumentsContract.getDocumentId(uri);
				final String[] split = docId.split(":");
				final String type = split[0];

				Uri contentUri = null;
				if ("image".equals(type)) {
					contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
				} else if ("video".equals(type)) {
					contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
				} else if ("audio".equals(type)) {
					contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
				}

				final String selection = "_id=?";
				final String[] selectionArgs = new String[]{
						split[1]
				};

				return getDataColumn(getApplicationContext(), contentUri, selection, selectionArgs);
			}
		}
		// MediaStore (and general)
		else if ("content".equalsIgnoreCase(uri.getScheme())) {

			// Return the remote address
			if (isGooglePhotosUri(uri))
				return uri.getLastPathSegment();

			return getDataColumn(getApplicationContext(), uri, null, null);
		}
		// File
		else if ("ic_file".equalsIgnoreCase(uri.getScheme())) {
			return uri.getPath();
		}

		return null;
	}

	private String getDataColumn(Context context, Uri uri, String selection,
								 String[] selectionArgs) {

		Cursor cursor = null;
		final String column = "_data";
		final String[] projection = {
				column
		};

		try {
			cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs,
					null);
			if (cursor != null && cursor.moveToFirst()) {
				final int index = cursor.getColumnIndexOrThrow(column);
				return cursor.getString(index);
			}
		} finally {
			if (cursor != null)
				cursor.close();
		}
		return null;
	}

	private boolean isExternalStorageDocument(Uri uri) {
		return "com.android.externalstorage.documents".equals(uri.getAuthority());
	}

	private boolean isDownloadsDocument(Uri uri) {
		return "com.android.providers.downloads.documents".equals(uri.getAuthority());
	}

	private boolean isMediaDocument(Uri uri) {
		return "com.android.providers.media.documents".equals(uri.getAuthority());
	}

	private boolean isGooglePhotosUri(Uri uri) {
		return "com.google.android.apps.photos.content".equals(uri.getAuthority());
	}
	public void searchValue(){
		searchObject = new ArrayList<>();
		Engine.getSearchValue(getApplicationContext(), searchBar.getText().toString().trim(),
				new RequestTemplate.ServiceCallback() {
					@Override
					public void execute(JSONObject obj) {
						try{
							JSONArray user = obj.getJSONArray("users");
							if(user!=null){
								for(int i=0;i<user.length();i++){
									Contact searchPeople = Converter.convertContact(user.getJSONObject(i));
									searchObject.add(searchPeople);
								}
							}
							JSONArray group = obj.getJSONArray("groups");
							if(group!=null){
								for(int i=0;i<group.length();i++){
									Group g = Converter.convertGroup(group.getJSONObject(i));
									searchObject.add(g);
								}
							}

							searchObject = Functions.sortingContact(searchObject);
							id=new SearchAdapter(getApplicationContext(),searchObject);
							searchRecycler.setAdapter(id);
							searchRecycler.refreshDrawableState();



						}catch (JSONException e){
							e.printStackTrace();
						}
					}
				});
	}
	@Override
	protected void onRestart() {
		super.onRestart();

		//first clear the recycler view so items are not populated twice
		if(id != null) {
			id.clearData();
		}
	}
	@Override
	public void onBackPressed() {
		super.onBackPressed();
		Intent intent = new Intent(getApplicationContext(), HomeActivity.class);
		overridePendingTransition(0, 0);
		intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
		finish();
		overridePendingTransition(0, 0);
		startActivity(intent);
	}
}