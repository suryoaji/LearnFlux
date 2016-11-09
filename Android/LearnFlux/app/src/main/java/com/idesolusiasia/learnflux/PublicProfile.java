package com.idesolusiasia.learnflux;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.adapter.ChildrenAdapter;
import com.idesolusiasia.learnflux.adapter.MyProfileAdapter;
import com.idesolusiasia.learnflux.adapter.MyProfileInterestAdapter;
import com.idesolusiasia.learnflux.component.CircularNetworkImageView;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.Functions;
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
    MyProfileAdapter rcAdapter;
    ArrayList<Contact> childList;
    ArrayList<Group> groupContact;
    ArrayList<String>interestUser;

    RecyclerView myProfileInterest;
    NetworkImageView parent;
    CircularNetworkImageView mutualImages;

    RecyclerView affilatedOrganizationRecycler;
    TextView emptyOrgs;

    TextView txtParent, txtParentDesc, from, work, mutual;
    public int id;
    String url = "http://lfapp.learnflux.net";

    ImageLoader imageLoader = VolleySingleton.getInstance(PublicProfile.this).getImageLoader();
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_public_profile);
        super.onCreateDrawer(savedInstanceState);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        toolbar.setNavigationIcon(R.drawable.ic_arrow_back);

        final ImageView addProfile= (ImageView) findViewById(R.id.addProfile);
        work = (TextView)findViewById(R.id.work);
        from = (TextView)findViewById(R.id.fromText);
        parent = (NetworkImageView)findViewById(R.id.imageeees);
        txtParentDesc = (TextView)findViewById(R.id.txtParentDesc);
        txtParent = (TextView)findViewById(R.id.txtParentTitle);
        mutual = (TextView)findViewById(R.id.mutualFriend);
        mutualImages = (CircularNetworkImageView)findViewById(R.id.imagesMutual);
        final TextView emptyRecycler = (TextView)findViewById(R.id.interest_empty);


        final RecyclerView recyclerChildren = (RecyclerView)findViewById(R.id.childrenRecyclerView);
        LinearLayoutManager childrenLayoutManager = new LinearLayoutManager(getApplicationContext(), LinearLayoutManager.HORIZONTAL, false);
        recyclerChildren.setLayoutManager(childrenLayoutManager);
        childList = new ArrayList<>();
        groupContact = new ArrayList<>();
        final TextView childrenEmptyView = (TextView)findViewById(R.id.childrenEmptyView);
        childrenEmptyView.setVisibility(View.VISIBLE);
        recyclerChildren.setVisibility(View.GONE);


        myProfileInterest = (RecyclerView)findViewById(R.id.recyclerMyProfileInterest);
        LinearLayoutManager interestLayout = new LinearLayoutManager(getApplicationContext(), LinearLayoutManager.VERTICAL,false);
        myProfileInterest.setLayoutManager(interestLayout);
        emptyRecycler.setVisibility(View.VISIBLE);
        myProfileInterest.setVisibility(View.GONE);
        id = getIntent().getIntExtra("id",0);


        affilatedOrganizationRecycler = (RecyclerView)findViewById(R.id.organizationRecycler);
        emptyOrgs = (TextView)findViewById(R.id.emptyViewOrg);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false);
        affilatedOrganizationRecycler.setLayoutManager(linearLayoutManager);

        Engine.queryWithUserId(getApplicationContext(), String.valueOf(id), "details", new RequestTemplate.ServiceCallback() {
            @Override
            public void execute(JSONObject obj) {
                try {
                    Contact c = Converter.convertContact(obj);
                    txtParent.setText(c.getFirst_name()+" "+c.getLast_name());
                    work.setText(c.getWork());
                    from.setText(c.getLocation());
                    if(c.get_links().getProfile_picture()!=null) {
                        parent.setImageUrl(url + c.get_links().getProfile_picture().getHref(), imageLoader);
                    }else{
                        parent.setDefaultImageResId(R.drawable.user_profile);
                    }
                    JSONArray mt = obj.getJSONArray("mutual");
                    for(int i=0;i<mt.length();i++){
                        if(c.getMutual().get(i).get_links().getProfile_picture()!=null) {
                            mutualImages.setImageUrl(url + c.getMutual().get(i).get_links().getProfile_picture().getHref(), imageLoader);
                        }else{
                            mutualImages.setDefaultImageResId(R.drawable.user_profile);
                        }
                        StringBuilder sb = new StringBuilder();
                        ArrayList<String>collectionString = new ArrayList<String>();
                        collectionString.add(c.getMutual().get(i).getFirst_name() + c.getMutual().get(i).getLast_name());
                        for(String string : collectionString){
                            sb.append("Mutual friend of "+ string+ " ");
                            sb.append(",");
                            mutual.setText(sb.length() > 0 ? sb.substring(0, sb.length() - 1): " ");
                        }
                    }
                     JSONObject embedded = obj.getJSONObject("_embedded");
                     JSONArray child = embedded.getJSONArray("children");
                     for(int j=0;j<child.length();j++){
                         Contact ch = Converter.convertContact(child.getJSONObject(j));
                         childList.add(ch);
                     }
                        recyclerChildren.setVisibility(View.VISIBLE);
                        childrenEmptyView.setVisibility(View.GONE);
                        childAdapter = new ChildrenAdapter(getApplicationContext(),childList);
                        recyclerChildren.setAdapter(childAdapter);
                        recyclerChildren.refreshDrawableState();

                    JSONArray interest = obj.getJSONArray("interests");
                    for(int it=0;it<interest.length();it++){
                        interestUser = new ArrayList<String>();
                        interestUser.add(interest.get(it).toString());
                    }
                    emptyRecycler.setVisibility(View.GONE);
                    myProfileInterest.setVisibility(View.VISIBLE);
                    myProfileInterestAdapter = new MyProfileInterestAdapter(interestUser);
                    myProfileInterest.setAdapter(myProfileInterestAdapter);
                    myProfileInterest.refreshDrawableState();


                    JSONArray group = embedded.getJSONArray("groups");
                    for(int g=0;g<group.length();g++){
                        Group grops = Converter.convertGroup(group.getJSONObject(g));
                        groupContact.add(grops);
                    }
                    if(groupContact.isEmpty()){
                        affilatedOrganizationRecycler.setVisibility(View.GONE);
                        emptyOrgs.setVisibility(View.VISIBLE);
                    }else {
                        rcAdapter = new MyProfileAdapter(getApplicationContext(), groupContact);
                        affilatedOrganizationRecycler.setAdapter(rcAdapter);
                        emptyOrgs.setVisibility(View.GONE);
                    }

                }catch (JSONException e){
                    e.printStackTrace();
                }
            }
        });

        addProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {
                if(User.getUser().getID()== id){
                    Functions.showAlert(v.getContext(), "Message", "You cannot add yourself");
                } else {
                    Engine.getUserFriend(v.getContext(), id, new RequestTemplate.ServiceCallback() {
                        @Override
                        public void execute(JSONObject obj) {
                            Toast.makeText(v.getContext(), "Successfully adding a friend", Toast.LENGTH_SHORT).show();
                        }
                    });
                }
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
