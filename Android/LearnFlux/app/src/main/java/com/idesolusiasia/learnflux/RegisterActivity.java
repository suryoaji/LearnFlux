package com.idesolusiasia.learnflux;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.idesolusiasia.learnflux.util.Engine;

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
		if (tvUsername.getText().toString().isEmpty()){
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
			par.put("username",tvUsername.getText().toString());
			par.put("email",tvEmail.getText().toString());
			par.put("firstName",tvFirst.getText().toString());
			par.put("lastName",tvLast.getText().toString());
			par.put("password",tvPass.getText().toString());
			par.put("passwordConfirm",tvConfirm.getText().toString());
			Engine.registerUser(this, par);
		}
	}


}
