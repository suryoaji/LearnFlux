package com.idesolusiasia.learnflux;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;

import com.bignerdranch.expandablerecyclerview.Model.ParentListItem;
import com.idesolusiasia.learnflux.adapter.ManifestAdapter;
import com.idesolusiasia.learnflux.adapter.TestAdapter;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.SubcategoryParentListItem;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

/**
 * Created by Kuroko on 11/28/2016.
 */

public class JoinInviteStakeHolders extends BaseActivity {
        Button join, inviteCollaborator, requestingToJoin;
        EditText projectStart, projectEnd, taskTitle;
        LinearLayout linearTeamMember, linearTask, linearButton;
        Toolbar toolbar;
        RecyclerView expendable;
        ManifestAdapter mAdapt;
        View rowProfile;
        ArrayList<Group>yes;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_base);
        super.onCreateDrawer(savedInstanceState);

        final FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
        final LayoutInflater layoutInflater = LayoutInflater.from(this);
        View childLayout = layoutInflater.inflate(
                R.layout.activity_join_invite_project, null);
        parentLayout.addView(childLayout);

        String a = getIntent().getStringExtra("toolbar");
        toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(false);

        join = (Button)findViewById(R.id.buttonJoinGroup);
        linearButton = (LinearLayout)findViewById(R.id.layoutJoinDecline);

        linearTask = (LinearLayout)findViewById(R.id.layoutInviteandJoin);
        taskTitle = (EditText)findViewById(R.id.taskTitle);

        inviteCollaborator = (Button)findViewById(R.id.buttonInviteCollaborator);
        projectStart = (EditText) findViewById(R.id.startJoinProjectTask);
        projectEnd = (EditText) findViewById(R.id.endJoinProjectTask);
        linearTeamMember =  (LinearLayout)findViewById(R.id.teamMemberLayout);
        projectStart.setFocusable(false); projectStart.setClickable(true);
        projectEnd.setFocusable(false); projectEnd.setClickable(true);
        expendable = (RecyclerView)findViewById(R.id.recyclerExpendable);
        rowProfile = (View)findViewById(R.id.rowProfile);
        requestingToJoin = (Button)findViewById(R.id.requestingToJoin);

        final SimpleDateFormat simpleDateFormat = new SimpleDateFormat("EEEE, dd MMM yyyy", Locale.US);
        final Calendar calendar = Calendar.getInstance();
        projectStart.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DatePickerDialog datePickerDialog = new DatePickerDialog(JoinInviteStakeHolders.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker datePicker, int year, int monthOfYear, int dayOfMonth) {
                        calendar.set(year,monthOfYear,dayOfMonth);
                        projectStart.setText(simpleDateFormat.format(calendar.getTime()));
                    }
                }, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH));
                datePickerDialog.show();
            }
        });
        projectEnd.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DatePickerDialog datePickerDialog = new DatePickerDialog(JoinInviteStakeHolders.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker datePicker, int year, int monthOfYear, int dayOfMonth) {
                        calendar.set(year,monthOfYear,dayOfMonth);
                        projectEnd.setText(simpleDateFormat.format(calendar.getTime()));
                    }
                }, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH));
                datePickerDialog.show();
            }
        });
        if(a.contains("join")){
            toolbar.setTitle("Join Group");
            linearTask.setVisibility(View.VISIBLE);
            requestingToJoin.setVisibility(View.VISIBLE);

        }else if(a.contains("invite")){
            toolbar.setTitle("Invite Collaborators for project");
            inviteCollaborator.setVisibility(View.VISIBLE);
            linearTask.setVisibility(View.VISIBLE);
            inviteCollaborator.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Intent i = new Intent(JoinInviteStakeHolders.this, InvitePeople.class);
                    startActivity(i);
                }
            });
        }else if(a.contains("Profile")){
            toolbar.setTitle("Manifest");
            rowProfile.setVisibility(View.VISIBLE);
            linearTask.setVisibility(View.VISIBLE);
            linearTeamMember.setVisibility(View.VISIBLE);
        }else if(a.contains("notification")){
            toolbar.setTitle("Join Project");
            linearButton.setVisibility(View.VISIBLE);
            linearTask.setVisibility(View.VISIBLE);
            rowProfile.setVisibility(View.VISIBLE);
        }
        else if(a.contains("manifest")){
            toolbar.setTitle("Project Olds Folks Home");
            linearTask.setVisibility(View.GONE);
            linearButton.setVisibility(View.GONE);
            inviteCollaborator.setVisibility(View.GONE);

           /* final ArrayList<SubcategoryParentListItem> subcategoryParentListItems = new ArrayList<>();
            for (int i = 0; i < 3; i++) {
                SubcategoryParentListItem eachParentItem = new SubcategoryParentListItem();
                subcategoryParentListItems.add(eachParentItem);
            }

            for (SubcategoryParentListItem subcategoryParentListItem : subcategoryParentListItems) {
                List<SubcategoryChildListItem> childItemList = new ArrayList<>();
                for (int i = 0; i < 1; i++) {
                    childItemList.add(new SubcategoryChildListItem());
                }
                subcategoryParentListItem.setChildItemList(childItemList);
                parentListItems.add(subcategoryParentListItem);
            }*/
            Engine.getOrganizations(getApplicationContext(), new RequestTemplate.ServiceCallback() {
                @Override
                public void execute(JSONObject obj) {
                    yes = new ArrayList<Group>();
                    final ArrayList<SubcategoryParentListItem> subcategoryParentListItems = new ArrayList<>();
                    try{
                        ArrayList<ParentListItem> parentListItems = new ArrayList<>();
                        Group org= null;
                        JSONArray data = obj.getJSONArray("data");
                       /* for( int i =0; i<data.length();i++){
                            org= Converter.convertGroup(data.getJSONObject(i));
                            SubcategoryParentListItem eachParentItem = new SubcategoryParentListItem(org.getName());
                            subcategoryParentListItems.add(eachParentItem);
                        }
                        for(SubcategoryParentListItem subcategoryParentListItem : subcategoryParentListItems) {
                            List<SubcategoryChildListItem> childListItems = new ArrayList<SubcategoryChildListItem>();
                            childListItems.add(new SubcategoryChildListItem(org.getType()));
                            subcategoryParentListItem.setChildItemList(childListItems);
                            parentListItems.add(subcategoryParentListItem);
                        }*/
                        for (int i=0; i<data.length();i++){
                            Group grup = Converter.convertGroup(data.getJSONObject(i));
                            yes.add(grup);
                        }
                        expendable.setVisibility(View.VISIBLE);
                        expendable.setLayoutManager(new LinearLayoutManager(getApplicationContext()));
                        TestAdapter tAdapt = new TestAdapter(getApplicationContext(), yes);
                        expendable.setAdapter(tAdapt);
                     /*   mAdapt = new ManifestAdapter(getApplicationContext(), parentListItems);
                        expendable.setAdapter(mAdapt);*/
                    }catch (JSONException e){
                        e.printStackTrace();
                    }
                }
            });

        }


    }

}
