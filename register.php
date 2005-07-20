<?php
require_once 'includes/init.php';
 
load_global_settings ();

if ( empty ( $allow_self_registration ) || $allow_self_registration != "Y" ) { 
  $error = "You are not authorized";
}

if ( empty ( $self_registration_full ) || $self_registration_full == "N" ) { 
  $self_registration_full = "N";
 $form_control = "email";
} else if ( $self_registration_full = "Y" ) {
 $form_control = "full";
}

//See if new username is unique
//return true if all is ok
function check_username ( $user ) {
  global $control, $error;
  if ( ! strlen ( $user ) ) {
   $errror = translate ( "Username can not be blank" );
  return false;
 } 
  $sql="SELECT cal_login FROM webcal_user WHERE cal_login='".$user."'";
  $res = dbi_query ( $sql );
  if ( $res ) {
    $row = dbi_fetch_row ( $res );
    if ( $row[0] == $user ) {
      $error = translate ( "Username already exists" );
      $control = "";
   return false;
    }
  }
 return true;
}

//See if  email is unique
//return true if all is ok
function check_email ( $uemail ) {
  global $control, $error;
  if ( ! strlen ( $uemail ) ) {
   $errror = translate ( "Email address can not be blank" );
  return false;
 } 
  $sql="SELECT cal_email FROM webcal_user WHERE cal_email='".$uemail."'";
  $res = dbi_query ( $sql );
  if ( $res ) {
    $row = dbi_fetch_row ( $res );
    if ( $row[0] == $uemail ) {
      $error = translate ( "Email address already exists" );
      $control = "";
   return false;
    }
  }
 return true;
}

//Generate unique password
function generate_password() {
  $pass_length = 7;
 $pass= '';
  $salt = "abchefghjkmnpqrstuvwxyz0123456789";
  srand((double)microtime()*1000000); 
   $i = 0;
   while ($i <= $pass_length) {
      $num = rand() % 33;
      $tmp = substr($salt, $num, 1);
      $pass = $pass . $tmp;
      $i++;
   }
   return $pass;
}

$user = "";
$upassword1 = "";
$upassword2 = "";
$ufirstname = "";
$ulastname = "";
$uemail = "";

// We can limit what domain is allowed to self register
// $self_registration_domain should have this format  "192.168.220.0:255.255.240.0";
if ( ! empty ( $self_registration_blacklist ) ) {
  $valid_ip = validate_domain ();
  if ( empty ( $valid_ip ) ) 
    $error = "You are not authorized";
}
//We could make $control a unique value if necessary
$control = getPostValue ( "control" );
//Process full account addition
if ( empty ( $error ) && ! empty ( $control ) && $control == "full" ) {
  $user = getPostValue ( "user" );
  $upassword1 = getPostValue ( "upassword1" );
  $upassword2 = getPostValue ( "upassword2" );
  $ufirstname = getPostValue ( "ufirstname" );
  $ulastname = getPostValue ( "ulastname" );
  $uemail = getPostValue ( "uemail" );
  $uis_admin = "N";
  // Do some checking og user info
 // Most of this is probably already handled by init.php
 if ( ! empty ( $user ) && ! empty ( $upassword1 ) ) {
    if ( get_magic_quotes_gpc() ) {
      $upassword1 = stripslashes ( $upassword1 );
      $user = stripslashes ( $user );
    }
    $user = trim ( $user );
    if ( $user != addslashes ( $user ) ) {
      $error = translate ( "Illegal characters in login" ) .
        "<tt>" . htmlentities ( $user ) . "</tt>";
    }
  } else if ( $upassword1 != $upassword2 ) { 
    $error = translate( "The passwords were not identical" ) . ".";
   $control = ""; 
  } else {
   //Check to make sure user doesn't already exist
   check_username ( $user );
 }

 if ( empty ( $error ) ) {
   user_add_user ( $user, $upassword1, $ufirstname, $ulastname,
     $uemail, $uis_admin );
  activity_log ( 0, 'admin', $user, LOG_NEWUSER_FULL, "New user via self-registration" );
 }
//Process account info for email submission
} else if ( empty ( $error ) && ! empty ( $control ) && $control == "email" ) { 
  $user = getPostValue ( "user" );
  $ufirstname = getPostValue ( "ufirstname" );
  $ulastname = getPostValue ( "ulastname" );
  $uemail = getPostValue ( "uemail" );
  $user = trim ( $user );
  $uis_admin = "N";
  if ( $user != addslashes ( $user ) ) {
    $error = translate ( "Illegal characters in login" ).
     "<tt>" . htmlentities ( $user ) . "</tt>";
  }

  //Check to make sure user doesn't already exist
  check_username ( $user );
  //Check to make sure email address doesn't already exist
  check_email ( $uemail );
 
  // need to generate unique passwords and email them to the new user 
  if ( empty ( $error ) ) {
    $new_pass = generate_password ();
   //TODO allow admin to approve account aand emails prior to processing
    user_add_user ( $user, $new_pass, $ufirstname, $ulastname,
      $uemail, $uis_admin );
   
   $msg = translate("Hello") . ", " . $ufirstname . " " . $ulastname . "\n\n";
   $msg .= translate("A new WebCalendar account has been set up for you"). ".\n\n";
   $msg .= translate("Your username is") . " \"" . $user . "\"\n\n";
   $msg .= translate("Your password is") . " \"" . $new_pass . "\"\n\n";
   $msg .= translate("Please visit") . " " . translate($application_name) . " " .
     translate("to log in and start using your account") . "!\n";
   // add URL to event, if we can figure it out
   if ( ! empty ( $server_url ) ) {
     $url = $server_url .  "login.php";
     $msg .= "\n\n" . $url;
   }
  $msg .= "\n\n" . translate("You may change your password after logging in the first time") . ".\n\n";
  $msg .= translate("If you received this email in error" ) . ".\n\n"; 
   if ( ! empty ( $email_fallback_from ) ) {
    $extra_hdrs = "From: $email_fallback_from\r\nX-Mailer: " . translate($application_name);
   } else {
    $extra_hdrs = "X-Mailer: " . translate($application_name);
   }
   mail ( $uemail,
     translate($application_name) . " " . translate("Welcome") . ": " . $ufirstname,
     html_to_8bits ($msg), $extra_hdrs );
   activity_log ( 0, 'admin', $user, LOG_NEWUSER_EMAIL, "New user via email" ); 
  }
}

print_header();

?>
<script type="text/javascript">
// error check login/password
function valid_form () {
  if ( document.selfreg.user.value.length == 0 || document.selfreg.upassword1.value.length == 0 || document.selfreg.upassword2.value.length == 0) {
    alert ( "<?php etranslate("You must enter a login and password")?>." );
    return false;
  }
  if ( document.selfreg.upassword1.value != document.selfreg.upassword2.value ) {
    alert ( "<?php etranslate("Your password do not match")?>." );
    return false;
  }
 
  return true;
}
</script>
<h2><?php 
// If Application Name is set to Title then get translation
// If not, use the Admin defined Application Name
if ( ! empty ( $application_name ) &&  $application_name =="Title") {
  etranslate($application_name);
} else {
  echo htmlspecialchars ( $application_name );
} 
echo " " . translate ( "Registration" ); 
?></h2>

<?php
if ( ! empty ( $error ) ) {
  print "<span style=\"color:#FF0000; font-weight:bold;\">" . 
    translate("Error") . ": $error</span><br />\n";
} else {
  print "<br /><br />\n";
}
?>
<?php if ( ! empty ($control ) && empty ( $error ) ) { ?>
<form action="login.php" method="post" >
<input  type="hidden" name="login" value="<?php echo $user ?>" />
<table align="center"  cellpadding="0" cellspacing="10">
<tr><td rowspan="3"><img src="register.gif"></td>

<td><?php etranslate("Welcome to WebCalendar")?></td></tr>
<?php if ( $self_registration_full == "Y" ) { ?>
  <tr><td colspan="3" align="center"><label><?php etranslate("Your email should arrive shortly")?></label><td></tr> 
<?php } ?>
<tr><td colspan="3" align="center">
  <input type="submit" value="<?php etranslate("Return to Login screen")?>" />
</td></tr>
</table>
</form>
<?php } else if ( empty ( $error ) ) { ?>
<form action="register.php" method="post" onsubmit="return valid_form()" name="selfreg">
<table align="center"  cellpadding="0" cellspacing="10">
<tr><td rowspan="3"><img src="register.gif"></td>
<input  type="hidden" name="control" value="<?php echo $form_control ?>" />
<td  align="right">
  <label for="user"><?php etranslate("Username")?>:</label></td>
  <td align="left"><input  type="text" name="user"  value="<?php echo $user ?>" size="20" maxlength="20" /></td></tr>
<tr><td  align="right">
  <label for="ufirstname"><?php etranslate("First Name")?>:</label></td>
  <td align="left"><input type="text" name="ufirstname" value="<?php echo $ufirstname ?>" size="25" maxlength="25" /></td></tr>
<tr><td  align="right">
  <label for="ulastname"><?php etranslate("Last Name")?>:</label></td>
  <td align="left"><input type="text" name="ulastname" value="<?php echo $ulastname ?>" size="25"  maxlength="25" /></td></tr>
<tr><td  align="right" colspan="2">
  <label for="uemail"><?php etranslate("E-mail address")?>:</label></td>
  <td align="left"><input type="text" name="uemail" value="<?php echo $uemail ?>" size="40"  maxlength="75" /></td></tr>
<?php if ( $self_registration_full == "Y" ) { ?>
  <tr><td  align="right" colspan="2">
    <label for="upassword1"><?php etranslate("Password")?>:</label></td>
    <td align="left"><input name="upassword1" value="<?php echo $upassword1 ?>" size="15"  type="password" /></td></tr>
  <tr><td  align="right" colspan="2">
    <label for="upassword2"><?php etranslate("Password")?> (<?php etranslate("again")?>):</label></td>
    <td align="left"><input name="upassword2" value="<?php echo $upassword2 ?>" size="15"  type="password" /></td></tr>
<?php } else { ?>  
  <tr><td colspan="3" align="center"><label><?php etranslate ( "Your account information will be emailed to you" ); ?></label></td></tr>
<?php } ?>
<tr><td colspan="3" align="center">
  <input type="submit" value="<?php etranslate("Submit")?>" />
</td></tr>
</table>

</form>

<?php } ?>
<br /><br /><br /><br /><br /><br /><br /><br />
<span class="cookies"><?php etranslate("cookies-note")?></span><br />
<hr />
<br /><br />
<a href="<?php echo $PROGRAM_URL ?>" id="programname"><?php echo $PROGRAM_NAME?></a>
<?php // Print custom trailer (since we do not call print_trailer function)
if ( ! empty ( $CUSTOM_TRAILER ) && $CUSTOM_TRAILER == 'Y' ) {
  $res = dbi_query (
    "SELECT cal_template_text FROM webcal_report_template " .
    "WHERE cal_template_type = 'T' and cal_report_id = 0" );
  if ( $res ) {
    if ( $row = dbi_fetch_row ( $res ) ) {
      echo $row[0];
    }
    dbi_free_result ( $res );
  }
} ?>
</body>
</html>
