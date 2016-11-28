package com.idesolusiasia.learnflux;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.idesolusiasia.learnflux.adapter.ProjectListAdapter;

import java.util.ArrayList;

/**
 * Created by Ide Solusi Asia on 11/18/2016.
 */

public class ProjectActivity extends BaseActivity {
    ProjectListAdapter plAdapter;
    RecyclerView rcView;
    TextView emptyField;
    ProgressBar progress;   ArrayList<String>title = new ArrayList<>();
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

        rcView = (RecyclerView)findViewById(R.id.listOfProjectRecycler);
        emptyField = (TextView)findViewById(R.id.emptyProject);
        progress = (ProgressBar) findViewById(R.id.progressProject);

        LinearLayoutManager linear = new LinearLayoutManager(getApplicationContext(),LinearLayoutManager.VERTICAL,false);
        rcView.setLayoutManager(linear);
        //Dummy Data
        progress.setVisibility(View.VISIBLE);
        title.add("Old Folks Home");
        title.add("Animal Shelter");

        if(title!=null) {
            plAdapter = new ProjectListAdapter(getApplicationContext(), title);
            rcView.setAdapter(plAdapter);
            rcView.setVisibility(View.VISIBLE);
            emptyField.setVisibility(View.GONE);
            progress.setVisibility(View.GONE);
        }else{
            rcView.setVisibility(View.GONE);
            emptyField.setVisibility(View.VISIBLE);
            progress.setVisibility(View.VISIBLE);
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
