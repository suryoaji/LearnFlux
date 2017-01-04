package com.idesolusiasia.learnflux;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.activity.BaseActivity;
import com.idesolusiasia.learnflux.activity.MyProfileActivity;
import com.idesolusiasia.learnflux.adapter.ChildrenAdapter;
import com.idesolusiasia.learnflux.adapter.MyProfileOrganizationAdapter;
import com.idesolusiasia.learnflux.adapter.MyProfileInterestAdapter;
import com.idesolusiasia.learnflux.component.CircularNetworkImageView;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Ide Solusi Asia on 11/8/2016.
 */

public class PublicProfile extends BaseActivity {
    MyProfileInterestAdapter myProfileInterestAdapter;
    ChildrenAdapter childAdapter;
    MyProfileOrganizationAdapter rcAdapter;
    ArrayList<Contact> childList;
    ArrayList<Group> groupContact;
    ArrayList<String>interestUser;

    FrameLayout childrenLayout, affiliatedLayout, interestFrameLayout;

    RecyclerView myProfileInterest;
    NetworkImageView parent;
    CircularNetworkImageView mutualImages;

    RecyclerView affilatedOrganizationRecycler;
    LinearLayout receiveRequest, sendRequest;

    TextView txtParent, txtParentDesc, from, work, mutual, buttonMore;
    public int id;
    String url = "http://lfapp.learnflux.net";

    Button btnRequest, btnAccept;

    ImageLoader imageLoader = VolleySingleton.getInstance(PublicProfile.this).getImageLoader();
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_base);
        super.onCreateDrawer(savedInstanceState);

        final FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
        final LayoutInflater layoutInflater = LayoutInflater.from(this);
        View childLayout = layoutInflater.inflate(
                R.layout.activity_public_profile, null);
        parentLayout.addView(childLayout);

        final ImageView addProfile= (ImageView) findViewById(R.id.addProfile);
        work = (TextView)findViewById(R.id.work);
        from = (TextView)findViewById(R.id.fromText);
        parent = (NetworkImageView)findViewById(R.id.imageeees);
        txtParentDesc = (TextView)findViewById(R.id.txtParentDesc);
        txtParent = (TextView)findViewById(R.id.txtParentTitle);
        mutual = (TextView)findViewById(R.id.mutualFriend);
        mutualImages = (CircularNetworkImageView)findViewById(R.id.imagesMutual);

        receiveRequest = (LinearLayout)findViewById(R.id.layoutAcceptDecline);
        sendRequest = (LinearLayout)findViewById(R.id.layoutRequest);



        id = getIntent().getIntExtra("id",0);


        String getData = getIntent().getStringExtra("public");
        if(getData.equalsIgnoreCase("search")){
            sendRequest.setVisibility(View.VISIBLE);
            btnRequest = (Button)findViewById(R.id.button_request);
            btnRequest.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Engine.getUserFriend(getApplicationContext(), id, new RequestTemplate.ServiceCallback() {
                @Override
                public void execute(JSONObject obj) {
                    Toast.makeText(getApplicationContext(), "Successfully adding a friend", Toast.LENGTH_SHORT).show();
                    Intent i = new Intent(PublicProfile.this, MyProfileActivity.class);
                    startActivity(i);
                }
            });
                }
            });

        }else if(getData.equalsIgnoreCase("friendRequest")){
            receiveRequest.setVisibility(View.VISIBLE);
            btnAccept = (Button)findViewById(R.id.buttonAccept);
            btnAccept.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Engine.getUserFriend(getApplicationContext(), id, new RequestTemplate.ServiceCallback() {
                @Override
                public void execute(JSONObject obj) {
                    Toast.makeText(getApplicationContext(), "Succesfull adding a friend", Toast.LENGTH_SHORT).show();
                    Intent i = new Intent(PublicProfile.this, MyProfileActivity.class);
                    startActivity(i);
                }
            });
                }
            });

        }


        final RecyclerView recyclerChildren = (RecyclerView)findViewById(R.id.childrenRecyclerView);
        childrenLayout = (FrameLayout)findViewById(R.id.framePublicMyProfile);
        LinearLayoutManager childrenLayoutManager = new LinearLayoutManager(getApplicationContext(), LinearLayoutManager.HORIZONTAL, false);
        recyclerChildren.setLayoutManager(childrenLayoutManager);
        childList = new ArrayList<>();
        groupContact = new ArrayList<>();


        myProfileInterest = (RecyclerView)findViewById(R.id.recyclerMyProfileInterest);
        LinearLayoutManager interestLayout = new LinearLayoutManager(getApplicationContext(), LinearLayoutManager.VERTICAL,false);
        myProfileInterest.setLayoutManager(interestLayout);
        interestFrameLayout = (FrameLayout)findViewById(R.id.interestPublic);


        affilatedOrganizationRecycler = (RecyclerView)findViewById(R.id.organizationRecycler);
        affiliatedLayout =  (FrameLayout)findViewById(R.id.publicAffiliatedOrg);
        final LinearLayout showAll = (LinearLayout)findViewById(R.id.publicShowAll);
        buttonMore = (TextView)findViewById(R.id.publicShowMore);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false);
        affilatedOrganizationRecycler.setLayoutManager(linearLayoutManager);

        Engine.queryWithUserId(getApplicationContext(), String.valueOf(id), "details", new RequestTemplate.ServiceCallback() {
            @Override
            public void execute(JSONObject obj) {
                try {
                    Contact c = Converter.convertContact(obj);
                    txtParent.setText(c.getFirst_name()+" "+c.getLast_name());
                    if(c.getWork()!=null) {
                        work.setText(c.getWork());
                    }else{
                        work.setText("-");
                    }
                    if(c.getLocation()!=null){
                        from.setText(c.getLocation());
                    }else{
                        from.setText("-");
                    }
                    if(c.get_links().getProfile_picture()!=null) {
                        parent.setImageUrl(url + c.get_links().getProfile_picture().getHref(), imageLoader);
                    }else{
                        parent.setDefaultImageResId(R.drawable.user_profile);
                    }

                    //MUTUAL FRIEND
                        if(obj.has("mutual")) {
                            JSONArray mt = obj.getJSONArray("mutual");
                            for (int i = 0; i < mt.length(); i++) {
                                if (c.getMutual().get(i).get_links().getProfile_picture() == null) {
                                    mutualImages.setDefaultImageResId(R.drawable.user_profile);
                                } else {
                                    mutualImages.setImageUrl(url + c.getMutual().get(i).get_links().getProfile_picture().getHref(), imageLoader);
                                }
                                StringBuilder sb = new StringBuilder();
                                ArrayList<String> collectionString = new ArrayList<String>();
                                collectionString.add(c.getMutual().get(i).getFirst_name() + " " + c.getMutual().get(i).getLast_name());
                                for (String string : collectionString) {
                                    sb.append("Mutual friend of " + string + " ");
                                    sb.append(",");
                                    mutual.setText(sb.length() > 0 ? sb.substring(0, sb.length() - 1) : " ");
                                }
                            }
                        }

                    //CHILDREN
                     JSONObject embedded = obj.getJSONObject("_embedded");
                     if(embedded.has("children")) {
                         JSONArray child = embedded.getJSONArray("children");
                             for (int j = 0; j < child.length(); j++) {
                                 Contact ch = Converter.convertContact(child.getJSONObject(j));
                                 childList.add(ch);
                             }
                             if(childList.isEmpty()) {
                                 childrenLayout.setVisibility(View.GONE);
                             }else{
                                 childrenLayout.setVisibility(View.VISIBLE);
                                 childAdapter = new ChildrenAdapter(getApplicationContext(), childList);
                                 recyclerChildren.setAdapter(childAdapter);
                                 recyclerChildren.refreshDrawableState();
                             }
                     }

                    //INTEREST
                        if(obj.has("interests")) {
                            JSONArray interest = obj.getJSONArray("interests");
                            for (int it = 0; it < interest.length(); it++) {
                                interestUser = new ArrayList<String>();
                                interestUser.add(interest.get(it).toString());
                            }
                            if(interestUser.isEmpty()){
                                interestFrameLayout.setVisibility(View.GONE);
                            }else{
                                myProfileInterestAdapter = new MyProfileInterestAdapter(interestUser);
                                myProfileInterest.setAdapter(myProfileInterestAdapter);
                                myProfileInterest.refreshDrawableState();
                                interestFrameLayout.setVisibility(View.VISIBLE);
                            }

                        }

                    //ORGANIZATION

                        JSONArray group = embedded.getJSONArray("groups");
                        for (int g = 0; g < group.length(); g++) {
                            Group grops = Converter.convertGroup(group.getJSONObject(g));
                            groupContact.add(grops);
                        }
                        if (groupContact.isEmpty()) {
                            affiliatedLayout.setVisibility(View.GONE);
                        } else {
                            rcAdapter = new MyProfileOrganizationAdapter(getApplicationContext(), groupContact);
                            affilatedOrganizationRecycler.setAdapter(rcAdapter);
                            affiliatedLayout.setVisibility(View.VISIBLE);
                            if(groupContact.size()>3){
                                    showAll.setVisibility(View.VISIBLE);
                                    showAll.bringToFront();
                                    buttonMore.setOnClickListener(new View.OnClickListener() {
                                        @Override
                                        public void onClick(View view) {
                                            showAll.setVisibility(View.GONE);
                                            buttonMore.setVisibility(View.GONE);
                                        }
                                    });
                            }else{
                                showAll.setVisibility(View.GONE);
                                buttonMore.setVisibility(View.GONE);
                            }

                        }

                }catch (JSONException e){
                    e.printStackTrace();
                }
            }
        });

        addProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {
                    Engine.getUserFriend(v.getContext(), id, new RequestTemplate.ServiceCallback() {
                        @Override
                        public void execute(JSONObject obj) {
                            Toast.makeText(v.getContext(), "Successfully adding a friend", Toast.LENGTH_SHORT).show();
                            Intent i = new Intent(PublicProfile.this, MyProfileActivity.class);
                            startActivity(i);
                        }
                    });
            }
        });


    }
    @Override
    public boolean onOptionsItemSelected(MenuItem menuItem) {
        switch (menuItem.getItemId()) {
            case android.R.id.home:
                // ProjectsActivity is my 'home' activity
                startActivityAfterCleanup(MyProfileActivity.class);
                return true;
        }
        return (super.onOptionsItemSelected(menuItem));
    }

    private void startActivityAfterCleanup(Class<?> cls) {
        Intent intent = new Intent(getApplicationContext(), cls);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(intent);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        Intent intr = new Intent(getApplicationContext(), MyProfileActivity.class);
        intr.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(intr);
    }
}
