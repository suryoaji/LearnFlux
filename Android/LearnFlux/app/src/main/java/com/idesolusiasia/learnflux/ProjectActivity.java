package com.idesolusiasia.learnflux;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.idesolusiasia.learnflux.adapter.ProjectListAdapter;
import com.idesolusiasia.learnflux.adapter.ProjectNotificationAdapter;
import com.idesolusiasia.learnflux.adapter.ProjectProfileCommentAdapter;

import java.util.ArrayList;

/**
 * Created by Ide Solusi Asia on 11/18/2016.
 */

public class ProjectActivity extends BaseActivity {
    ProjectListAdapter plAdapter;
    RecyclerView rcView, recRecycler, notifRecycler;
    TextView  profileTitle, listTitle ;
    ImageView searchProject;
    LinearLayout projectList, actionBar;
    ArrayList<String>title = new ArrayList<>();
    ProjectNotificationAdapter PNAdapter;
    View layoutNotif;


    //For Project Profile
    TextView projectProfileDesc, postMessage;
    EditText comment;
    RecyclerView commentProfile;
    Button gotoProjectDetails;
    FloatingActionButton flbtn;
    ProjectProfileCommentAdapter ppcAdapter;
    ImageView joinProject, inviting, btnManifest, notifProject;
    LinearLayout lnm;
    String visible;

    ArrayList<String>Notification;
    ArrayList<String> userComment;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_base);
        super.onCreateDrawer(savedInstanceState);

        final FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
        final LayoutInflater layoutInflater = LayoutInflater.from(this);
        View childLayout = layoutInflater.inflate(
                R.layout.activity_home_project, null);
        parentLayout.addView(childLayout);


        // SETTING LAYOUT OF PROFILES AND LIST
        projectList = (LinearLayout)findViewById(R.id.projectListLayout);
        final View projectProfile = (View)findViewById(R.id.projectProfileLayout);
        actionBar = (LinearLayout)findViewById(R.id.actionBarLayout);
        searchProject = (ImageView)findViewById(R.id.searchProject);
        listTitle = (TextView)findViewById(R.id.projectListTitle);
        profileTitle = (TextView)findViewById(R.id.projectProfileTitle);
        rcView = (RecyclerView)findViewById(R.id.listOfProjectRecycler);
        notifProject = (ImageView)findViewById(R.id.notifProject);
        layoutNotif = (View)findViewById(R.id.layoutNotif);
        visible = "none";

        String s = getIntent().getStringExtra("projectAct");

        recRecycler = (RecyclerView)findViewById(R.id.listOfRecommendedProject);
        recRecycler.setLayoutManager(new LinearLayoutManager(this));

        notifRecycler = (RecyclerView)findViewById(R.id.recyclerProject);
        notifRecycler.setLayoutManager(new LinearLayoutManager(this));

        LinearLayoutManager linear = new LinearLayoutManager(getApplicationContext(),LinearLayoutManager.VERTICAL,false);
        rcView.setLayoutManager(linear);
        //Dummy Data
        title.add("Old Folks Home");
        title.add("Animal Shelter");

        notifProject.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(visible.equalsIgnoreCase("none")){
                    layoutNotif.bringToFront();
                    layoutNotif.setVisibility(View.VISIBLE);
                    Notification = new ArrayList<String>();
                    Notification.add("Grace Chong requested to join Old Folks Home");
                    Notification.add("Andrew Chew commented on post you are following in Child Education Spore");
                    Notification.add("Jason Lee mentioned you in comment");
                    Notification.add("Testing 4");
                    PNAdapter = new ProjectNotificationAdapter(getApplicationContext(), Notification);
                    notifRecycler.setAdapter(PNAdapter);
                    visible = "true";
                }else{
                    layoutNotif.setVisibility(View.GONE);
                    visible="none";
                }
            }
        });

        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(60, 60);
        LinearLayout.LayoutParams secondParams = new LinearLayout.LayoutParams(60, 60);
        params.setMargins(260,40,0,0);
        secondParams.setMargins(150,40,0,0);
        if(title!=null) {
            plAdapter = new ProjectListAdapter(getApplicationContext(), title);
            rcView.setAdapter(plAdapter);
            rcView.setVisibility(View.VISIBLE);
        }else{
            rcView.setVisibility(View.GONE);
        }
        if(s.contains("activity")){
            notifProject.setLayoutParams(params);
            profileTitle.setVisibility(View.INVISIBLE);
            listTitle.setTextColor(Color.parseColor("#8bc34a"));
        }else if(s.contains("profiles")){
                notifProject.setLayoutParams(secondParams);
                listTitle.setVisibility(View.VISIBLE);
                profileTitle.setVisibility(View.VISIBLE);
                profileTitle.setTextColor(Color.parseColor("#8bc34a"));
                projectList.setVisibility(View.GONE);
                projectProfile.setVisibility(View.VISIBLE);
                searchProject.setVisibility(View.GONE);
                actionBar.setVisibility(View.VISIBLE);
                comment = (EditText)findViewById(R.id.comment);
                projectProfileDesc = (TextView)findViewById(R.id.descProjectProfile);
                gotoProjectDetails = (Button)findViewById(R.id.gotoProjectDetails);
                joinProject = (ImageView)findViewById(R.id.Profile_joinGroup);
                flbtn = (FloatingActionButton)findViewById(R.id.floatingButton);
                inviting = (ImageView)findViewById(R.id.inviteCollab);
                lnm = (LinearLayout)findViewById(R.id.keyboard);
                postMessage = (TextView)findViewById(R.id.postMessage);
                btnManifest = (ImageView)findViewById(R.id.btn_manifest);
                final InputMethodManager inputManager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);

                //recyclerview Comment
                commentProfile = (RecyclerView)findViewById(R.id.projectProfileRecycler);
                LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);
                commentProfile.setLayoutManager(linearLayoutManager);


                flbtn.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        lnm.setVisibility(View.VISIBLE);
                        flbtn.setVisibility(View.GONE);
                        lnm.requestFocus();
                        inputManager.toggleSoftInput (InputMethodManager.SHOW_FORCED, InputMethodManager.HIDE_IMPLICIT_ONLY);
                    }

                });
                postMessage.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        inputManager.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0);
                        flbtn.setVisibility(View.VISIBLE);
                        lnm.setVisibility(View.GONE);
                        userComment = new ArrayList<>();
                        String commentUser = comment.getText().toString().trim();
                        userComment.add(commentUser);
                        ppcAdapter = new ProjectProfileCommentAdapter(getApplicationContext(), userComment);
                        commentProfile.setAdapter(ppcAdapter);
                        comment.getText().clear();
                    }
                });
                gotoProjectDetails.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Intent a = new Intent(ProjectActivity.this, ProjectDetails.class);
                        startActivity(a);
                    }
                });
                joinProject.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Intent i = new Intent(ProjectActivity.this, JoinInviteStakeHolders.class);
                        i.putExtra("toolbar", "join");
                        startActivity(i);
                    }
                });
                inviting.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Intent o = new Intent(ProjectActivity.this, JoinInviteStakeHolders.class);
                        o.putExtra("toolbar", "invite");
                        startActivity(o);
                    }
                });
                btnManifest.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Intent manifest = new Intent (ProjectActivity.this, JoinInviteStakeHolders.class);
                        manifest.putExtra("toolbar", "manifest");
                        startActivity(manifest);
                    }
                });
                listTitle.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    profileTitle.setVisibility(View.INVISIBLE);
                    actionBar.setVisibility(View.GONE);
                    searchProject.setVisibility(View.VISIBLE);
                    projectProfile.setVisibility(View.GONE);
                    projectList.setVisibility(View.VISIBLE);
                }
            });

        }

    }
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.project, menu);
        return true;
    }@Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        switch(id){
            case R.id.newProject:
                Intent intent = new Intent(ProjectActivity.this, ProjectEdit.class);
                startActivity(intent);
                break;
        }

        return super.onOptionsItemSelected(item);
    }
}
