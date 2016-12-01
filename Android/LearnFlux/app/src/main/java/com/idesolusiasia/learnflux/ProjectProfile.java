package com.idesolusiasia.learnflux;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.text.method.ScrollingMovementMethod;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

/**
 * Created by Ide Solusi Asia on 11/21/2016.
 */

public class ProjectProfile extends BaseActivity {
    TextView projectProfileDesc;
    EditText comment;
    RecyclerView commentProfile;
    Button gotoProjectDetails;
    FloatingActionButton flbtn;
    ImageView joinProject, inviting;
    RelativeLayout lnm;
    @Override
    protected void onCreate( Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_base);
        super.onCreateDrawer(savedInstanceState);

        final FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
        final LayoutInflater layoutInflater = LayoutInflater.from(this);
        View childLayout = layoutInflater.inflate(
                R.layout.activity_project_profile, null);
        parentLayout.addView(childLayout);

        Toolbar toolbar = (Toolbar)findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        toolbar.setTitle("Projects");

        comment = (EditText)findViewById(R.id.comment);
        projectProfileDesc = (TextView)findViewById(R.id.descProjectProfile);
        gotoProjectDetails = (Button)findViewById(R.id.gotoProjectDetails);
        joinProject = (ImageView)findViewById(R.id.Profile_joinGroup);
        flbtn = (FloatingActionButton)findViewById(R.id.floatingButton);
        inviting = (ImageView)findViewById(R.id.inviteCollab);
        lnm = (RelativeLayout)findViewById(R.id.keyboard);
        commentProfile = (RecyclerView)findViewById(R.id.projectProfileRecycler);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);
        commentProfile.setLayoutManager(linearLayoutManager);
        flbtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                lnm.setVisibility(View.VISIBLE);
                flbtn.setVisibility(View.GONE);
                lnm.requestFocus();
                InputMethodManager inputManager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                inputManager.toggleSoftInput (InputMethodManager.SHOW_FORCED, InputMethodManager.HIDE_IMPLICIT_ONLY);

            }

        });

        gotoProjectDetails.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent a = new Intent(ProjectProfile.this, ProjectDetails.class);
                startActivity(a);
            }
        });
        joinProject.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(ProjectProfile.this, JoinInviteStakeHolders.class);
                i.putExtra("toolbar", "join");
                startActivity(i);
            }
        });
        inviting.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent o = new Intent(ProjectProfile.this, JoinInviteStakeHolders.class);
                o.putExtra("toolbar", "invite");
                startActivity(o);
            }
        });

    }

}
