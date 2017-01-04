package com.idesolusiasia.learnflux.activity;

import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONObject;

import java.util.HashMap;

public class RegisterActivity extends AppCompatActivity {

	TextView tvUsername, tvEmail, tvFirst, tvLast, tvPass, tvConfirm;
	Button btnRegister;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_register);
		tvUsername =(TextView) findViewById(R.id.username);
		tvEmail = (TextView) findViewById(R.id.email);
		tvFirst = (TextView) findViewById(R.id.firstName);
		tvLast = (TextView) findViewById(R.id.lastName);
		tvPass = (TextView) findViewById(R.id.password);
		tvConfirm = (TextView) findViewById(R.id.passwordConfirm);

		btnRegister= (Button) findViewById(R.id.btnRegister);
		btnRegister.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				inputChecking();
			}
		});
	}

	void inputChecking(){
		boolean pass = true;
		if (tvUsername.getText().toString().isEmpty() || tvUsername.getText().length()<5){
			pass=false;
			tvUsername.requestFocus();
			tvUsername.setError(getString(R.string.error_field_required));
		}
		if (tvEmail.getText().toString().isEmpty()){
			pass=false;
			tvEmail.requestFocus();
			tvEmail.setError(getString(R.string.error_field_required));
		}else if(!android.util.Patterns.EMAIL_ADDRESS.matcher(tvEmail.getText().toString()).matches()) {
			pass=false;
			tvEmail.requestFocus();
			tvEmail.setError(getString(R.string.error_invalid_email));
		}
		if (tvFirst.getText().toString().isEmpty()){
			pass=false;
			tvFirst.requestFocus();
			tvFirst.setError(getString(R.string.error_field_required));
		}
		if (tvLast.getText().toString().isEmpty()){
			pass=false;
			tvLast.requestFocus();
			tvLast.setError(getString(R.string.error_field_required));
		}
		if (tvPass.getText().toString().isEmpty()){
			pass=false;
			tvPass.requestFocus();
			tvPass.setError(getString(R.string.error_field_required));
		}else if (!tvPass.getText().toString().equals(tvConfirm.getText().toString())){
			pass=false;
			tvConfirm.requestFocus();
			tvConfirm.setError(getString(R.string.error_invalid_confirm));
		}

		if (pass){
			HashMap<String, String> par = new HashMap<>();
			par.put("username",tvUsername.getText().toString().trim());
			par.put("email",tvEmail.getText().toString().trim());
			par.put("firstName",tvFirst.getText().toString().trim());
			par.put("lastName",tvLast.getText().toString().trim());
			par.put("password",tvPass.getText().toString().trim());
			par.put("passwordConfirm",tvConfirm.getText().toString().trim());
			Engine.registerUser(this, par, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					Intent i = new Intent(RegisterActivity.this,LoginActivity.class);
					SharedPreferences prefs = getSharedPreferences("com.idesolusiasia.learnflux",0);
					SharedPreferences.Editor editor = prefs.edit();
					editor.putString("email",tvUsername.getText().toString().trim());
					editor.apply();
					i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP|Intent.FLAG_ACTIVITY_NEW_TASK);
					startActivity(i);
				}
			});
		}
	}

	@Override
	public void onBackPressed() {
		Intent i = new Intent(RegisterActivity.this,LoginActivity.class);
		i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP|Intent.FLAG_ACTIVITY_NEW_TASK);
		startActivity(i);
	}
}
